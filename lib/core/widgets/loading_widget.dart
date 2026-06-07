import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../themes/app_theme.dart';

/// Production-grade shimmer loading skeletons for StreamX
class LoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Shimmer skeleton for video cards in horizontal scroll rows
class VideoCardSkeleton extends StatelessWidget {
  const VideoCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail skeleton
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            // Title line 1
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            // Title line 2 (shorter)
            Container(
              height: 12,
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton for the featured banner
class FeaturedBannerSkeleton extends StatelessWidget {
  const FeaturedBannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        height: 500,
        width: double.infinity,
        color: AppColors.shimmerBase,
      ),
    );
  }
}

/// Shimmer skeleton for full home screen loading state
class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured banner skeleton
          const FeaturedBannerSkeleton(),

          const SizedBox(height: 24),

          // Video rows skeletons
          ...List.generate(3, (index) => _VideoRowSkeleton()),
        ],
      ),
    );
  }
}

class _VideoRowSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row title skeleton
          Shimmer.fromColors(
            baseColor: AppColors.shimmerBase,
            highlightColor: AppColors.shimmerHighlight,
            child: Container(
              height: 20,
              width: 160,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal list of card skeletons
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (_, __) => const VideoCardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Full screen loading with StreamX logo
class StreamXLoadingOverlay extends StatefulWidget {
  final String? message;

  const StreamXLoadingOverlay({super.key, this.message});

  @override
  State<StreamXLoadingOverlay> createState() => _StreamXLoadingOverlayState();
}

class _StreamXLoadingOverlayState extends State<StreamXLoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo
            ScaleTransition(
              scale: _pulseAnimation,
              child: const Text(
                'STREAMX',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 6,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Loading indicator
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary.withOpacity(0.8),
                ),
              ),
            ),

            if (widget.message != null) ...[
              const SizedBox(height: 20),
              Text(
                widget.message!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
