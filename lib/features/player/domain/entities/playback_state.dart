import 'package:equatable/equatable.dart';

/// Domain entity representing the current state of video playback
/// Pure Dart — zero Flutter/framework dependencies
class PlaybackState extends Equatable {
  final String videoId;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isBuffering;
  final double playbackSpeed;
  final double volume;
  final bool isMuted;
  final bool isFullscreen;
  final PlaybackQuality quality;
  final List<SubtitleTrack> availableSubtitles;
  final SubtitleTrack? activeSubtitle;
  final double bufferProgress;

  const PlaybackState({
    required this.videoId,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
    this.isBuffering = false,
    this.playbackSpeed = 1.0,
    this.volume = 1.0,
    this.isMuted = false,
    this.isFullscreen = false,
    this.quality = PlaybackQuality.auto,
    this.availableSubtitles = const [],
    this.activeSubtitle,
    this.bufferProgress = 0.0,
  });

  /// Progress as percentage (0.0 - 1.0)
  double get progress {
    if (duration == Duration.zero) return 0.0;
    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  /// Whether the video has been watched to completion (> 95%)
  bool get isCompleted => progress > 0.95;

  /// Remaining playback time
  Duration get remaining => duration - position;

  PlaybackState copyWith({
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isBuffering,
    double? playbackSpeed,
    double? volume,
    bool? isMuted,
    bool? isFullscreen,
    PlaybackQuality? quality,
    List<SubtitleTrack>? availableSubtitles,
    SubtitleTrack? activeSubtitle,
    double? bufferProgress,
  }) {
    return PlaybackState(
      videoId: videoId,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      isFullscreen: isFullscreen ?? this.isFullscreen,
      quality: quality ?? this.quality,
      availableSubtitles: availableSubtitles ?? this.availableSubtitles,
      activeSubtitle: activeSubtitle ?? this.activeSubtitle,
      bufferProgress: bufferProgress ?? this.bufferProgress,
    );
  }

  @override
  List<Object?> get props => [
        videoId,
        position,
        duration,
        isPlaying,
        isBuffering,
        playbackSpeed,
        volume,
        isMuted,
        isFullscreen,
        quality,
      ];
}

/// Available playback quality options
enum PlaybackQuality {
  auto,
  p360,
  p480,
  p720,
  p1080,
  p4K;

  String get displayName {
    switch (this) {
      case PlaybackQuality.auto:
        return 'Auto';
      case PlaybackQuality.p360:
        return '360p';
      case PlaybackQuality.p480:
        return '480p';
      case PlaybackQuality.p720:
        return '720p HD';
      case PlaybackQuality.p1080:
        return '1080p Full HD';
      case PlaybackQuality.p4K:
        return '4K Ultra HD';
    }
  }
}

/// Subtitle track entity
class SubtitleTrack extends Equatable {
  final String id;
  final String language;
  final String label;
  final String url;
  final bool isDefault;

  const SubtitleTrack({
    required this.id,
    required this.language,
    required this.label,
    required this.url,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, language, url];
}

/// Watch progress record for continue watching feature
class WatchProgress extends Equatable {
  final String videoId;
  final Duration position;
  final Duration duration;
  final DateTime lastWatchedAt;

  const WatchProgress({
    required this.videoId,
    required this.position,
    required this.duration,
    required this.lastWatchedAt,
  });

  double get progressPercent {
    if (duration == Duration.zero) return 0.0;
    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  bool get isCompleted => progressPercent > 0.95;

  @override
  List<Object?> get props => [videoId, position, duration];
}
