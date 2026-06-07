import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

/// Analytics service wrapping Firebase Analytics
/// 
/// Tracks user behavior, screen views, video events, and engagement metrics.
/// All events follow a consistent naming convention for easy dashboard analysis.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService _instance = AnalyticsService._();
  static AnalyticsService get instance => _instance;

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final Logger _logger = Logger();

  void init() {
    _analytics.setAnalyticsCollectionEnabled(true);
  }

  // Screen Tracking
  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    await _analytics.logScreenView(screenName: screenName, screenClass: screenClass ?? screenName);
    _logger.d('Screen: $screenName');
  }

  // Authentication Events
  Future<void> logLogin(String method) async =>
      _analytics.logLogin(loginMethod: method);

  Future<void> logSignUp(String method) async =>
      _analytics.logSignUp(signUpMethod: method);

  Future<void> logLogout() async =>
      _analytics.logEvent(name: 'logout');

  // Video Events
  Future<void> logVideoStart({required String videoId, required String videoTitle}) async {
    await _analytics.logEvent(
      name: 'video_start',
      parameters: {'video_id': videoId, 'video_title': videoTitle, 'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
  }

  Future<void> logVideoProgress({
    required String videoId,
    required int watchedSeconds,
    required int totalSeconds,
  }) async {
    final completionPercent = totalSeconds > 0 ? (watchedSeconds / totalSeconds * 100).round() : 0;
    await _analytics.logEvent(
      name: 'video_progress',
      parameters: {
        'video_id': videoId,
        'watched_seconds': watchedSeconds,
        'total_seconds': totalSeconds,
        'completion_percent': completionPercent,
      },
    );
  }

  Future<void> logVideoComplete({required String videoId, required String videoTitle}) async {
    await _analytics.logEvent(
      name: 'video_complete',
      parameters: {'video_id': videoId, 'video_title': videoTitle},
    );
  }

  Future<void> logVideoPause({required String videoId, required int positionSeconds}) async {
    await _analytics.logEvent(
      name: 'video_pause',
      parameters: {'video_id': videoId, 'position_seconds': positionSeconds},
    );
  }

  Future<void> logVideoSeek({required String videoId, required int fromSeconds, required int toSeconds}) async {
    await _analytics.logEvent(
      name: 'video_seek',
      parameters: {'video_id': videoId, 'from': fromSeconds, 'to': toSeconds},
    );
  }

  Future<void> logQualityChange({required String videoId, required String quality}) async {
    await _analytics.logEvent(
      name: 'quality_change',
      parameters: {'video_id': videoId, 'quality': quality},
    );
  }

  Future<void> logPlaybackSpeedChange({required String videoId, required double speed}) async {
    await _analytics.logEvent(
      name: 'speed_change',
      parameters: {'video_id': videoId, 'speed': speed},
    );
  }

  // Search Events
  Future<void> logSearch({required String searchTerm, int resultCount = 0}) async {
    await _analytics.logSearch(searchTerm: searchTerm, numberOfResults: resultCount);
  }

  Future<void> logSearchResultClick({required String searchTerm, required String videoId}) async {
    await _analytics.logSelectContent(contentType: 'search_result', itemId: videoId);
  }

  // User Property Events
  Future<void> setUserId(String userId) async =>
      _analytics.setUserId(id: userId);

  Future<void> setUserProperty(String name, String value) async =>
      _analytics.setUserProperty(name: name, value: value);

  // Content Events
  Future<void> logSelectVideo({required String videoId, required String videoTitle}) async {
    await _analytics.logSelectContent(contentType: 'video', itemId: videoId);
  }
}
