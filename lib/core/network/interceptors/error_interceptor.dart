import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../constants/app_constants.dart';
import '../../utils/failure.dart';

/// Error interceptor for centralized error handling and transformation
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapErrorToFailure(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: failure,
        message: failure.message,
      ),
    );
  }

  Failure _mapErrorToFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const NetworkFailure(AppConstants.networkError);
      case DioExceptionType.badResponse:
        return _handleBadResponse(err.response);
      case DioExceptionType.cancel:
        return const NetworkFailure('Request cancelled');
      default:
        return ServerFailure(err.message ?? AppConstants.unknownError);
    }
  }

  Failure _handleBadResponse(Response? response) {
    if (response == null) return const ServerFailure(AppConstants.serverError);

    switch (response.statusCode) {
      case 400:
        final message = response.data?['message'] ?? AppConstants.validationError;
        return ValidationFailure(message);
      case 401:
        return const AuthFailure(AppConstants.sessionExpired);
      case 403:
        return const AuthFailure('Access denied');
      case 404:
        return const ServerFailure('Resource not found');
      case 422:
        final errors = response.data?['errors'];
        final message = errors != null ? errors.toString() : AppConstants.validationError;
        return ValidationFailure(message);
      case 429:
        return const NetworkFailure('Too many requests. Please slow down.');
      case 500:
      case 502:
      case 503:
        return const ServerFailure(AppConstants.serverError);
      default:
        return ServerFailure(response.data?['message'] ?? AppConstants.unknownError);
    }
  }
}
