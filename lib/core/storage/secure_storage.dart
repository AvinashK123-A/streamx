import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

/// Secure storage service for sensitive data like tokens
/// 
/// Uses flutter_secure_storage which leverages:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences / Keystore
class SecureStorage {
  SecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static Future<void> init() async {
    // Verify storage is accessible
    await _storage.containsKey(key: 'init_check');
  }

  // Access Token
  static Future<void> saveAccessToken(String token) async =>
      _storage.write(key: AppConstants.accessTokenKey, value: token);

  static Future<String?> getAccessToken() async =>
      _storage.read(key: AppConstants.accessTokenKey);

  // Refresh Token
  static Future<void> saveRefreshToken(String token) async =>
      _storage.write(key: AppConstants.refreshTokenKey, value: token);

  static Future<String?> getRefreshToken() async =>
      _storage.read(key: AppConstants.refreshTokenKey);

  // User Data
  static Future<void> saveUserId(String id) async =>
      _storage.write(key: AppConstants.userIdKey, value: id);

  static Future<String?> getUserId() async =>
      _storage.read(key: AppConstants.userIdKey);

  static Future<void> saveUserEmail(String email) async =>
      _storage.write(key: AppConstants.userEmailKey, value: email);

  static Future<String?> getUserEmail() async =>
      _storage.read(key: AppConstants.userEmailKey);

  // Remember Me
  static Future<void> setRememberMe(bool value) async =>
      _storage.write(key: AppConstants.rememberMeKey, value: value.toString());

  static Future<bool> getRememberMe() async {
    final value = await _storage.read(key: AppConstants.rememberMeKey);
    return value == 'true';
  }

  // Clear operations
  static Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: AppConstants.accessTokenKey),
      _storage.delete(key: AppConstants.refreshTokenKey),
    ]);
  }

  static Future<void> clearAll() async => _storage.deleteAll();

  // Check if authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Check if remember me is set and restore session
  static Future<bool> canAutoLogin() async {
    final rememberMe = await getRememberMe();
    if (!rememberMe) return false;
    return isAuthenticated();
  }
}
