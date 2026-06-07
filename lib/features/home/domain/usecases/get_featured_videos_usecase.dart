import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/video.dart';
import '../repositories/video_repository.dart';

/// Use case: Get featured/hero banner videos for home screen
///
/// Part of Clean Architecture domain layer.
/// Contains ONLY business logic, zero Flutter/framework imports.
class GetFeaturedVideosUseCase implements UseCase<List<Video>, NoParams> {
  final VideoRepository _repository;

  const GetFeaturedVideosUseCase(this._repository);

  @override
  Future<Either<Failure, List<Video>>> call(NoParams params) async {
    return await _repository.getFeaturedVideos();
  }
}
