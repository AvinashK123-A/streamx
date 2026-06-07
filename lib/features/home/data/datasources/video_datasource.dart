import '../../../../core/constants/app_constants.dart';
import '../models/video_dto.dart';

/// Video data source providing mock video data with real streaming URLs
/// 
/// Uses publicly available MP4 files for portfolio demonstration.
/// In production, this would call real streaming APIs.
abstract class VideoDataSource {
  Future<List<VideoDTO>> getFeaturedVideos();
  Future<List<VideoDTO>> getTrendingVideos({int page = 1, int limit = 10});
  Future<List<VideoDTO>> getRecommendedVideos({int page = 1, int limit = 20});
  Future<List<VideoDTO>> searchVideos({required String query, int page = 1});
  Future<VideoDTO> getVideoById(String id);
  Future<List<VideoDTO>> getVideosByGenre(String genre);
}

class VideoDataSourceImpl implements VideoDataSource {
  // Complete mock video catalog with real publicly available MP4 streams
  static final List<VideoDTO> _mockVideos = [
    VideoDTO(
      id: 'v001',
      title: 'Big Buck Bunny',
      description: 'Big Buck Bunny is a 2008 short computer-animated comedy film featuring a fat, solitary rabbit bullied by a group of small woodland creatures. This extended version showcases stunning Blender CGI with beautiful landscapes and hilarious comedy sequences. A landmark open-source film project from the Blender Foundation.',
      thumbnailUrl: 'https://peach.blender.org/wp-content/uploads/title_anouncement.jpg?x11217',
      videoUrl: AppConstants.bigBuckBunnyUrl,
      durationSeconds: 596,
      genre: 'Animation',
      tags: ['animation', 'comedy', 'open-source', 'blender', 'family'],
      rating: 8.4,
      viewCount: 2500000,
      releaseDateStr: '2008-04-10',
      quality: 'hd',
      isFeatured: true,
      isTrending: true,
      director: 'Sacha Goedegebure',
      cast: ['CGI Animation', 'Frank', 'Rinky', 'Gamera', 'Hutch', 'Gimera'],
      language: 'en',
      qualitySources: [
        {'quality': 'hd', 'label': '720p HD', 'url': AppConstants.bigBuckBunnyUrl},
        {'quality': 'fullHd', 'label': '1080p Full HD', 'url': AppConstants.bigBuckBunnyUrl},
      ],
    ),
    VideoDTO(
      id: 'v002',
      title: 'Sintel',
      description: 'Sintel is an independently produced short film, initiated by the Blender Foundation as a means to further improve and validate the free/open source 3D creation suite Blender. A young woman searches for her dragon companion in a visually stunning adventure spanning multiple worlds and environments.',
      thumbnailUrl: 'https://durian.blender.org/wp-content/uploads/2010/09/sintel-12.jpg',
      videoUrl: AppConstants.sintelUrl,
      durationSeconds: 888,
      genre: 'Fantasy',
      tags: ['fantasy', 'adventure', 'animation', 'blender', 'dragon'],
      rating: 8.7,
      viewCount: 1800000,
      releaseDateStr: '2010-09-27',
      quality: 'fullHd',
      isFeatured: true,
      isTrending: true,
      director: 'Colin Levy',
      cast: ['Halina Reijn (voice)', 'Thom Hoffman (voice)'],
      language: 'en',
      qualitySources: [
        {'quality': 'hd', 'label': '720p HD', 'url': AppConstants.sintelUrl},
        {'quality': 'fullHd', 'label': '1080p Full HD', 'url': AppConstants.sintelUrl},
      ],
    ),
    VideoDTO(
      id: 'v003',
      title: 'Elephants Dream',
      description: 'Elephants Dream is the worlds first open movie, made entirely with open source graphics software such as Blender. Two strange characters explore a mechanical world. Proog, the elder, works diligently to maintain it. Emo, the younger, questions reality. A groundbreaking piece of open-source filmmaking.',
      thumbnailUrl: 'https://orange.blender.org/wp-content/themes/orange/images/media/firstframe.jpg',
      videoUrl: AppConstants.elephantsDreamUrl,
      durationSeconds: 654,
      genre: 'Science Fiction',
      tags: ['sci-fi', 'animation', 'open-source', 'experimental', 'blender'],
      rating: 7.9,
      viewCount: 950000,
      releaseDateStr: '2006-03-24',
      quality: 'hd',
      isFeatured: false,
      isTrending: false,
      director: 'Bassam Kurdali',
      cast: ['Tygo Gernandt', 'Cas Jansen'],
      language: 'en',
    ),
    VideoDTO(
      id: 'v004',
      title: 'For Bigger Blazes',
      description: 'HTC One is a powerful smartphone that goes beyond the ordinary. Watch how it captures stunning moments in life with its ultra-fast camera and exceptional video capabilities. A cinematic showcase of adventure and technology seamlessly combined.',
      thumbnailUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg',
      videoUrl: AppConstants.forBiggerBlazesUrl,
      durationSeconds: 15,
      genre: 'Commercial',
      tags: ['commercial', 'technology', 'htc', 'action'],
      rating: 7.2,
      viewCount: 320000,
      releaseDateStr: '2013-01-01',
      quality: 'hd',
      isFeatured: false,
      isTrending: true,
      director: 'Unknown',
      cast: [],
      language: 'en',
    ),
    VideoDTO(
      id: 'v005',
      title: 'For Bigger Escapes',
      description: 'Introducing HTC One - a phone that redefines entertainment. With its BoomSound speakers and stunning display, every escape becomes a cinematic experience. Watch high-quality content in crystal clear resolution wherever you go.',
      thumbnailUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscapes.jpg',
      videoUrl: AppConstants.forBiggerEscapesUrl,
      durationSeconds: 15,
      genre: 'Commercial',
      tags: ['commercial', 'technology', 'htc', 'lifestyle'],
      rating: 7.0,
      viewCount: 280000,
      releaseDateStr: '2013-01-01',
      quality: 'hd',
      isFeatured: false,
      isTrending: false,
      director: 'Unknown',
      cast: [],
      language: 'en',
    ),
    VideoDTO(
      id: 'v006',
      title: 'Tears of Steel',
      description: 'Tears of Steel is a short science fiction film set in Amsterdam. A group of warriors and a team of scientists take a desperate stand to regain control of a city, and themselves, from a body-snatching alien invasion. The film is made with open source tools.',
      thumbnailUrl: 'https://mango.blender.org/wp-content/uploads/2013/05/01_thom_celia_bridge-1024x576.jpg',
      videoUrl: AppConstants.tearsOfSteelUrl,
      durationSeconds: 734,
      genre: 'Science Fiction',
      tags: ['sci-fi', 'action', 'open-source', 'vfx', 'blender'],
      rating: 8.1,
      viewCount: 1200000,
      releaseDateStr: '2012-09-26',
      quality: 'fullHd',
      isFeatured: true,
      isTrending: false,
      director: 'Ian Hubert',
      cast: ['Thom Hoffman', 'Bianca Krijgsman', 'Rogier Schippers'],
      language: 'en',
    ),
    VideoDTO(
      id: 'v007',
      title: 'Volkswagen GTI Review',
      description: 'An in-depth review of the iconic Volkswagen GTI - the hot hatchback that defined a generation. From its powerful engine to its precise handling, discover why the GTI remains one of the most beloved performance cars in automotive history.',
      thumbnailUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/images/VolkswagenGTIReview.jpg',
      videoUrl: AppConstants.volkswagenGTIUrl,
      durationSeconds: 26,
      genre: 'Documentary',
      tags: ['cars', 'automotive', 'volkswagen', 'review', 'performance'],
      rating: 6.8,
      viewCount: 450000,
      releaseDateStr: '2012-01-01',
      quality: 'hd',
      isFeatured: false,
      isTrending: false,
      director: 'Unknown',
      cast: [],
      language: 'en',
    ),
  ];

  @override
  Future<List<VideoDTO>> getFeaturedVideos() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockVideos.where((v) => v.isFeatured).toList();
  }

  @override
  Future<List<VideoDTO>> getTrendingVideos({int page = 1, int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final trending = _mockVideos.where((v) => v.isTrending).toList();
    return trending.take(limit).toList();
  }

  @override
  Future<List<VideoDTO>> getRecommendedVideos({int page = 1, int limit = 20}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _mockVideos.toList()..sort((a, b) => b.rating.compareTo(a.rating));
  }

  @override
  Future<List<VideoDTO>> searchVideos({required String query, int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final q = query.toLowerCase();
    return _mockVideos.where((v) =>
      v.title.toLowerCase().contains(q) ||
      v.description.toLowerCase().contains(q) ||
      v.genre.toLowerCase().contains(q) ||
      v.tags.any((t) => t.contains(q))
    ).toList();
  }

  @override
  Future<VideoDTO> getVideoById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockVideos.firstWhere((v) => v.id == id,
      orElse: () => throw Exception('Video not found: $id'));
  }

  @override
  Future<List<VideoDTO>> getVideosByGenre(String genre) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _mockVideos.where((v) => v.genre.toLowerCase() == genre.toLowerCase()).toList();
  }

  static List<VideoDTO> get allVideos => List.unmodifiable(_mockVideos);
}
