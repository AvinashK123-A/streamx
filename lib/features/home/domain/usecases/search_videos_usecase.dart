import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/video.dart';
import '../repositories/video_repository.dart';

/// Parameters for the search use case
class SearchParams {
  final String query;
  final int page;
  final int limit;
  final String? genre;
  final String? sortBy;

  const SearchParams({
    required this.query,
    this.page = 1,
    this.limit = 20,
    this.genre,
    this.sortBy,
  });
}

/// Use case: Search for videos by query string
///
/// Business rules:
/// - Minimum query length: 2 characters
/// - Results are paginated (default 20 per page)
/// - Empty query returns popular videos
class SearchVideosUseCase implements UseCase<List<Video>, SearchParams> {
  final VideoRepository _repository;

  const SearchVideosUseCase(this._repository);

  @override
  Future<Either<Failure, List<Video>>> call(SearchParams params) async {
    // Business rule: Don't search with less than 2 characters
    if (params.query.trim().length < 2) {
      return const Right([]);
    }

    return await _repository.searchVideos(params.query);
  }
}
