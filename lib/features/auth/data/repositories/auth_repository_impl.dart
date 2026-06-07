import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

/// Concrete implementation of AuthRepository
/// 
/// Coordinates between remote (API) and local (secure storage) data sources.
/// Implements offline-first strategy with proper error handling.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final response = await _remoteDataSource.login(email: email, password: password);
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await SecureStorage.setRememberMe(rememberMe);
      await _localDataSource.saveUser(response.user);
      return Right(response.user.toDomain());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.signup(name: name, email: email, password: password);
      await _localDataSource.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      await _localDataSource.saveUser(response.user);
      return Right(response.user.toDomain());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final cachedUser = await _localDataSource.getUser();
      if (cachedUser != null) return Right(cachedUser.toDomain());
      
      final user = await _remoteDataSource.getCurrentUser();
      await _localDataSource.saveUser(user);
      return Right(user.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearData();
      return const Right(null);
    } catch (_) {
      // Clear local data even if remote fails
      await _localDataSource.clearData();
      return const Right(null);
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return SecureStorage.isAuthenticated();
  }

  @override
  Future<Either<Failure, User?>> autoLogin() async {
    try {
      final canLogin = await SecureStorage.canAutoLogin();
      if (!canLogin) return const Right(null);
      
      final user = await _localDataSource.getUser();
      if (user == null) return const Right(null);
      
      return Right(user.toDomain());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshTokens() async {
    try {
      final refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken == null) return Left(const AuthFailure('No refresh token'));
      
      final tokens = await _remoteDataSource.refreshTokens(refreshToken: refreshToken);
      await _localDataSource.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}
