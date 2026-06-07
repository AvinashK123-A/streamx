import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:streamx/main.dart' as app;

/// Integration test for the complete Authentication Flow
///
/// Tests:
/// 1. App launches and shows splash screen
/// 2. Unauthenticated user is redirected to login
/// 3. Form validation works on login screen
/// 4. Successful login navigates to home screen
/// 5. Logout navigates back to login screen
/// 6. Signup flow navigates correctly
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    // ============================================================
    // Splash Screen Tests
    // ============================================================

    testWidgets('app launches and shows splash screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Splash screen should be visible initially
      expect(find.text('STREAMX'), findsOneWidget);
    });

    testWidgets('unauthenticated user is redirected to login', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // After splash, should see login screen
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    // ============================================================
    // Login Form Validation Tests
    // ============================================================

    testWidgets('login form shows validation errors for empty fields', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap sign in without entering data
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Should see validation errors
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('login form validates email format', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Enter invalid email
      await tester.enterText(
        find.byType(TextFormField).first,
        'invalid-email',
      );
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('login form validates minimum password length', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.enterText(find.byType(TextFormField).first, 'test@test.com');
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    // ============================================================
    // Login Success Flow
    // ============================================================

    testWidgets('successful login navigates to home screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Enter demo credentials (mock login in test env)
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

      // Should navigate to home screen
      expect(find.text('STREAMX'), findsOneWidget);
      expect(find.text('Trending Now'), findsOneWidget);
    });

    // ============================================================
    // Navigation Flow Tests  
    // ============================================================

    testWidgets('forgot password link navigates to forgot password screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      expect(find.text('Reset Password'), findsOneWidget);
    });

    testWidgets('sign up link navigates to signup screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Should see signup screen
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('signup back button returns to login screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Tap back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.text('Sign In'), findsOneWidget);
    });

    // ============================================================
    // Logout Flow Tests
    // ============================================================

    testWidgets('logout from profile navigates to login screen', (tester) async {
      // This test requires being logged in first
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Login first
      await tester.enterText(find.byType(TextFormField).first, 'demo@streamx.app');
      await tester.enterText(find.byType(TextFormField).last, 'Demo@123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile tab
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Tap logout button
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      // Confirm logout in dialog
      await tester.tap(find.text('Logout').last);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should be back at login screen
      expect(find.text('Sign In'), findsOneWidget);
    });
  });
}
