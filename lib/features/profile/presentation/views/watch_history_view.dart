import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/hive_storage.dart';
import '../controllers/profile_controller.dart';

class WatchHistoryView extends GetView<ProfileController> {
  const WatchHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final history = HiveStorage.getWatchHistory();
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text('Watch History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Get.back()),
        actions: [
          if (history.isNotEmpty)
            TextButton(
              onPressed: () {
                HiveStorage.clearWatchHistory();
                Get.back();
              },
              child: const Text('Clear All', style: TextStyle(color: AppConstants.primaryColor)),
            ),
        ],
      ),
      body: history.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, color: Colors.grey, size: 64),
                SizedBox(height: 16),
                Text('No watch history yet', style: TextStyle(color: Colors.grey, fontSize: 16)),
                SizedBox(height: 8),
                Text('Videos you watch will appear here', style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: history.length,
            itemBuilder: (_, index) {
              final item = history[index];
              final position = (item['position'] as num?)?.toInt() ?? 0;
              final total = (item['total'] as num?)?.toInt() ?? 1;
              final percent = total > 0 ? (position / total * 100).round() : 0;
              final watchedAt = item['watchedAt'] as String?;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.surfaceColor,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(color: AppConstants.cardColor, borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.movie, color: Colors.grey, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['videoId']?.toString() ?? 'Unknown', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('$percent% watched', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: total > 0 ? position / total : 0,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                            minHeight: 2,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 18),
                      onPressed: () => HiveStorage.removeFromWatchHistory(item['videoId']?.toString() ?? ''),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
