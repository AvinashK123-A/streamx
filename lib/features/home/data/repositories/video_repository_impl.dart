import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/entities/video.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_datasource.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoDataSource _dataSource;
  VideoRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Video>>> getFeaturedVideos() async {
    try {
      final dtos = await _dataSource.getFeaturedVideos();
      return Right(dtos.map((d) => d.toDomain()).toList());
    } catch (e) { return Left(ServerFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, List<Video>>> getTrendingVideos({int page = 1, int limit = 10}) async {
    try {
      final dtos = await _dataSource.getTrendingVideos(page: page, limit: limit);
      return Right(dtos.map((d) => d.toDomain()).toList());
    } catch (e) { return Left(ServerFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, List<Video>>> getRecommendedVideos({int page = 1, int limit = 20}) async {
    try {
      final dtos = await _dataSource.getRecommendedVideos(page: page, limit: limit);
      return Right(dtos.map((d) => d.toDomain()).toList());
    } catch (e) { return Left(ServerFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, List<Video>>> searchVideos({required String query, int page = 1}) async {
    try {
      final dtos = await _dataSource.searchVideos(query: query, page: page);
      return Right(dtos.map((d) => d.toDomain()).toList());
    } catch (e) { return Left(ServerFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, Video>> getVideoById(String id) async {
    try {
      final dto = await _dataSource.getVideoById(id);
      return Right(dto.toDomain());
    } catch (e) { return Left(NotFoundFailure(e.toString())); }
  }

  @override
  Future<Either<Failure, List<Video>>> getVideosByGenre(String genre) async {
    try {
      final dtos = await _dataSource.getVideosByGenre(genre);
      return Right(dtos.map((d) => d.toDomain()).toList());
    } catch (e) { return Left(ServerFailure(e.toString())); }
  }
}
