import 'package:flutter/foundation.dart';

/// Application environment enum
enum AppEnvironment { development, staging, production }

/// Central application configuration
///
/// Reads from dart-define environment variables injected at build time.
/// Never hardcode secrets. Always use CI/CD secrets injection.
class AppConfig {
  AppConfig._();

  // ============================================================
  // Environment Detection
  // ============================================================

  static const String _environment =
      String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');

  static AppEnvironment get environment {
    switch (_environment) {
      case 'production':
        return AppEnvironment.production;
      case 'staging':
        return AppEnvironment.staging;
      default:
        return AppEnvironment.development;
    }
  }

  static bool get isProduction => environment == AppEnvironment.production;
  static bool get isStaging => environment == AppEnvironment.staging;
  static bool get isDevelopment => environment == AppEnvironment.development;
  static bool get isDebug => kDebugMode;

  // ============================================================
  // API Configuration
  // ============================================================

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/api/v1',
  );

  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: 'dev_api_key',
  );

  static const int apiTimeoutMs = int.fromEnvironment(
    'API_TIMEOUT',
    defaultValue: 30000,
  );

  // ============================================================
  // Firebase Configuration
  // ============================================================

  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'streamx-dev',
  );

  static const String fcmSenderId = String.fromEnvironment(
    'FCM_SENDER_ID',
    defaultValue: '',
  );

  // ============================================================
  // Video Configuration
  // ============================================================

  static const String videoCdnBaseUrl = String.fromEnvironment(
    'VIDEO_CDN_BASE_URL',
    defaultValue:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample',
  );

  static const int videoBufferSizeMb = int.fromEnvironment(
    'VIDEO_BUFFER_SIZE_MB',
    defaultValue: 10,
  );

  static const int videoMaxCacheSizeMb = int.fromEnvironment(
    'VIDEO_MAX_CACHE_SIZE_MB',
    defaultValue: 500,
  );

  // ============================================================
  // Feature Flags
  // ============================================================

  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );

  static const bool enableCrashlytics = bool.fromEnvironment(
    'ENABLE_CRASHLYTICS',
    defaultValue: false,
  );

  static const bool enablePerformanceMonitoring = bool.fromEnvironment(
    'ENABLE_PERFORMANCE_MONITORING',
    defaultValue: false,
  );

  static const bool enableRemoteConfig = bool.fromEnvironment(
    'ENABLE_REMOTE_CONFIG',
    defaultValue: false,
  );

  static const bool enableCertificatePinning = bool.fromEnvironment(
    'ENABLE_CERTIFICATE_PINNING',
    defaultValue: false,
  );

  static const bool enableScreenshotPrevention = bool.fromEnvironment(
    'ENABLE_SCREENSHOT_PREVENTION',
    defaultValue: false,
  );

  // ============================================================
  // Auth Configuration
  // ============================================================

  static const int tokenRefreshThresholdMinutes = int.fromEnvironment(
    'TOKEN_REFRESH_THRESHOLD_MINUTES',
    defaultValue: 5,
  );

  static const int sessionTimeoutMinutes = int.fromEnvironment(
    'SESSION_TIMEOUT_MINUTES',
    defaultValue: 60,
  );

  static const int maxLoginAttempts = int.fromEnvironment(
    'MAX_LOGIN_ATTEMPTS',
    defaultValue: 5,
  );

  // ============================================================
  // SSL Certificate Pins (for certificate pinning)
  // ============================================================

  static const String sslCertPin = String.fromEnvironment(
    'SSL_CERTIFICATE_PIN',
    defaultValue: '',
  );

  static const String sslCertPinBackup = String.fromEnvironment(
    'SSL_CERTIFICATE_PIN_BACKUP',
    defaultValue: '',
  );

  // ============================================================
  // App Info
  // ============================================================

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'StreamX',
  );

  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );

  // ============================================================
  // Debug Helpers
  // ============================================================

  /// Print current configuration (only in debug mode)
  static void printConfig() {
    if (!kDebugMode) return;
    debugPrint('========== StreamX Config ==========');
    debugPrint('Environment: $_environment');
    debugPrint('Base URL: $baseUrl');
    debugPrint('Firebase Project: $firebaseProjectId');
    debugPrint('Analytics: $enableAnalytics');
    debugPrint('Crashlytics: $enableCrashlytics');
    debugPrint('Certificate Pinning: $enableCertificatePinning');
    debugPrint('=====================================');
  }
}
