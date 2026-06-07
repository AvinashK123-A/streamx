import 'package:equatable/equatable.dart';

/// Pure domain entity for search results — zero Flutter dependencies
class SearchResult extends Equatable {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoUrl;
  final String category;
  final double rating;
  final int duration;
  final String type; // 'video', 'series', 'live'

  const SearchResult({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.category,
    this.rating = 0.0,
    this.duration = 0,
    this.type = 'video',
  });

  @override
  List<Object?> get props => [
        id,
        title,
        thumbnailUrl,
        videoUrl,
        category,
        rating,
        duration,
        type,
      ];
}

/// Entity for search suggestion
class SearchSuggestion extends Equatable {
  final String text;
  final bool isRecent;
  final bool isTrending;

  const SearchSuggestion({
    required this.text,
    this.isRecent = false,
    this.isTrending = false,
  });

  @override
  List<Object?> get props => [text, isRecent, isTrending];
}
