import '../../domain/entities/video.dart';

/// Video Data Transfer Object for data layer
class VideoDTO {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final int durationSeconds;
  final String genre;
  final List<String> tags;
  final double rating;
  final int viewCount;
  final String releaseDateStr;
  final String quality;
  final bool isFeatured;
  final bool isTrending;
  final String director;
  final List<String> cast;
  final String language;
  final String? trailerUrl;
  final List<Map<String, String>>? qualitySources;

  const VideoDTO({
    required this.id, required this.title, required this.description,
    required this.thumbnailUrl, required this.videoUrl, required this.durationSeconds,
    required this.genre, this.tags = const [], this.rating = 0.0,
    this.viewCount = 0, required this.releaseDateStr, this.quality = 'hd',
    this.isFeatured = false, this.isTrending = false, this.director = '',
    this.cast = const [], this.language = 'en', this.trailerUrl, this.qualitySources,
  });

  factory VideoDTO.fromJson(Map<String, dynamic> json) => VideoDTO(
    id: json['id'], title: json['title'], description: json['description'],
    thumbnailUrl: json['thumbnail_url'], videoUrl: json['video_url'],
    durationSeconds: json['duration_seconds'] ?? 0, genre: json['genre'] ?? 'Unknown',
    tags: List<String>.from(json['tags'] ?? []), rating: (json['rating'] ?? 0).toDouble(),
    viewCount: json['view_count'] ?? 0, releaseDateStr: json['release_date'] ?? '',
    quality: json['quality'] ?? 'hd', isFeatured: json['is_featured'] ?? false,
    isTrending: json['is_trending'] ?? false, director: json['director'] ?? '',
    cast: List<String>.from(json['cast'] ?? []), language: json['language'] ?? 'en',
    trailerUrl: json['trailer_url'],
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'description': description, 'thumbnail_url': thumbnailUrl,
    'video_url': videoUrl, 'duration_seconds': durationSeconds, 'genre': genre,
    'tags': tags, 'rating': rating, 'view_count': viewCount, 'release_date': releaseDateStr,
    'quality': quality, 'is_featured': isFeatured, 'is_trending': isTrending,
    'director': director, 'cast': cast, 'language': language, 'trailer_url': trailerUrl,
  };

  Video toDomain() => Video(
    id: id, title: title, description: description, thumbnailUrl: thumbnailUrl,
    videoUrl: videoUrl, duration: Duration(seconds: durationSeconds), genre: genre,
    tags: tags, rating: rating, viewCount: viewCount,
    releaseDate: DateTime.tryParse(releaseDateStr) ?? DateTime.now(),
    quality: _parseQuality(quality), isFeatured: isFeatured, isTrending: isTrending,
    director: director, cast: cast, language: language, trailerUrl: trailerUrl,
    qualitySources: qualitySources?.map((q) => VideoQualitySource(
      quality: _parseQuality(q['quality'] ?? 'hd'),
      label: q['label'] ?? '',
      url: q['url'] ?? '',
    )).toList() ?? [],
  );

  static VideoQuality _parseQuality(String q) {
    switch (q) {
      case 'sd': return VideoQuality.sd;
      case 'fullHd': return VideoQuality.fullHd;
      case 'uhd4k': return VideoQuality.uhd4k;
      default: return VideoQuality.hd;
    }
  }
}
