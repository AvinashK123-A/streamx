import 'package:flutter_test/flutter_test.dart';
import 'package:streamx/features/home/domain/entities/video.dart';

void main() {
  final tVideo = Video(
    id: 'v001',
    title: 'Big Buck Bunny',
    description: 'Test description',
    thumbnailUrl: 'https://example.com/thumb.jpg',
    videoUrl: 'https://example.com/video.mp4',
    duration: const Duration(hours: 1, minutes: 30, seconds: 45),
    genre: 'Animation',
    releaseDate: DateTime(2008, 4, 10),
    rating: 8.4,
    viewCount: 2500000,
    quality: VideoQuality.hd,
  );

  group('Video Entity', () {
    test('should format duration correctly for hours', () {
      expect(tVideo.formattedDuration, equals('1h 30m'));
    });

    test('should format duration correctly for minutes only', () {
      final shortVideo = tVideo.copyWith(duration: const Duration(minutes: 45));
      expect(shortVideo.formattedDuration, equals('45m'));
    });

    test('should format rating correctly', () {
      expect(tVideo.formattedRating, equals('8.4'));
    });

    test('should format view count in millions', () {
      expect(tVideo.formattedViewCount, equals('2.5M views'));
    });

    test('should format view count in thousands', () {
      final video = tVideo.copyWith(viewCount: 45000);
      expect(video.formattedViewCount, equals('45.0K views'));
    });

    test('should format view count for small numbers', () {
      final video = tVideo.copyWith(viewCount: 999);
      expect(video.formattedViewCount, equals('999 views'));
    });

    test('should return year as string', () {
      expect(tVideo.yearString, equals('2008'));
    });

    test('should copy with updated fields', () {
      final updated = tVideo.copyWith(title: 'Updated Title', rating: 9.0);
      expect(updated.title, equals('Updated Title'));
      expect(updated.rating, equals(9.0));
      expect(updated.id, equals(tVideo.id)); // unchanged
    });

    test('should be equal when props are the same', () {
      final same = Video(
        id: 'v001', title: 'Big Buck Bunny', description: 'Test description',
        thumbnailUrl: 'https://example.com/thumb.jpg', videoUrl: 'https://example.com/video.mp4',
        duration: const Duration(hours: 1, minutes: 30, seconds: 45),
        genre: 'Animation', releaseDate: DateTime(2008, 4, 10), rating: 8.4,
      );
      expect(tVideo, equals(same));
    });
  });
}
