import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../home/domain/entities/video.dart';

/// Video Player Controller with full production-grade feature set
/// 
/// Features:
/// - Streaming video playback with buffering
/// - Auto-resume from last position
/// - Quality selection
/// - Playback speed control
/// - Seek forward/backward (10s)
/// - Fullscreen toggle
/// - Orientation management
/// - Controls auto-hide
/// - Analytics tracking
/// - Watch progress persistence
class PlayerController extends GetxController {
  // ============ Reactive State ============
  VideoPlayerController? _videoController;
  VideoPlayerController? get videoController => _videoController;

  final Rx<Video?> currentVideo = Rx<Video?>(null);
  final RxBool isInitialized = false.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isBuffering = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isFullscreen = false.obs;
  final RxBool showControls = true.obs;
  final RxBool isLocked = false.obs;

  // Position & Duration
  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> totalDuration = Duration.zero.obs;
  final RxDouble playbackProgress = 0.0.obs;
  final RxDouble bufferedProgress = 0.0.obs;

  // Playback Settings
  final RxDouble playbackSpeed = 1.0.obs;
  final RxString selectedQuality = 'Auto'.obs;

  // Controls visibility timer
  Timer? _hideControlsTimer;
  Timer? _progressSaveTimer;
  Timer? _analyticsTimer;

  // Analytics tracking
  int _watchedSeconds = 0;
  int _lastReportedSecond = 0;

  // ============ Lifecycle ============
  @override
  void onInit() {
    super.onInit();
    final video = Get.arguments as Video?;
    if (video != null) {
      currentVideo.value = video;
      _initializePlayer(video);
    }
  }

  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }

  // ============ Initialization ============
  Future<void> _initializePlayer(Video video) async {
    try {
      isInitialized.value = false;
      hasError.value = false;

      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(video.videoUrl),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
        httpHeaders: {
          'User-Agent': 'StreamX/1.0.0',
          'Accept': '*/*',
        },
      );

      await _videoController!.initialize();
      isInitialized.value = true;
      totalDuration.value = _videoController!.value.duration;

      // Resume from saved position
      final savedProgress = HiveStorage.getWatchProgress(video.id);
      if (savedProgress != null) {
        final position = (savedProgress['position'] as num?)?.toInt() ?? 0;
        final total = (savedProgress['total'] as num?)?.toInt() ?? 0;
        if (position > 0 && total > 0 && (position / total) < 0.95) {
          await _videoController!.seekTo(Duration(seconds: position));
        }
      }

      // Set playback speed
      await _videoController!.setPlaybackSpeed(playbackSpeed.value);

      // Start playing
      await _videoController!.play();
      isPlaying.value = true;

      // Listen to position updates
      _videoController!.addListener(_onPlayerUpdate);

      // Start analytics
      AnalyticsService.instance.logVideoStart(videoId: video.id, videoTitle: video.title);
      _startAnalyticsTimer();
      _startProgressSaveTimer();
      _scheduleHideControls();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load video: ${e.toString()}';
    }
  }

  void _onPlayerUpdate() {
    if (_videoController == null) return;
    final value = _videoController!.value;

    isPlaying.value = value.isPlaying;
    isBuffering.value = value.isBuffering;
    currentPosition.value = value.position;

    // Update progress
    if (totalDuration.value.inMilliseconds > 0) {
      playbackProgress.value = value.position.inMilliseconds / totalDuration.value.inMilliseconds;
    }

    // Buffered progress
    if (value.buffered.isNotEmpty && totalDuration.value.inMilliseconds > 0) {
      final bufferedEnd = value.buffered.last.end;
      bufferedProgress.value = bufferedEnd.inMilliseconds / totalDuration.value.inMilliseconds;
    }

    // Track watched time
    _watchedSeconds = value.position.inSeconds;
  }

  // ============ Playback Controls ============
  void togglePlay() {
    if (_videoController == null || !isInitialized.value) return;
    if (isPlaying.value) {
      _videoController!.pause();
      AnalyticsService.instance.logVideoPause(
        videoId: currentVideo.value?.id ?? '',
        positionSeconds: currentPosition.value.inSeconds,
      );
    } else {
      _videoController!.play();
    }
    isPlaying.toggle();
    _scheduleHideControls();
  }

  Future<void> seekForward() async {
    if (_videoController == null) return;
    final newPosition = currentPosition.value + const Duration(seconds: 10);
    final clampedPosition = newPosition > totalDuration.value ? totalDuration.value : newPosition;
    await _videoController!.seekTo(clampedPosition);
    AnalyticsService.instance.logVideoSeek(
      videoId: currentVideo.value?.id ?? '',
      fromSeconds: currentPosition.value.inSeconds,
      toSeconds: clampedPosition.inSeconds,
    );
    _scheduleHideControls();
  }

  Future<void> seekBackward() async {
    if (_videoController == null) return;
    final newPosition = currentPosition.value - const Duration(seconds: 10);
    final clampedPosition = newPosition < Duration.zero ? Duration.zero : newPosition;
    await _videoController!.seekTo(clampedPosition);
    _scheduleHideControls();
  }

  Future<void> seekTo(Duration position) async {
    if (_videoController == null) return;
    await _videoController!.seekTo(position);
    _scheduleHideControls();
  }

  Future<void> setPlaybackSpeed(double speed) async {
    if (_videoController == null) return;
    playbackSpeed.value = speed;
    await _videoController!.setPlaybackSpeed(speed);
    AnalyticsService.instance.logPlaybackSpeedChange(
      videoId: currentVideo.value?.id ?? '',
      speed: speed,
    );
    _scheduleHideControls();
  }

  void selectQuality(String quality) {
    selectedQuality.value = quality;
    AnalyticsService.instance.logQualityChange(
      videoId: currentVideo.value?.id ?? '',
      quality: quality,
    );
    _scheduleHideControls();
  }

  // ============ Controls Visibility ============
  void showControlsTemporarily() {
    showControls.value = true;
    _scheduleHideControls();
  }

  void _scheduleHideControls() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 4), () {
      if (isPlaying.value && !isLocked.value) {
        showControls.value = false;
      }
    });
  }

  void toggleControlsLock() {
    isLocked.toggle();
    _scheduleHideControls();
  }

  // ============ Fullscreen ============
  Future<void> toggleFullscreen() async {
    isFullscreen.toggle();
    if (isFullscreen.value) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    _scheduleHideControls();
  }

  // ============ Progress & Analytics ============
  void _startProgressSaveTimer() {
    _progressSaveTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _saveProgress();
    });
  }

  void _saveProgress() {
    final video = currentVideo.value;
    if (video == null) return;
    HiveStorage.saveWatchProgress(
      video.id,
      currentPosition.value.inSeconds,
      totalDuration.value.inSeconds,
    );
  }

  void _startAnalyticsTimer() {
    _analyticsTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      final video = currentVideo.value;
      if (video == null) return;
      AnalyticsService.instance.logVideoProgress(
        videoId: video.id,
        watchedSeconds: _watchedSeconds,
        totalSeconds: totalDuration.value.inSeconds,
      );
    });
  }

  // ============ Helpers ============
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) return '$hours:$minutes:$seconds';
    return '$minutes:$seconds';
  }

  void _cleanup() {
    _hideControlsTimer?.cancel();
    _progressSaveTimer?.cancel();
    _analyticsTimer?.cancel();
    _saveProgress();
    
    final video = currentVideo.value;
    if (video != null) {
      AnalyticsService.instance.logVideoProgress(
        videoId: video.id,
        watchedSeconds: _watchedSeconds,
        totalSeconds: totalDuration.value.inSeconds,
      );
    }

    _videoController?.removeListener(_onPlayerUpdate);
    _videoController?.dispose();
    _videoController = null;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
