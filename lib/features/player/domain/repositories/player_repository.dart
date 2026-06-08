import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../entities/playback_state.dart';

/// Abstract repository interface for player operations
/// Defined in domain layer — data layer provides implementation
abstract class PlayerRepository {
  /// Save watch progress for resume functionality
  Future<Either<Failure, Unit>> saveWatchProgress(WatchProgress progress);

  /// Load saved watch progress for a video
  Future<Either<Failure, WatchProgress?>> getWatchProgress(String videoId);

  /// Get all saved watch progress (for "Continue Watching" feature)
  Future<Either<Failure, List<WatchProgress>>> getAllWatchProgress();

  /// Delete watch progress for a specific video
  Future<Either<Failure, Unit>> deleteWatchProgress(String videoId);

  /// Clear all watch progress (user logout)
  Future<Either<Failure, Unit>> clearAllWatchProgress();

  /// Track video view analytics event
  Future<Either<Failure, Unit>> trackVideoView({
    required String videoId,
    required Duration watchTime,
    required bool completed,
  });
}
