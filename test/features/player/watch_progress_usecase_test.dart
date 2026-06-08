import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:streamx/features/player/domain/entities/playback_state.dart';
import 'package:streamx/features/player/domain/repositories/player_repository.dart';
import 'package:streamx/features/player/domain/usecases/save_watch_progress_usecase.dart';

import 'watch_progress_usecase_test.mocks.dart';

@GenerateMocks([PlayerRepository])
void main() {
  late MockPlayerRepository mockPlayerRepository;
  late SaveWatchProgressUseCase saveWatchProgressUseCase;

  setUp(() {
    mockPlayerRepository = MockPlayerRepository();
    saveWatchProgressUseCase = SaveWatchProgressUseCase(mockPlayerRepository);
  });

  final now = DateTime.now();

  WatchProgress makeProgress({
    required int positionSeconds,
    required int durationSeconds,
  }) {
    return WatchProgress(
      videoId: 'video_001',
      position: Duration(seconds: positionSeconds),
      duration: Duration(seconds: durationSeconds),
      lastWatchedAt: now,
    );
  }

  group('SaveWatchProgressUseCase', () {
    test('should save progress when >= 5% watched', () async {
      // 10% watched
      final progress = makeProgress(positionSeconds: 60, durationSeconds: 596);
      when(mockPlayerRepository.saveWatchProgress(progress))
          .thenAnswer((_) async => const Right(unit));

      final result = await saveWatchProgressUseCase(progress);

      expect(result, const Right(unit));
      verify(mockPlayerRepository.saveWatchProgress(progress)).called(1);
    });

    test('should NOT save progress when < 5% watched (business rule)', () async {
      // 3% watched — below threshold
      final progress = makeProgress(positionSeconds: 18, durationSeconds: 596);

      final result = await saveWatchProgressUseCase(progress);

      // Should return Right(unit) without calling repository
      expect(result, const Right(unit));
      verifyNever(mockPlayerRepository.saveWatchProgress(any));
    });

    test('should DELETE progress when > 95% watched (completed — business rule)', () async {
      // 97% watched
      final progress = makeProgress(positionSeconds: 578, durationSeconds: 596);
      when(mockPlayerRepository.deleteWatchProgress('video_001'))
          .thenAnswer((_) async => const Right(unit));

      final result = await saveWatchProgressUseCase(progress);

      expect(result, const Right(unit));
      verify(mockPlayerRepository.deleteWatchProgress('video_001')).called(1);
      verifyNever(mockPlayerRepository.saveWatchProgress(any));
    });

    test('should save progress at exactly 5% boundary', () async {
      // Exactly 5% — should save
      final progress = makeProgress(positionSeconds: 30, durationSeconds: 596);
      when(mockPlayerRepository.saveWatchProgress(progress))
          .thenAnswer((_) async => const Right(unit));

      final result = await saveWatchProgressUseCase(progress);

      verify(mockPlayerRepository.saveWatchProgress(progress)).called(1);
    });

    test('should save progress at 50% (middle of video)', () async {
      final progress = makeProgress(positionSeconds: 298, durationSeconds: 596);
      when(mockPlayerRepository.saveWatchProgress(progress))
          .thenAnswer((_) async => const Right(unit));

      await saveWatchProgressUseCase(progress);

      verify(mockPlayerRepository.saveWatchProgress(progress)).called(1);
    });
  });
}
