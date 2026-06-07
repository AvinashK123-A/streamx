import '../../../../core/utils/failure.dart';
import '../entities/user.dart';
import 'package:dartz/dartz.dart';

/// Abstract repository interface for authentication
/// 
/// Defines the contract between domain and data layers.
/// Implementation lives in the data layer.
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  /// Register new user
  Future<Either<Failure, User>> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Send password reset email
  Future<Either<Failure, void>> forgotPassword({required String email});

  /// Get current authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Logout user and clear tokens
  Future<Either<Failure, void>> logout();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Auto-login using stored credentials
  Future<Either<Failure, User?>> autoLogin();

  /// Refresh authentication tokens
  Future<Either<Failure, void>> refreshTokens();
}
