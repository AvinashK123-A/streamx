import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../entities/video.dart';

abstract class VideoRepository {
  Future<Either<Failure, List<Video>>> getFeaturedVideos();
  Future<Either<Failure, List<Video>>> getTrendingVideos({int page = 1, int limit = 10});
  Future<Either<Failure, List<Video>>> getRecommendedVideos({int page = 1, int limit = 20});
  Future<Either<Failure, List<Video>>> searchVideos({required String query, int page = 1});
  Future<Either<Failure, Video>> getVideoById(String id);
  Future<Either<Failure, List<Video>>> getVideosByGenre(String genre);
}
