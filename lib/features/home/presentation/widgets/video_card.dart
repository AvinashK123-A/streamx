import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../domain/entities/video.dart';

class VideoCard extends StatelessWidget {
  final Video video;
  final double width;
  final double height;
  final VoidCallback onTap;
  final bool showProgress;

  const VideoCard({super.key, required this.video, required this.width, required this.height, required this.onTap, this.showProgress = false});

  @override
  Widget build(BuildContext context) {
    final progress = _getProgress();
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  child: CachedNetworkImage(
                    imageUrl: video.thumbnailUrl, width: width, height: height, fit: BoxFit.cover,
                    placeholder: (_, __) => Container(width: width, height: height, color: AppConstants.cardColor, child: const Icon(Icons.movie, color: Colors.grey, size: 32)),
                    errorWidget: (_, __, ___) => Container(
                      width: width, height: height, color: AppConstants.cardColor,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Icon(Icons.movie, color: Colors.grey, size: 32),
                        const SizedBox(height: 4),
                        Text(video.title, style: const TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center, maxLines: 2),
                      ]),
                    ),
                  ),
                ),
                Positioned(top: 6, right: 6, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(3)),
                  child: Text(video.quality == VideoQuality.fullHd ? 'HD' : video.quality == VideoQuality.uhd4k ? '4K' : 'SD',
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                )),
                Positioned.fill(child: Center(child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                ))),
                if (showProgress && progress > 0) Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white30,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                      minHeight: 3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(video.title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            Row(children: [
              const Icon(Icons.star, color: Color(0xFFFFC107), size: 10),
              const SizedBox(width: 2),
              Text(video.formattedRating, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              const SizedBox(width: 6),
              Text(video.formattedDuration, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ]),
          ],
        ),
      ),
    );
  }

  double _getProgress() {
    if (!showProgress) return 0;
    final data = HiveStorage.getWatchProgress(video.id);
    if (data == null) return 0;
    final position = (data['position'] as num?)?.toDouble() ?? 0;
    final total = (data['total'] as num?)?.toDouble() ?? 1;
    return total > 0 ? (position / total).clamp(0.0, 1.0) : 0;
  }
}
