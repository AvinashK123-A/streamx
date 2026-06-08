import 'package:hive/hive.dart';
import '../../domain/entities/playback_state.dart';

/// Abstract contract for local player data operations
abstract class PlayerLocalDataSource {
  Future<void> saveWatchProgress(WatchProgress progress);
  Future<WatchProgress?> getWatchProgress(String videoId);
  Future<List<WatchProgress>> getAllWatchProgress();
  Future<void> deleteWatchProgress(String videoId);
  Future<void> clearAllWatchProgress();
}

/// Hive implementation of PlayerLocalDataSource
class PlayerLocalDataSourceImpl implements PlayerLocalDataSource {
  static const String _boxName = 'watch_progress';

  Future<Box> get _box async => await Hive.openBox(_boxName);

  @override
  Future<void> saveWatchProgress(WatchProgress progress) async {
    final box = await _box;
    await box.put(progress.videoId, {
      'videoId': progress.videoId,
      'positionMs': progress.position.inMilliseconds,
      'durationMs': progress.duration.inMilliseconds,
      'lastWatchedAt': progress.lastWatchedAt.toIso8601String(),
    });
  }

  @override
  Future<WatchProgress?> getWatchProgress(String videoId) async {
    final box = await _box;
    final data = box.get(videoId) as Map?;
    if (data == null) return null;
    return _mapToWatchProgress(data);
  }

  @override
  Future<List<WatchProgress>> getAllWatchProgress() async {
    final box = await _box;
    final allEntries = box.values
        .whereType<Map>()
        .map(_mapToWatchProgress)
        .toList();

    // Sort by last watched — most recent first
    allEntries.sort((a, b) => b.lastWatchedAt.compareTo(a.lastWatchedAt));
    return allEntries;
  }

  @override
  Future<void> deleteWatchProgress(String videoId) async {
    final box = await _box;
    await box.delete(videoId);
  }

  @override
  Future<void> clearAllWatchProgress() async {
    final box = await _box;
    await box.clear();
  }

  WatchProgress _mapToWatchProgress(Map data) {
    return WatchProgress(
      videoId: data['videoId'] as String,
      position: Duration(milliseconds: data['positionMs'] as int),
      duration: Duration(milliseconds: data['durationMs'] as int),
      lastWatchedAt: DateTime.parse(data['lastWatchedAt'] as String),
    );
  }
}
