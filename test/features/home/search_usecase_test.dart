import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:streamx/core/utils/failure.dart';
import 'package:streamx/features/home/domain/entities/video.dart';
import 'package:streamx/features/home/domain/repositories/video_repository.dart';
import 'package:streamx/features/home/domain/usecases/search_videos_usecase.dart';

import 'search_usecase_test.mocks.dart';

@GenerateMocks([VideoRepository])
void main() {
  late MockVideoRepository mockVideoRepository;
  late SearchVideosUseCase searchVideosUseCase;

  setUp(() {
    mockVideoRepository = MockVideoRepository();
    searchVideosUseCase = SearchVideosUseCase(mockVideoRepository);
  });

  const testVideos = [
    Video(
      id: 'v1',
      title: 'Big Buck Bunny',
      description: 'A comedy short film.',
      thumbnailUrl: 'https://example.com/thumb1.jpg',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      duration: 596,
      genre: 'Animation',
    ),
    Video(
      id: 'v2',
      title: 'Sintel',
      description: 'A fantasy short film.',
      thumbnailUrl: 'https://example.com/thumb2.jpg',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      duration: 888,
      genre: 'Fantasy',
    ),
  ];

  group('SearchVideosUseCase', () {
    test('should return videos matching the query', () async {
      // Arrange
      const query = 'Bunny';
      when(mockVideoRepository.searchVideos(query))
          .thenAnswer((_) async => const Right(testVideos));

      // Act
      final result = await searchVideosUseCase(
        const SearchParams(query: query),
      );

      // Assert
      expect(result, const Right(testVideos));
      verify(mockVideoRepository.searchVideos(query)).called(1);
    });

    test('should return empty list for single character query (business rule)', () async {
      // Business rule: queries < 2 chars return empty without hitting repository
      final result = await searchVideosUseCase(
        const SearchParams(query: 'a'),
      );

      // Assert — repository should NOT be called
      expect(result, const Right(<Video>[]));
      verifyNever(mockVideoRepository.searchVideos(any));
    });

    test('should return empty list for empty query (business rule)', () async {
      final result = await searchVideosUseCase(
        const SearchParams(query: ''),
      );

      expect(result, const Right(<Video>[]));
      verifyNever(mockVideoRepository.searchVideos(any));
    });

    test('should return empty list for whitespace-only query', () async {
      final result = await searchVideosUseCase(
        const SearchParams(query: '   '),
      );

      expect(result, const Right(<Video>[]));
      verifyNever(mockVideoRepository.searchVideos(any));
    });

    test('should call repository with trimmed query', () async {
      // Arrange
      when(mockVideoRepository.searchVideos('Bunny'))
          .thenAnswer((_) async => const Right(testVideos));

      // Act
      await searchVideosUseCase(
        const SearchParams(query: '  Bunny  '),
      );

      // Note: The use case should trim the query before passing to repository
      verify(mockVideoRepository.searchVideos('Bunny')).called(1);
    });

    test('should return NetworkFailure when no internet', () async {
      // Arrange
      when(mockVideoRepository.searchVideos(any))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await searchVideosUseCase(
        const SearchParams(query: 'test'),
      );

      // Assert
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should have returned a failure'),
      );
    });

    test('should return empty list when no videos match', () async {
      // Arrange
      when(mockVideoRepository.searchVideos(any))
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await searchVideosUseCase(
        const SearchParams(query: 'nonexistentmovie'),
      );

      // Assert
      result.fold(
        (failure) => fail('Should not return a failure'),
        (videos) => expect(videos, isEmpty),
      );
    });

    test('should handle query with exactly 2 characters (boundary)', () async {
      // Arrange
      const query = 'ab';
      when(mockVideoRepository.searchVideos(query))
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await searchVideosUseCase(
        const SearchParams(query: query),
      );

      // Assert — 2 characters IS valid, should call repository
      verify(mockVideoRepository.searchVideos(query)).called(1);
    });
  });
}
