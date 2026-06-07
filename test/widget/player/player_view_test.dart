import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:video_player/video_player.dart';

import 'package:streamx/features/player/presentation/controllers/player_controller.dart';
import 'package:streamx/features/player/presentation/views/player_view.dart';
import 'package:streamx/features/home/domain/entities/video.dart';
import 'package:streamx/core/themes/app_theme.dart';
import '../../helpers/mock_data.dart';

import 'player_view_test.mocks.dart';

@GenerateMocks([PlayerController])
void main() {
  late MockPlayerController mockPlayerController;

  setUp(() {
    mockPlayerController = MockPlayerController();
    
    // Setup default mock states
    when(mockPlayerController.currentVideo).thenReturn(Rx<Video?>(MockData.bigBuckBunny));
    when(mockPlayerController.isPlaying).thenReturn(false.obs);
    when(mockPlayerController.isLoading).thenReturn(false.obs);
    when(mockPlayerController.isBuffering).thenReturn(false.obs);
    when(mockPlayerController.isFullscreen).thenReturn(false.obs);
    when(mockPlayerController.showControls).thenReturn(true.obs);
    when(mockPlayerController.position).thenReturn(Duration.zero.obs);
    when(mockPlayerController.duration).thenReturn(const Duration(seconds: 596).obs);
    when(mockPlayerController.bufferedPosition).thenReturn(Duration.zero.obs);
    when(mockPlayerController.playbackSpeed).thenReturn(1.0.obs);
    when(mockPlayerController.volume).thenReturn(1.0.obs);
    when(mockPlayerController.hasError).thenReturn(false.obs);
    when(mockPlayerController.errorMessage).thenReturn(''.obs);
    
    Get.put<PlayerController>(mockPlayerController);
  });

  tearDown(() {
    Get.delete<PlayerController>();
  });

  Widget buildTestWidget({Video? video}) {
    return GetMaterialApp(
      theme: AppTheme.darkTheme,
      home: PlayerView(video: video ?? MockData.bigBuckBunny),
    );
  }

  group('PlayerView Widget Tests', () {
    testWidgets('renders player view with video title', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text(MockData.bigBuckBunny.title), findsOneWidget);
    });

    testWidgets('shows video player widget', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // AspectRatio wraps the video player
      expect(find.byType(AspectRatio), findsAtLeastNWidgets(1));
    });

    testWidgets('shows play/pause button when controls are visible', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Should show play icon when paused
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    testWidgets('shows pause icon when video is playing', (tester) async {
      when(mockPlayerController.isPlaying).thenReturn(true.obs);
      
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
    });

    testWidgets('shows buffering indicator when buffering', (tester) async {
      when(mockPlayerController.isBuffering).thenReturn(true.obs);
      
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('tapping play button calls togglePlayPause', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.pump();

      verify(mockPlayerController.togglePlayPause()).called(1);
    });

    testWidgets('shows progress slider', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('shows forward and backward seek buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.replay_10_rounded), findsOneWidget);
      expect(find.byIcon(Icons.forward_30_rounded), findsOneWidget);
    });

    testWidgets('backward seek button calls seekBackward', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.replay_10_rounded));
      await tester.pump();

      verify(mockPlayerController.seekBackward()).called(1);
    });

    testWidgets('forward seek button calls seekForward', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.forward_30_rounded));
      await tester.pump();

      verify(mockPlayerController.seekForward()).called(1);
    });

    testWidgets('shows error widget when hasError is true', (tester) async {
      when(mockPlayerController.hasError).thenReturn(true.obs);
      when(mockPlayerController.errorMessage).thenReturn('Video not available'.obs);
      
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.textContaining('Video not available'), findsOneWidget);
    });

    testWidgets('shows fullscreen toggle button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.fullscreen_rounded), findsOneWidget);
    });

    testWidgets('tapping fullscreen calls toggleFullscreen', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.fullscreen_rounded));
      await tester.pump();

      verify(mockPlayerController.toggleFullscreen()).called(1);
    });
  });
}
