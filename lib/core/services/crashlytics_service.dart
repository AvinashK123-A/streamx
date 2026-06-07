import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Crashlytics service for crash reporting and error tracking
class CrashlyticsService {
  CrashlyticsService._();
  static final CrashlyticsService _instance = CrashlyticsService._();
  static CrashlyticsService get instance => _instance;

  void init() {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  Future<void> recordError(dynamic exception, StackTrace? stackTrace, {String? reason, bool fatal = false}) async {
    await FirebaseCrashlytics.instance.recordError(exception, stackTrace, reason: reason, fatal: fatal);
  }

  Future<void> log(String message) async =>
      FirebaseCrashlytics.instance.log(message);

  Future<void> setUserId(String userId) async =>
      FirebaseCrashlytics.instance.setUserIdentifier(userId);

  Future<void> setCustomKey(String key, dynamic value) async =>
      FirebaseCrashlytics.instance.setCustomKey(key, value);
}
