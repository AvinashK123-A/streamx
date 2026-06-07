import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

/// Production-grade empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Widget? action;
  final String? animationAsset;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.animationAsset,
  });

  /// Factory for empty search results
  factory EmptyStateWidget.noSearchResults({
    required String query,
  }) {
    return EmptyStateWidget(
      title: 'No Results Found',
      message: 'We couldn't find anything for "\$query". Try different keywords.',
      icon: Icons.search_off_rounded,
    );
  }

  /// Factory for empty watch history
  factory EmptyStateWidget.noWatchHistory({VoidCallback? onBrowse}) {
    return EmptyStateWidget(
      title: 'Nothing Here Yet',
      message: 'Videos you watch will appear here. Start exploring!',
      icon: Icons.history_rounded,
      action: onBrowse != null
          ? ElevatedButton(
              onPressed: onBrowse,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Browse Videos',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            )
          : null,
    );
  }

  /// Factory for offline state
  factory EmptyStateWidget.offline({VoidCallback? onRetry}) {
    return EmptyStateWidget(
      title: 'You're Offline',
      message: 'Connect to the internet to stream videos.',
      icon: Icons.wifi_off_rounded,
      action: onRetry != null
          ? TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface.withOpacity(0.5),
                border: Border.all(
                  color: AppColors.divider,
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.textMuted,
              ),
            ),

            const SizedBox(height: 28),

            // Title
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            if (action != null) ...[
              const SizedBox(height: 32),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
