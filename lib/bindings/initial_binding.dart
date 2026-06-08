import 'package:get/get.dart';
import '../core/network/dio_client.dart';
import '../core/storage/secure_storage.dart';
import '../core/storage/hive_storage.dart';
import '../core/services/analytics_service.dart';
import '../core/services/crashlytics_service.dart';
import '../core/services/notification_service.dart';
import '../core/services/remote_config_service.dart';

/// Initial binding — wires all app-wide singletons at startup
///
/// These dependencies are available throughout the entire app lifecycle.
/// Feature-specific dependencies are lazy-loaded via feature bindings.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ============================================================
    // Core Infrastructure (Permanent singletons)
    // ============================================================

    // Secure token storage (Keychain / EncryptedSharedPrefs)
    Get.put<SecureStorage>(
      SecureStorageImpl(),
      permanent: true,
    );

    // Hive local database
    Get.put<HiveStorage>(
      HiveStorageImpl(),
      permanent: true,
    );

    // Dio HTTP client (with all interceptors wired)
    Get.put<DioClient>(
      DioClient(),
      permanent: true,
    );

    // ============================================================
    // Firebase Services (Permanent singletons)
    // ============================================================

    // Analytics — track screen views, events, user properties
    Get.put<AnalyticsService>(
      AnalyticsServiceImpl(),
      permanent: true,
    );

    // Crashlytics — automatic crash and error reporting
    Get.put<CrashlyticsService>(
      CrashlyticsServiceImpl(),
      permanent: true,
    );

    // Push Notifications — FCM token management, foreground handling
    Get.put<NotificationService>(
      NotificationServiceImpl(),
      permanent: true,
    );

    // Remote Config — feature flags and dynamic config from Firebase
    Get.put<RemoteConfigService>(
      RemoteConfigServiceImpl(),
      permanent: true,
    );
  }
}
