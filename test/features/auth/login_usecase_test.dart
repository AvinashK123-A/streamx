import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:streamx/core/utils/failure.dart';
import 'package:streamx/features/auth/domain/entities/user.dart';
import 'package:streamx/features/auth/domain/repositories/auth_repository.dart';
import 'package:streamx/features/auth/domain/usecases/login_usecase.dart';

import 'login_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  const validEmail = 'test@example.com';
  const validPassword = 'Password123!';

  const testUser = User(
    id: 'user_001',
    name: 'Test User',
    email: validEmail,
    isEmailVerified: true,
    createdAt: '2024-01-01T00:00:00Z',
  );

  group('LoginUseCase', () {
    test('should return User on successful login', () async {
      // Arrange
      when(mockAuthRepository.login(
        email: validEmail,
        password: validPassword,
      )).thenAnswer((_) async => const Right(testUser));

      // Act
      final result = await loginUseCase(
        LoginParams(email: validEmail, password: validPassword),
      );

      // Assert
      expect(result, const Right(testUser));
      verify(mockAuthRepository.login(
        email: validEmail,
        password: validPassword,
      )).called(1);
    });

    test('should return AuthFailure on invalid credentials', () async {
      // Arrange
      when(mockAuthRepository.login(
        email: validEmail,
        password: 'wrongpassword',
      )).thenAnswer((_) async => const Left(AuthFailure('Invalid credentials')));

      // Act
      final result = await loginUseCase(
        LoginParams(email: validEmail, password: 'wrongpassword'),
      );

      // Assert
      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<AuthFailure>()),
        (_) => fail('Should have returned a failure'),
      );
    });

    test('should return NetworkFailure on no internet', () async {
      // Arrange
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Left(NetworkFailure()));

      // Act
      final result = await loginUseCase(
        LoginParams(email: validEmail, password: validPassword),
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should have returned a failure'),
      );
    });

    test('should return ServerFailure on 5xx server error', () async {
      // Arrange
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async =>
          const Left(ServerFailure('Internal server error')));

      // Act
      final result = await loginUseCase(
        LoginParams(email: validEmail, password: validPassword),
      );

      // Assert
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should have returned a failure'),
      );
    });

    test('should call repository exactly once per invocation', () async {
      // Arrange
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Right(testUser));

      // Act
      await loginUseCase(LoginParams(email: validEmail, password: validPassword));
      await loginUseCase(LoginParams(email: validEmail, password: validPassword));

      // Assert — called exactly twice (once per invocation)
      verify(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).called(2);
    });

    test('should pass correct credentials to repository', () async {
      // Arrange
      const testEmail = 'specific@email.com';
      const testPassword = 'SpecificPass!99';

      when(mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => const Right(testUser));

      // Act
      await loginUseCase(
        LoginParams(email: testEmail, password: testPassword),
      );

      // Assert
      verify(mockAuthRepository.login(
        email: testEmail,
        password: testPassword,
      )).called(1);

      verifyNever(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ));
    });
  });
}
