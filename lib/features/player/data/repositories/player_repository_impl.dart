import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/playback_state.dart';
import '../../domain/repositories/player_repository.dart';
import '../datasources/player_local_datasource.dart';

/// Concrete implementation of PlayerRepository
/// Stores watch progress in Hive local storage for offline access
class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerLocalDataSource _localDataSource;

  const PlayerRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, Unit>> saveWatchProgress(WatchProgress progress) async {
    try {
      await _localDataSource.saveWatchProgress(progress);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, WatchProgress?>> getWatchProgress(String videoId) async {
    try {
      final progress = await _localDataSource.getWatchProgress(videoId);
      return Right(progress);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<WatchProgress>>> getAllWatchProgress() async {
    try {
      final progress = await _localDataSource.getAllWatchProgress();
      return Right(progress);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteWatchProgress(String videoId) async {
    try {
      await _localDataSource.deleteWatchProgress(videoId);
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAllWatchProgress() async {
    try {
      await _localDataSource.clearAllWatchProgress();
      return const Right(unit);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> trackVideoView({
    required String videoId,
    required Duration watchTime,
    required bool completed,
  }) async {
    // Analytics tracking — fire and forget pattern
    // Actual implementation in AnalyticsService
    return const Right(unit);
  }
}
