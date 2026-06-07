import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/app_constants.dart';
import '../controllers/player_controller.dart';

/// Full-featured video player screen
/// 
/// Features:
/// - Full-screen video player
/// - Custom controls overlay with auto-hide
/// - Seek bar with buffered progress
/// - Seek forward/backward 10 seconds
/// - Playback speed selection
/// - Quality selection
/// - Fullscreen toggle
/// - Auto-orientation
/// - Buffering indicator
/// - Resume from last position
class PlayerView extends GetView<PlayerController> {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!controller.isInitialized.value && !controller.hasError.value) {
          return const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor));
        }
        if (controller.hasError.value) {
          return _buildError();
        }
        return _buildPlayer(context);
      }),
    );
  }

  Widget _buildPlayer(BuildContext context) {
    return GestureDetector(
      onTap: controller.showControlsTemporarily,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video
          Center(
            child: AspectRatio(
              aspectRatio: controller.videoController?.value.aspectRatio ?? 16 / 9,
              child: VideoPlayer(controller.videoController!),
            ),
          ),

          // Buffering indicator
          Obx(() => controller.isBuffering.value
            ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : const SizedBox.shrink(),
          ),

          // Controls overlay
          Obx(() => AnimatedOpacity(
            opacity: controller.showControls.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !controller.showControls.value,
              child: _buildControls(context),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC000000), Colors.transparent, Colors.transparent, Color(0xCC000000)],
          stops: [0.0, 0.2, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top bar
            _buildTopBar(context),
            const Spacer(),

            // Center controls
            _buildCenterControls(),
            const Spacer(),

            // Bottom bar
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(() => Text(
              controller.currentVideo.value?.title ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            )),
          ),
          // Speed selector
          PopupMenuButton<double>(
            icon: const Icon(Icons.speed, color: Colors.white),
            color: const Color(0xFF1F1F1F),
            onSelected: controller.setPlaybackSpeed,
            itemBuilder: (_) => AppConstants.playbackSpeeds.map((speed) =>
              PopupMenuItem(value: speed, child: Text('${speed}x', style: const TextStyle(color: Colors.white)))
            ).toList(),
          ),
          // Quality selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.hd, color: Colors.white),
            color: const Color(0xFF1F1F1F),
            onSelected: controller.selectQuality,
            itemBuilder: (_) => AppConstants.videoQualities.map((q) =>
              PopupMenuItem(value: q, child: Text(q, style: const TextStyle(color: Colors.white)))
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Seek backward
        GestureDetector(
          onTap: controller.seekBackward,
          child: Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.replay, color: Colors.white, size: 32),
                Positioned(bottom: 10, child: Text('10', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ),

        const SizedBox(width: 32),

        // Play/Pause
        Obx(() => GestureDetector(
          onTap: controller.togglePlay,
          child: Container(
            width: 72, height: 72,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle,
              border: Border.all(color: Colors.white30, width: 2)),
            child: Icon(
              controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
              color: Colors.white, size: 40,
            ),
          ),
        )),

        const SizedBox(width: 32),

        // Seek forward
        GestureDetector(
          onTap: controller.seekForward,
          child: Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: Colors.black38, shape: BoxShape.circle),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.forward_10, color: Colors.white, size: 32),
                Positioned(bottom: 10, child: Text('10', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Progress bar
          Obx(() => Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Buffered progress
              LinearProgressIndicator(
                value: controller.bufferedProgress.value,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white38),
                minHeight: 4,
              ),
              // Played progress
              VideoProgressIndicator(
                controller.videoController!,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: AppConstants.primaryColor,
                  bufferedColor: Colors.white38,
                  backgroundColor: Colors.white24,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          )),

          const SizedBox(height: 8),

          // Time and fullscreen
          Row(
            children: [
              Obx(() => Text(
                '${controller.formatDuration(controller.currentPosition.value)} / ${controller.formatDuration(controller.totalDuration.value)}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              )),
              const Spacer(),
              // Playback speed display
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(4)),
                child: Text('${controller.playbackSpeed.value}x', style: const TextStyle(color: Colors.white, fontSize: 12)),
              )),
              const SizedBox(width: 8),
              // Fullscreen
              IconButton(
                icon: Obx(() => Icon(
                  controller.isFullscreen.value ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                )),
                onPressed: controller.toggleFullscreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppConstants.primaryColor, size: 64),
          const SizedBox(height: 16),
          Obx(() => Text(
            controller.errorMessage.value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          )),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
