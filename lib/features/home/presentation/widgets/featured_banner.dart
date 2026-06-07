import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/video.dart';

/// Featured banner widget with auto-scrolling PageView
/// Netflix-style hero banner for featured content
class FeaturedBanner extends StatefulWidget {
  final List<Video> videos;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<Video> onVideoTap;

  const FeaturedBanner({
    super.key,
    required this.videos,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onVideoTap,
  });

  @override
  State<FeaturedBanner> createState() => _FeaturedBannerState();
}

class _FeaturedBannerState extends State<FeaturedBanner> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      final nextPage = (widget.currentIndex + 1) % widget.videos.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: widget.onPageChanged,
            itemCount: widget.videos.length,
            itemBuilder: (context, index) {
              final video = widget.videos[index];
              return GestureDetector(
                onTap: () => widget.onVideoTap(video),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Thumbnail
                    CachedNetworkImage(
                      imageUrl: video.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppConstants.shimmerBase),
                      errorWidget: (_, __, ___) => Container(
                        color: AppConstants.cardColor,
                        child: const Icon(Icons.movie, size: 80, color: Colors.grey),
                      ),
                    ),

                    // Gradient overlay
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Color(0x80000000),
                            Color(0xE0000000),
                            AppConstants.backgroundColor,
                          ],
                          stops: [0.0, 0.3, 0.6, 0.8, 1.0],
                        ),
                      ),
                    ),

                    // Content overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Genre badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppConstants.primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                video.genre.toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Title
                            Text(
                              video.title,
                              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            // Meta
                            Row(
                              children: [
                                const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                                const SizedBox(width: 4),
                                Text(video.formattedRating, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                const SizedBox(width: 12),
                                Text(video.yearString, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(width: 12),
                                Text(video.formattedDuration, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => widget.onVideoTap(video),
                                    icon: const Icon(Icons.play_arrow, size: 20),
                                    label: const Text('Play', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => widget.onVideoTap(video),
                                    icon: const Icon(Icons.info_outline, size: 20),
                                    label: const Text('More Info', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(color: Colors.white54),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Page indicators
          if (widget.videos.length > 1)
            Positioned(
              bottom: 0,
              right: AppConstants.defaultPadding,
              child: Row(
                children: List.generate(widget.videos.length, (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: i == widget.currentIndex ? 20 : 6,
                  height: 6,
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: i == widget.currentIndex ? AppConstants.primaryColor : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                )),
              ),
            ),
        ],
      ),
    );
  }
}
