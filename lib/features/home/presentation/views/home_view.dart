import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/video.dart';
import '../controllers/home_controller.dart';
import '../widgets/video_card.dart';
import '../widgets/featured_banner.dart';
import '../widgets/video_row.dart';

/// Home Screen - Netflix-style streaming interface
/// 
/// Features:
/// - Auto-scrolling featured banner
/// - Horizontally scrollable video rows
/// - Continue watching section
/// - Trending now section
/// - Recommended for you section
/// - Pull-to-refresh
/// - Shimmer loading skeleton
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        color: AppConstants.primaryColor,
        backgroundColor: AppConstants.surfaceColor,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: _buildAppBar(context),
              expandedHeight: 56,
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Banner
                  Obx(() => controller.isLoadingFeatured.value
                    ? _buildFeaturedSkeleton()
                    : controller.featuredVideos.isNotEmpty
                        ? FeaturedBanner(
                            videos: controller.featuredVideos,
                            currentIndex: controller.currentBannerIndex.value,
                            onPageChanged: controller.onBannerPageChanged,
                            onVideoTap: controller.onVideoTap,
                          )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 24),

                  // Continue Watching
                  Obx(() => controller.continueWatchingVideos.isNotEmpty
                    ? VideoRow(
                        title: 'Continue Watching',
                        videos: controller.continueWatchingVideos,
                        onVideoTap: controller.onVideoTap,
                        showProgress: true,
                      )
                    : const SizedBox.shrink(),
                  ),

                  // Trending Now
                  Obx(() => controller.isLoadingTrending.value && controller.trendingVideos.isEmpty
                    ? _buildRowSkeleton('Trending Now')
                    : controller.trendingVideos.isNotEmpty
                        ? VideoRow(
                            title: 'Trending Now',
                            videos: controller.trendingVideos,
                            onVideoTap: controller.onVideoTap,
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Recommended For You
                  Obx(() => controller.recommendedVideos.isNotEmpty
                    ? VideoRow(
                        title: 'Recommended For You',
                        videos: controller.recommendedVideos,
                        onVideoTap: controller.onVideoTap,
                        isLarge: true,
                      )
                    : const SizedBox.shrink(),
                  ),

                  // Top Rated
                  Obx(() => controller.trendingVideos.isNotEmpty
                    ? VideoRow(
                        title: 'Top Rated',
                        videos: List.from(controller.recommendedVideos)
                          ..sort((a, b) => b.rating.compareTo(a.rating)),
                        onVideoTap: controller.onVideoTap,
                      )
                    : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC000000), Colors.transparent],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Logo
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text('SX', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(width: 8),
              Text('StreamX', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppConstants.primaryColor, fontWeight: FontWeight.w900, letterSpacing: 2,
              )),
              const Spacer(),
              // Search
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: controller.onSearchTap,
              ),
              // Profile
              GestureDetector(
                onTap: controller.onProfileTap,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppConstants.primaryColor,
                  child: const Text('U', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSkeleton() {
    return Shimmer.fromColors(
      baseColor: AppConstants.shimmerBase,
      highlightColor: AppConstants.shimmerHighlight,
      child: Container(
        height: 520,
        color: AppConstants.shimmerBase,
      ),
    );
  }

  Widget _buildRowSkeleton(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Shimmer.fromColors(
              baseColor: AppConstants.shimmerBase,
              highlightColor: AppConstants.shimmerHighlight,
              child: Container(width: 150, height: 18, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (_, __) => Shimmer.fromColors(
                baseColor: AppConstants.shimmerBase,
                highlightColor: AppConstants.shimmerHighlight,
                child: Container(
                  width: 160, height: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppConstants.shimmerBase,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.backgroundColor,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5)),
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) controller.onSearchTap();
          if (index == 2) controller.onProfileTap();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
