import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:streamx/main.dart' as app;

/// Integration test for the complete Video Playback Flow
///
/// Tests:
/// 1. Home screen loads with videos
/// 2. Tapping video card opens player
/// 3. Video player controls work correctly
/// 4. Player back button returns to home
/// 5. Continue watching shows in home after partial playback
/// 6. Search for video and play it
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Video Playback Flow Integration Tests', () {
    Future<void> loginAndGoHome(WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Login with demo account
      await tester.enterText(
        find.byType(TextFormField).first,
        'demo@streamx.app',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'Demo@123',
      );
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    // ============================================================
    // Home Screen Video Loading
    // ============================================================

    testWidgets('home screen loads with featured videos', (tester) async {
      await loginAndGoHome(tester);

      // Should see featured banner
      expect(find.text('Big Buck Bunny'), findsAtLeastNWidgets(1));
    });

    testWidgets('home screen shows trending videos row', (tester) async {
      await loginAndGoHome(tester);

      expect(find.text('Trending Now'), findsOneWidget);
    });

    testWidgets('home screen shows recommended videos row', (tester) async {
      await loginAndGoHome(tester);

      expect(find.text('Recommended For You'), findsOneWidget);
    });

    // ============================================================
    // Video Player Navigation
    // ============================================================

    testWidgets('tapping featured video opens player', (tester) async {
      await loginAndGoHome(tester);

      // Tap "Play" on featured banner
      final playButton = find.text('Play');
      if (playButton.evaluate().isNotEmpty) {
        await tester.tap(playButton.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Player should open with video title
        expect(find.text('Big Buck Bunny'), findsOneWidget);
      }
    });

    testWidgets('video player shows controls overlay', (tester) async {
      await loginAndGoHome(tester);

      final playButton = find.text('Play');
      if (playButton.evaluate().isNotEmpty) {
        await tester.tap(playButton.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Should see player controls
        expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      }
    });

    // ============================================================
    // Player Controls
    // ============================================================

    testWidgets('player play/pause button toggles correctly', (tester) async {
      await loginAndGoHome(tester);

      final playButton = find.text('Play');
      if (playButton.evaluate().isNotEmpty) {
        await tester.tap(playButton.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Tap play button
        await tester.tap(find.byIcon(Icons.play_arrow_rounded));
        await tester.pumpAndSettle();

        // Should now show pause icon
        expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
      }
    });

    testWidgets('player back button returns to home', (tester) async {
      await loginAndGoHome(tester);

      final playButton = find.text('Play');
      if (playButton.evaluate().isNotEmpty) {
        await tester.tap(playButton.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Tap back button
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Should be back at home
        expect(find.text('Trending Now'), findsOneWidget);
      }
    });

    // ============================================================
    // Search and Play Flow
    // ============================================================

    testWidgets('search for video and open it from results', (tester) async {
      await loginAndGoHome(tester);

      // Navigate to search tab
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Bunny');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should see search results
      expect(find.text('Big Buck Bunny'), findsAtLeastNWidgets(1));

      // Tap on search result
      await tester.tap(find.text('Big Buck Bunny').first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should open video player
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    // ============================================================
    // Continue Watching
    // ============================================================

    testWidgets('partially watched video appears in continue watching', (tester) async {
      await loginAndGoHome(tester);

      // Open a video and seek forward
      final playButton = find.text('Play');
      if (playButton.evaluate().isNotEmpty) {
        await tester.tap(playButton.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Play for a bit
        await tester.tap(find.byIcon(Icons.play_arrow_rounded));
        await tester.pump(const Duration(seconds: 5));

        // Go back
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Check for continue watching row
        expect(find.text('Continue Watching'), findsOneWidget);
      }
    });
  });
}
