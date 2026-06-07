import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/video.dart';
import '../repositories/video_repository.dart';

/// Use case: Get trending videos list
///
/// Business rule: Trending = videos with highest view count in last 7 days
class GetTrendingVideosUseCase implements UseCase<List<Video>, NoParams> {
  final VideoRepository _repository;

  const GetTrendingVideosUseCase(this._repository);

  @override
  Future<Either<Failure, List<Video>>> call(NoParams params) async {
    return await _repository.getTrendingVideos();
  }
}
