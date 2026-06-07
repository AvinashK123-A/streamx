import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:streamx/features/auth/domain/entities/user.dart';
import 'package:streamx/features/auth/domain/repositories/auth_repository.dart';
import 'package:streamx/features/auth/domain/usecases/login_usecase.dart';
import 'package:streamx/features/auth/domain/usecases/signup_usecase.dart';
import 'package:streamx/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:streamx/features/auth/presentation/controllers/auth_controller.dart';
import 'package:streamx/core/utils/failure.dart';

@GenerateMocks([LoginUseCase, SignupUseCase, ForgotPasswordUseCase, AuthRepository])
import 'auth_controller_test.mocks.dart';

void main() {
  late AuthController sut;
  late MockLoginUseCase mockLoginUseCase;
  late MockSignupUseCase mockSignupUseCase;
  late MockForgotPasswordUseCase mockForgotPasswordUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSignupUseCase = MockSignupUseCase();
    mockForgotPasswordUseCase = MockForgotPasswordUseCase();
    mockAuthRepository = MockAuthRepository();

    sut = AuthController(
      loginUseCase: mockLoginUseCase,
      signupUseCase: mockSignupUseCase,
      forgotPasswordUseCase: mockForgotPasswordUseCase,
      authRepository: mockAuthRepository,
    );

    when(mockAuthRepository.autoLogin()).thenAnswer((_) async => const Right(null));
    Get.testMode = true;
  });

  tearDown(() {
    sut.onClose();
    Get.reset();
  });

  group('AuthController - Login', () {
    const tEmail = 'test@streamx.com';
    const tPassword = 'password123';
    final tUser = User(
      id: 'u1',
      email: tEmail,
      name: 'Test User',
      createdAt: DateTime(2024, 1, 1),
    );

    test('should set isLoading to true while logging in', () async {
      when(mockLoginUseCase(any)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return Right(tUser);
      });

      sut.emailController.text = tEmail;
      sut.passwordController.text = tPassword;

      final future = sut.login();
      expect(sut.isLoading.value, true);
      await future;
      expect(sut.isLoading.value, false);
    });

    test('should call LoginUseCase with correct params', () async {
      when(mockLoginUseCase(any)).thenAnswer((_) async => Right(tUser));
      sut.emailController.text = tEmail;
      sut.passwordController.text = tPassword;

      await sut.login();

      verify(mockLoginUseCase(LoginParams(email: tEmail, password: tPassword)));
    });

    test('should set currentUser on successful login', () async {
      when(mockLoginUseCase(any)).thenAnswer((_) async => Right(tUser));
      sut.emailController.text = tEmail;
      sut.passwordController.text = tPassword;

      await sut.login();

      expect(sut.currentUser.value, equals(tUser));
    });

    test('should set errorMessage on login failure', () async {
      const tFailure = AuthFailure('Invalid credentials');
      when(mockLoginUseCase(any)).thenAnswer((_) async => const Left(tFailure));
      sut.emailController.text = tEmail;
      sut.passwordController.text = tPassword;

      await sut.login();

      expect(sut.errorMessage.value, equals('Invalid credentials'));
      expect(sut.currentUser.value, isNull);
    });
  });

  group('AuthController - Validators', () {
    test('should return null for valid email', () {
      expect(sut.validateEmail('test@example.com'), isNull);
    });

    test('should return error for invalid email', () {
      expect(sut.validateEmail('invalid-email'), isNotNull);
    });

    test('should return error for empty email', () {
      expect(sut.validateEmail(''), isNotNull);
    });

    test('should return null for valid password', () {
      expect(sut.validatePassword('password123'), isNull);
    });

    test('should return error for short password', () {
      expect(sut.validatePassword('12345'), isNotNull);
    });

    test('should return null for matching passwords', () {
      sut.passwordController.text = 'password123';
      expect(sut.validateConfirmPassword('password123'), isNull);
    });

    test('should return error for non-matching passwords', () {
      sut.passwordController.text = 'password123';
      expect(sut.validateConfirmPassword('different'), isNotNull);
    });
  });

  group('AuthController - Toggle', () {
    test('should toggle password visibility', () {
      expect(sut.isPasswordVisible.value, false);
      sut.togglePasswordVisibility();
      expect(sut.isPasswordVisible.value, true);
      sut.togglePasswordVisibility();
      expect(sut.isPasswordVisible.value, false);
    });

    test('should toggle remember me', () {
      expect(sut.rememberMe.value, false);
      sut.toggleRememberMe();
      expect(sut.rememberMe.value, true);
    });
  });
}
