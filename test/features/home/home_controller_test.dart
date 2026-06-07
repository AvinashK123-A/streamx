import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import 'package:streamx/features/home/domain/entities/video.dart';
import 'package:streamx/features/home/domain/repositories/video_repository.dart';
import 'package:streamx/features/home/presentation/controllers/home_controller.dart';
import 'package:streamx/core/utils/failure.dart';

@GenerateMocks([VideoRepository])
import 'home_controller_test.mocks.dart';

void main() {
  late HomeController sut;
  late MockVideoRepository mockVideoRepository;

  final tVideos = [
    Video(
      id: 'v001',
      title: 'Big Buck Bunny',
      description: 'Test video',
      thumbnailUrl: 'https://example.com/thumb.jpg',
      videoUrl: 'https://example.com/video.mp4',
      duration: const Duration(minutes: 10),
      genre: 'Animation',
      releaseDate: DateTime(2008),
      isFeatured: true,
      isTrending: true,
    ),
    Video(
      id: 'v002',
      title: 'Sintel',
      description: 'Test video 2',
      thumbnailUrl: 'https://example.com/thumb2.jpg',
      videoUrl: 'https://example.com/video2.mp4',
      duration: const Duration(minutes: 14),
      genre: 'Fantasy',
      releaseDate: DateTime(2010),
      isFeatured: true,
      isTrending: true,
    ),
  ];

  setUp(() {
    mockVideoRepository = MockVideoRepository();
    when(mockVideoRepository.getFeaturedVideos()).thenAnswer((_) async => Right(tVideos.where((v) => v.isFeatured).toList()));
    when(mockVideoRepository.getTrendingVideos(page: anyNamed('page'))).thenAnswer((_) async => Right(tVideos.where((v) => v.isTrending).toList()));
    when(mockVideoRepository.getRecommendedVideos(page: anyNamed('page'))).thenAnswer((_) async => Right(tVideos));

    sut = HomeController(videoRepository: mockVideoRepository);
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeController - Loading', () {
    test('should load featured videos on init', () async {
      await sut.loadFeaturedVideos();
      expect(sut.featuredVideos.length, equals(2));
      expect(sut.featuredVideos.first.id, equals('v001'));
    });

    test('should set isLoadingFeatured correctly', () async {
      final future = sut.loadFeaturedVideos();
      expect(sut.isLoadingFeatured.value, true);
      await future;
      expect(sut.isLoadingFeatured.value, false);
    });

    test('should load trending videos', () async {
      await sut.loadTrendingVideos();
      expect(sut.trendingVideos.isNotEmpty, true);
    });

    test('should set hasError on failure', () async {
      when(mockVideoRepository.getFeaturedVideos())
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));

      await sut.loadFeaturedVideos();

      expect(sut.hasError.value, true);
      expect(sut.errorMessage.value, equals('Server error'));
    });

    test('should clear error on refresh', () async {
      sut.hasError.value = true;
      sut.errorMessage.value = 'Some error';

      when(mockVideoRepository.getFeaturedVideos()).thenAnswer((_) async => Right(tVideos));
      when(mockVideoRepository.getTrendingVideos(page: anyNamed('page'))).thenAnswer((_) async => Right(tVideos));
      when(mockVideoRepository.getRecommendedVideos(page: anyNamed('page'))).thenAnswer((_) async => Right(tVideos));

      await sut.onRefresh();

      expect(sut.hasError.value, false);
    });
  });

  group('HomeController - Banner', () {
    test('should update banner index', () {
      expect(sut.currentBannerIndex.value, 0);
      sut.onBannerPageChanged(1);
      expect(sut.currentBannerIndex.value, 1);
      sut.onBannerPageChanged(2);
      expect(sut.currentBannerIndex.value, 2);
    });
  });
}
