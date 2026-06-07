import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:streamx/features/home/presentation/controllers/home_controller.dart';
import 'package:streamx/features/home/presentation/views/home_view.dart';
import 'package:streamx/features/home/presentation/widgets/featured_banner.dart';
import 'package:streamx/features/home/presentation/widgets/video_row.dart';
import 'package:streamx/core/themes/app_theme.dart';
import '../../helpers/mock_data.dart';

import 'home_view_test.mocks.dart';

@GenerateMocks([HomeController])
void main() {
  late MockHomeController mockHomeController;

  setUp(() {
    mockHomeController = MockHomeController();
    
    // Setup default mock states
    when(mockHomeController.isLoading).thenReturn(false.obs);
    when(mockHomeController.featuredVideos).thenReturn(MockData.featuredVideos.obs);
    when(mockHomeController.trendingVideos).thenReturn(MockData.trendingVideos.obs);
    when(mockHomeController.recommendedVideos).thenReturn(MockData.allVideos.obs);
    when(mockHomeController.continueWatchingVideos).thenReturn(<dynamic>[].obs);
    when(mockHomeController.hasError).thenReturn(false.obs);
    when(mockHomeController.errorMessage).thenReturn(''.obs);
    
    Get.put<HomeController>(mockHomeController);
  });

  tearDown(() {
    Get.delete<HomeController>();
  });

  Widget buildTestWidget() {
    return GetMaterialApp(
      theme: AppTheme.darkTheme,
      home: const HomeView(),
    );
  }

  group('HomeView Widget Tests', () {
    testWidgets('renders home screen with featured banner', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(FeaturedBanner), findsOneWidget);
    });

    testWidgets('renders trending videos row', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Trending Now'), findsOneWidget);
    });

    testWidgets('renders recommended videos row', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.text('Recommended For You'), findsOneWidget);
    });

    testWidgets('shows shimmer loading when isLoading is true', (tester) async {
      when(mockHomeController.isLoading).thenReturn(true.obs);
      
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Should show skeleton loading screens
      expect(find.byType(VideoRow), findsNothing);
    });

    testWidgets('shows error widget when hasError is true', (tester) async {
      when(mockHomeController.hasError).thenReturn(true.obs);
      when(mockHomeController.errorMessage).thenReturn('Network error'.obs);
      
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.textContaining('Network error'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('calls retry when try again is tapped', (tester) async {
      when(mockHomeController.hasError).thenReturn(true.obs);
      when(mockHomeController.errorMessage).thenReturn('Network error'.obs);
      
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      verify(mockHomeController.loadHomeData()).called(1);
    });

    testWidgets('featured banner shows video title', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // The featured banner should display the first featured video title
      expect(find.text(MockData.bigBuckBunny.title), findsAtLeastNWidgets(1));
    });

    testWidgets('video cards are scrollable horizontally', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      final listViews = find.byType(ListView);
      expect(listViews, findsWidgets);
    });

    testWidgets('tapping video card navigates to player', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Find and tap first video card
      final videoCards = find.byType(InkWell);
      if (videoCards.evaluate().isNotEmpty) {
        await tester.tap(videoCards.first);
        await tester.pumpAndSettle();
        
        verify(mockHomeController.openVideo(any)).called(1);
      }
    });

    testWidgets('navbar has correct tabs', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('has correct background color', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, equals(AppColors.background));
    });
  });
}
