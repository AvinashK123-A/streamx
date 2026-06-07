import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:streamx/features/auth/presentation/controllers/auth_controller.dart';
import 'package:streamx/features/auth/presentation/views/login_view.dart';
import 'package:streamx/core/themes/app_theme.dart';

import 'login_view_test.mocks.dart';

@GenerateMocks([AuthController])
void main() {
  late MockAuthController mockAuthController;

  setUp(() {
    mockAuthController = MockAuthController();
    
    // Setup default mock behaviors
    when(mockAuthController.isLoading).thenReturn(false.obs);
    when(mockAuthController.emailController).thenReturn(TextEditingController());
    when(mockAuthController.passwordController).thenReturn(TextEditingController());
    when(mockAuthController.isPasswordVisible).thenReturn(false.obs);
    when(mockAuthController.rememberMe).thenReturn(false.obs);
    
    Get.put<AuthController>(mockAuthController);
  });

  tearDown(() {
    Get.delete<AuthController>();
  });

  Widget buildTestWidget() {
    return GetMaterialApp(
      theme: AppTheme.darkTheme,
      home: const LoginView(),
    );
  }

  group('LoginView Widget Tests', () {
    testWidgets('renders login screen with all required elements', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Verify StreamX logo/title is present
      expect(find.text('STREAMX'), findsOneWidget);

      // Verify email field is present
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Verify login button is present
      expect(find.text('Sign In'), findsOneWidget);

      // Verify forgot password link
      expect(find.text('Forgot Password?'), findsOneWidget);

      // Verify signup link
      expect(find.textContaining("Don't have an account"), findsOneWidget);
    });

    testWidgets('shows validation error for empty email', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Tap login button without entering any data
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Validation should trigger
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Enter invalid email
      await tester.enterText(
        find.byType(TextFormField).first,
        'not-an-email',
      );
      
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('shows validation error for empty password', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Enter valid email but no password
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows password validation error for short password', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('calls login when form is valid', (tester) async {
      when(mockAuthController.login()).thenAnswer((_) async {});
      
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );

      await tester.tap(find.text('Sign In'));
      await tester.pump();

      verify(mockAuthController.login()).called(1);
    });

    testWidgets('shows loading indicator when isLoading is true', (tester) async {
      when(mockAuthController.isLoading).thenReturn(true.obs);
      
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Sign In button text should be hidden during loading
      expect(find.text('Sign In'), findsNothing);
    });

    testWidgets('password visibility toggle works correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      // Initially password should be obscured
      final passwordField = tester.widget<TextFormField>(
        find.byType(TextFormField).last,
      );
      expect(passwordField.obscureText, isTrue);

      // Tap visibility toggle icon
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      // Password should now be visible
      verify(mockAuthController.togglePasswordVisibility()).called(1);
    });

    testWidgets('remember me checkbox toggles correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      verify(mockAuthController.toggleRememberMe()).called(1);
    });

    testWidgets('forgot password navigates to forgot password screen', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      // Should navigate to forgot password screen
      verify(mockAuthController.goToForgotPassword()).called(1);
    });

    testWidgets('sign up link navigates to signup screen', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      verify(mockAuthController.goToSignup()).called(1);
    });

    testWidgets('has correct dark theme colors', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(AppColors.background));
    });
  });
}
