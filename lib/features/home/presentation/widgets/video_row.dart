import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/video.dart';
import 'video_card.dart';

/// Horizontally scrollable video row with title header
class VideoRow extends StatelessWidget {
  final String title;
  final List<Video> videos;
  final ValueChanged<Video> onVideoTap;
  final bool isLarge;
  final bool showProgress;

  const VideoRow({
    super.key,
    required this.title,
    required this.videos,
    required this.onVideoTap,
    this.isLarge = false,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    if (videos.isEmpty) return const SizedBox.shrink();
    
    final cardHeight = isLarge ? 180.0 : 120.0;
    final cardWidth = isLarge ? 280.0 : 160.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                if (videos.length > 3)
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All', style: TextStyle(color: AppConstants.primaryColor, fontSize: 12)),
                  ),
              ],
            ),
          ),

          // Horizontal scroll
          SizedBox(
            height: cardHeight + 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: index == videos.length - 1 ? 0 : 12),
                  child: VideoCard(
                    video: videos[index],
                    width: cardWidth,
                    height: cardHeight,
                    onTap: () => onVideoTap(videos[index]),
                    showProgress: showProgress,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
