import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/video.dart';
import '../repositories/video_repository.dart';

/// Parameters for recommendation use case
class RecommendationParams {
  final String userId;
  final List<String> watchedVideoIds;
  final List<String> preferredGenres;
  final int limit;

  const RecommendationParams({
    required this.userId,
    this.watchedVideoIds = const [],
    this.preferredGenres = const [],
    this.limit = 20,
  });
}

/// Use case: Get personalized video recommendations for a user
///
/// Business rule: Recommendations based on watch history and genre preferences.
/// Falls back to popular videos if no history is available.
class GetRecommendedVideosUseCase
    implements UseCase<List<Video>, RecommendationParams> {
  final VideoRepository _repository;

  const GetRecommendedVideosUseCase(this._repository);

  @override
  Future<Either<Failure, List<Video>>> call(RecommendationParams params) async {
    // Business rule: If no watch history, return popular videos as fallback
    if (params.watchedVideoIds.isEmpty) {
      return await _repository.getTrendingVideos();
    }
    return await _repository.getRecommendedVideos(params.userId);
  }
}
