import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Logging interceptor for request/response logging in debug mode
class LoggingInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d(
      '[REQUEST] ${options.method} ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Data: ${options.data}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i(
      '[RESPONSE] ${response.statusCode} ${response.requestOptions.uri}\n'
      'Data: ${response.data.toString().substring(0, response.data.toString().length.clamp(0, 200))}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '[ERROR] ${err.response?.statusCode} ${err.requestOptions.uri}\n'
      'Message: ${err.message}\n'
      'Response: ${err.response?.data}',
    );
    handler.next(err);
  }
}
