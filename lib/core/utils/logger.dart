import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logging utility for StreamX
///
/// Uses the logger package with pretty formatting in debug,
/// and suppressed/minimal output in production.
class AppLogger {
  AppLogger._();

  static late final Logger _logger;
  static bool _initialized = false;

  /// Initialize the logger — call once in main()
  static void initialize({bool isProduction = false}) {
    if (_initialized) return;

    _logger = Logger(
      printer: isProduction
          ? SimplePrinter(printTime: true, colors: false)
          : PrettyPrinter(
              methodCount: 2,
              errorMethodCount: 8,
              lineLength: 120,
              colors: true,
              printEmojis: true,
              dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
            ),
      level: isProduction ? Level.warning : Level.trace,
      output: isProduction ? _ProductionOutput() : ConsoleOutput(),
    );

    _initialized = true;
  }

  /// Verbose/trace logging (development only)
  static void v(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    _ensureInitialized();
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Debug logging
  static void d(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    _ensureInitialized();
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Info logging
  static void i(String message, {Object? error, StackTrace? stackTrace}) {
    _ensureInitialized();
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Warning logging
  static void w(String message, {Object? error, StackTrace? stackTrace}) {
    _ensureInitialized();
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Error logging (also reported to Crashlytics in production)
  static void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) {
    _ensureInitialized();
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Network request/response logging (debug only)
  static void network(String message) {
    if (!kDebugMode) return;
    _ensureInitialized();
    _logger.d('[NETWORK] $message');
  }

  /// Analytics event logging (debug only)
  static void analytics(String eventName, Map<String, dynamic>? params) {
    if (!kDebugMode) return;
    _ensureInitialized();
    _logger.i('[ANALYTICS] $eventName | ${params ?? {}}');
  }

  static void _ensureInitialized() {
    if (!_initialized) initialize();
  }
}

/// Production output — sends to Crashlytics/console minimally
class _ProductionOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Only output warnings and errors in production
    if (event.level.index >= Level.warning.index) {
      for (final line in event.lines) {
        debugPrint(line);
      }
    }
  }
}
