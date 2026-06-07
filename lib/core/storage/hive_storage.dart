import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

/// Hive local database service for non-sensitive persistent data
class HiveStorage {
  HiveStorage._();

  static late Box<dynamic> _watchHistoryBox;
  static late Box<dynamic> _searchHistoryBox;
  static late Box<dynamic> _settingsBox;
  static late Box<dynamic> _videoCacheBox;

  static Future<void> init() async {
    _watchHistoryBox = await Hive.openBox(AppConstants.watchHistoryBox);
    _searchHistoryBox = await Hive.openBox(AppConstants.searchHistoryBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
    _videoCacheBox = await Hive.openBox(AppConstants.videoCacheBox);
  }

  // Watch History
  static List<Map<dynamic, dynamic>> getWatchHistory() {
    return _watchHistoryBox.values.cast<Map<dynamic, dynamic>>().toList();
  }

  static Future<void> saveWatchProgress(String videoId, int positionSeconds, int totalSeconds) async {
    await _watchHistoryBox.put(videoId, {
      'videoId': videoId,
      'position': positionSeconds,
      'total': totalSeconds,
      'watchedAt': DateTime.now().toIso8601String(),
    });
  }

  static Map<dynamic, dynamic>? getWatchProgress(String videoId) {
    return _watchHistoryBox.get(videoId) as Map<dynamic, dynamic>?;
  }

  static Future<void> removeFromWatchHistory(String videoId) async {
    await _watchHistoryBox.delete(videoId);
  }

  static Future<void> clearWatchHistory() async {
    await _watchHistoryBox.clear();
  }

  // Search History
  static List<String> getSearchHistory() {
    return _searchHistoryBox.values.cast<String>().toList().reversed.toList();
  }

  static Future<void> saveSearchQuery(String query) async {
    if (query.isEmpty) return;
    // Remove if exists to avoid duplicates (will be re-added at front)
    await _searchHistoryBox.delete(query);
    await _searchHistoryBox.put(query, query);
    // Keep only last 20 searches
    if (_searchHistoryBox.length > 20) {
      await _searchHistoryBox.deleteAt(0);
    }
  }

  static Future<void> removeSearchQuery(String query) async {
    await _searchHistoryBox.delete(query);
  }

  static Future<void> clearSearchHistory() async {
    await _searchHistoryBox.clear();
  }

  // Settings
  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }

  static Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  // Video Cache Metadata
  static Future<void> cacheVideoMetadata(String videoId, Map<String, dynamic> data) async {
    await _videoCacheBox.put(videoId, data);
  }

  static Map<dynamic, dynamic>? getCachedVideoMetadata(String videoId) {
    return _videoCacheBox.get(videoId) as Map<dynamic, dynamic>?;
  }

  static Future<void> clearVideoCache() async {
    await _videoCacheBox.clear();
  }
}
