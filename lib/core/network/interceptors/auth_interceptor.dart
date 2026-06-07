import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';
import '../../constants/app_constants.dart';

/// Authentication interceptor for automatic token injection and refresh
/// 
/// Handles:
/// - Bearer token injection in all requests
/// - Automatic token refresh on 401 responses
/// - Retry failed requests after token refresh
/// - Session timeout handling
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  AuthInterceptor(this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    final token = await SecureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (_isRefreshing) {
        // Queue the request while refreshing
        _pendingRequests.add(err.requestOptions);
        return;
      }

      _isRefreshing = true;

      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the original request with new token
          final token = await SecureStorage.getAccessToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          
          final response = await _dio.request(
            err.requestOptions.path,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );

          // Retry pending requests
          for (final req in _pendingRequests) {
            req.headers['Authorization'] = 'Bearer $token';
          }
          _pendingRequests.clear();

          handler.resolve(response);
        } else {
          await _handleSessionExpired();
          handler.reject(err);
        }
      } catch (e) {
        await _handleSessionExpired();
        handler.reject(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {'Authorization': null}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await SecureStorage.saveAccessToken(data['access_token']);
        if (data['refresh_token'] != null) {
          await SecureStorage.saveRefreshToken(data['refresh_token']);
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _handleSessionExpired() async {
    await SecureStorage.clearTokens();
    // Navigate to login - handled by GetX navigation
  }

  bool _isPublicEndpoint(String path) {
    const publicPaths = ['/auth/login', '/auth/register', '/auth/refresh', '/videos/featured'];
    return publicPaths.any((p) => path.contains(p));
  }
}
