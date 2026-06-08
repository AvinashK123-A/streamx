import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/playback_state.dart';
import '../repositories/player_repository.dart';

/// Use case: Save video watch progress for "Continue Watching" feature
///
/// Business rule: Only save progress if > 5% watched and < 95% (not completed).
/// Completed videos are removed from "Continue Watching".
class SaveWatchProgressUseCase implements UseCase<Unit, WatchProgress> {
  final PlayerRepository _repository;

  const SaveWatchProgressUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(WatchProgress params) async {
    // Business rule: Don't save if barely started (< 5%)
    if (params.progressPercent < 0.05) {
      return const Right(unit);
    }

    // Business rule: Remove from Continue Watching if completed (> 95%)
    if (params.isCompleted) {
      return await _repository.deleteWatchProgress(params.videoId);
    }

    return await _repository.saveWatchProgress(params);
  }
}
