import 'package:dio/dio.dart';

/// Retry interceptor for automatic request retry on network errors
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor(this._dio, {this.maxRetries = 3, this.retryDelay = const Duration(seconds: 1)});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
    if (_shouldRetry(err) && retryCount < maxRetries) {
      await Future.delayed(retryDelay * (retryCount + 1));
      err.requestOptions.extra['retryCount'] = retryCount + 1;
      try {
        final response = await _dio.request(
          err.requestOptions.path,
          options: Options(method: err.requestOptions.method, headers: err.requestOptions.headers, extra: err.requestOptions.extra),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );
        handler.resolve(response);
      } catch (e) { handler.next(err); }
    } else { handler.next(err); }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}
