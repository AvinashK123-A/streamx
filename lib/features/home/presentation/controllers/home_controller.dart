import 'package:get/get.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/entities/video.dart';
import '../../domain/repositories/video_repository.dart';

/// Home screen controller managing all video content state
/// 
/// Handles featured banner, trending, recommended, and continue watching sections.
/// Implements pagination, lazy loading, and offline caching.
class HomeController extends GetxController {
  final VideoRepository _videoRepository;

  HomeController({required VideoRepository videoRepository})
      : _videoRepository = videoRepository;

  // ============ Reactive State ============
  final RxList<Video> featuredVideos = <Video>[].obs;
  final RxList<Video> trendingVideos = <Video>[].obs;
  final RxList<Video> recommendedVideos = <Video>[].obs;
  final RxList<Video> continueWatchingVideos = <Video>[].obs;

  final RxBool isLoadingFeatured = false.obs;
  final RxBool isLoadingTrending = false.obs;
  final RxBool isLoadingRecommended = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Banner auto-scroll
  final RxInt currentBannerIndex = 0.obs;

  // Pagination
  int _trendingPage = 1;
  int _recommendedPage = 1;
  final RxBool canLoadMoreTrending = true.obs;
  final RxBool canLoadMoreRecommended = true.obs;

  // ============ Lifecycle ============
  @override
  void onInit() {
    super.onInit();
    loadAllContent();
    AnalyticsService.instance.logScreenView('home');
  }

  // ============ Data Loading ============
  Future<void> loadAllContent() async {
    await Future.wait([
      loadFeaturedVideos(),
      loadTrendingVideos(),
      loadRecommendedVideos(),
    ]);
    _loadContinueWatching();
  }

  Future<void> loadFeaturedVideos() async {
    isLoadingFeatured.value = true;
    final result = await _videoRepository.getFeaturedVideos();
    result.fold(
      (failure) {
        hasError.value = true;
        errorMessage.value = failure.message;
      },
      (videos) => featuredVideos.assignAll(videos),
    );
    isLoadingFeatured.value = false;
  }

  Future<void> loadTrendingVideos({bool refresh = false}) async {
    if (refresh) {
      _trendingPage = 1;
      trendingVideos.clear();
      canLoadMoreTrending.value = true;
    }
    if (!canLoadMoreTrending.value) return;
    isLoadingTrending.value = true;
    final result = await _videoRepository.getTrendingVideos(page: _trendingPage);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (videos) {
        if (videos.isEmpty) {
          canLoadMoreTrending.value = false;
        } else {
          trendingVideos.addAll(videos);
          _trendingPage++;
        }
      },
    );
    isLoadingTrending.value = false;
  }

  Future<void> loadRecommendedVideos({bool refresh = false}) async {
    if (refresh) {
      _recommendedPage = 1;
      recommendedVideos.clear();
      canLoadMoreRecommended.value = true;
    }
    if (!canLoadMoreRecommended.value) return;
    final result = await _videoRepository.getRecommendedVideos(page: _recommendedPage);
    result.fold(
      (failure) => errorMessage.value = failure.message,
      (videos) {
        if (videos.isEmpty) {
          canLoadMoreRecommended.value = false;
        } else {
          recommendedVideos.addAll(videos);
          _recommendedPage++;
        }
      },
    );
  }

  void _loadContinueWatching() {
    final history = HiveStorage.getWatchHistory();
    if (history.isEmpty) return;
    // Filter to videos with incomplete watch progress (< 95%)
    final incompleteVideos = history.where((h) {
      final position = (h['position'] as num?)?.toInt() ?? 0;
      final total = (h['total'] as num?)?.toInt() ?? 1;
      final percent = total > 0 ? position / total : 0;
      return percent > 0.05 && percent < 0.95;
    }).toList();
    // In a real app, fetch video details for these IDs
    // For demo, just load first few trending videos as "continue watching"
    if (trendingVideos.isNotEmpty) {
      continueWatchingVideos.assignAll(trendingVideos.take(3).toList());
    }
  }

  // ============ Navigation ============
  void onVideoTap(Video video) {
    AnalyticsService.instance.logSelectVideo(videoId: video.id, videoTitle: video.title);
    Get.toNamed(AppRoutes.player, arguments: video);
  }

  void onSearchTap() => Get.toNamed(AppRoutes.search);
  void onProfileTap() => Get.toNamed(AppRoutes.profile);

  // ============ Banner ============
  void onBannerPageChanged(int index) => currentBannerIndex.value = index;

  // ============ Refresh ============
  Future<void> onRefresh() async {
    hasError.value = false;
    await loadAllContent();
  }
}
