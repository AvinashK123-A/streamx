import 'package:streamx/features/auth/domain/entities/user.dart';
import 'package:streamx/features/home/domain/entities/video.dart';

/// Central mock data factory for tests — DRY principle applied
class MockData {
  MockData._();

  // ============================================================
  // User Mock Data
  // ============================================================

  static User get validUser => const User(
        id: 'user_001',
        name: 'John Doe',
        email: 'john.doe@example.com',
        avatarUrl: 'https://example.com/avatar.jpg',
        isEmailVerified: true,
        createdAt: '2024-01-01T00:00:00Z',
      );

  static User get adminUser => const User(
        id: 'user_admin',
        name: 'Admin User',
        email: 'admin@streamx.app',
        avatarUrl: null,
        isEmailVerified: true,
        createdAt: '2023-01-01T00:00:00Z',
      );

  static const String validEmail = 'john.doe@example.com';
  static const String validPassword = 'SecurePass123!';
  static const String invalidEmail = 'not-an-email';
  static const String weakPassword = '123';
  static const String validAuthToken = 'eyJhbGciOiJIUzI1NiJ9.valid.token';
  static const String validRefreshToken = 'refresh_token_valid_123';

  // ============================================================
  // Video Mock Data
  // ============================================================

  static Video get bigBuckBunny => const Video(
        id: 'video_001',
        title: 'Big Buck Bunny',
        description:
            'A large and lovable rabbit deals with three tiny bullying rodents.',
        thumbnailUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        duration: 596,
        genre: 'Animation',
        rating: 8.5,
        releaseYear: 2008,
        isFeatured: true,
        isTrending: true,
        views: 1500000,
        tags: ['animation', 'comedy', 'family'],
      );

  static Video get sintel => const Video(
        id: 'video_002',
        title: 'Sintel',
        description: 'A lonely young woman, Sintel, helps and befriends a dragon.',
        thumbnailUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
        duration: 888,
        genre: 'Fantasy',
        rating: 7.8,
        releaseYear: 2010,
        isFeatured: true,
        isTrending: false,
        views: 1200000,
        tags: ['fantasy', 'adventure', 'drama'],
      );

  static Video get elephantDream => const Video(
        id: 'video_003',
        title: 'Elephant Dream',
        description: 'The story of two strange characters exploring a capricious mechanical world.',
        thumbnailUrl:
            'https://storage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        duration: 654,
        genre: 'Science Fiction',
        rating: 7.5,
        releaseYear: 2006,
        isFeatured: false,
        isTrending: true,
        views: 980000,
        tags: ['scifi', 'experimental'],
      );

  static List<Video> get featuredVideos => [bigBuckBunny, sintel];

  static List<Video> get trendingVideos => [
        bigBuckBunny,
        sintel,
        elephantDream,
      ];

  static List<Video> get allVideos => [
        bigBuckBunny,
        sintel,
        elephantDream,
      ];

  // ============================================================
  // API Response Mock Data
  // ============================================================

  static Map<String, dynamic> get loginSuccessResponse => {
        'success': true,
        'data': {
          'user': {
            'id': validUser.id,
            'name': validUser.name,
            'email': validUser.email,
            'avatar_url': validUser.avatarUrl,
            'is_email_verified': true,
            'created_at': '2024-01-01T00:00:00Z',
          },
          'access_token': validAuthToken,
          'refresh_token': validRefreshToken,
          'expires_in': 3600,
        },
        'message': 'Login successful',
      };

  static Map<String, dynamic> get loginFailureResponse => {
        'success': false,
        'error': {
          'code': 'INVALID_CREDENTIALS',
          'message': 'Invalid email or password',
        },
      };

  static Map<String, dynamic> get videosListResponse => {
        'success': true,
        'data': {
          'videos': allVideos
              .map((v) => {
                    'id': v.id,
                    'title': v.title,
                    'description': v.description,
                    'thumbnail_url': v.thumbnailUrl,
                    'video_url': v.videoUrl,
                    'duration': v.duration,
                    'genre': v.genre,
                    'rating': v.rating,
                    'release_year': v.releaseYear,
                    'is_featured': v.isFeatured,
                    'is_trending': v.isTrending,
                    'views': v.views,
                    'tags': v.tags,
                  })
              .toList(),
          'total': allVideos.length,
          'page': 1,
          'per_page': 20,
        },
      };
}
