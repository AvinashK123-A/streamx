import 'package:equatable/equatable.dart';

/// Video entity - core domain model
/// 
/// Represents a video content item in the StreamX platform.
/// Immutable domain entity following clean architecture principles.
class Video extends Equatable {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final Duration duration;
  final String genre;
  final List<String> tags;
  final double rating;
  final int viewCount;
  final DateTime releaseDate;
  final VideoQuality quality;
  final bool isFeatured;
  final bool isTrending;
  final String director;
  final List<String> cast;
  final String language;
  final String? trailerUrl;
  final List<VideoSubtitle> subtitles;
  final List<VideoQualitySource> qualitySources;

  const Video({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.genre,
    this.tags = const [],
    this.rating = 0.0,
    this.viewCount = 0,
    required this.releaseDate,
    this.quality = VideoQuality.hd,
    this.isFeatured = false,
    this.isTrending = false,
    this.director = '',
    this.cast = const [],
    this.language = 'en',
    this.trailerUrl,
    this.subtitles = const [],
    this.qualitySources = const [],
  });

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  String get formattedRating => rating.toStringAsFixed(1);
  
  String get formattedViewCount {
    if (viewCount >= 1000000) return '${(viewCount / 1000000).toStringAsFixed(1)}M views';
    if (viewCount >= 1000) return '${(viewCount / 1000).toStringAsFixed(1)}K views';
    return '$viewCount views';
  }

  String get yearString => releaseDate.year.toString();

  Video copyWith({
    String? id, String? title, String? description, String? thumbnailUrl,
    String? videoUrl, Duration? duration, String? genre, List<String>? tags,
    double? rating, int? viewCount, DateTime? releaseDate, VideoQuality? quality,
    bool? isFeatured, bool? isTrending, String? director, List<String>? cast,
    String? language, String? trailerUrl, List<VideoSubtitle>? subtitles,
    List<VideoQualitySource>? qualitySources,
  }) {
    return Video(
      id: id ?? this.id, title: title ?? this.title, description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl, videoUrl: videoUrl ?? this.videoUrl,
      duration: duration ?? this.duration, genre: genre ?? this.genre, tags: tags ?? this.tags,
      rating: rating ?? this.rating, viewCount: viewCount ?? this.viewCount,
      releaseDate: releaseDate ?? this.releaseDate, quality: quality ?? this.quality,
      isFeatured: isFeatured ?? this.isFeatured, isTrending: isTrending ?? this.isTrending,
      director: director ?? this.director, cast: cast ?? this.cast, language: language ?? this.language,
      trailerUrl: trailerUrl ?? this.trailerUrl, subtitles: subtitles ?? this.subtitles,
      qualitySources: qualitySources ?? this.qualitySources,
    );
  }

  @override
  List<Object?> get props => [id, title, videoUrl, duration, rating];
}

enum VideoQuality { sd, hd, fullHd, uhd4k }

class VideoSubtitle extends Equatable {
  final String language;
  final String label;
  final String url;
  const VideoSubtitle({required this.language, required this.label, required this.url});

  @override
  List<Object?> get props => [language, url];
}

class VideoQualitySource extends Equatable {
  final VideoQuality quality;
  final String label;
  final String url;
  final int? bitrate;
  const VideoQualitySource({required this.quality, required this.label, required this.url, this.bitrate});

  @override
  List<Object?> get props => [quality, url];
}
