import '../../../../core/network/dio_client.dart';
import '../models/user_dto.dart';
import '../../data/repositories/auth_repository_impl.dart';

class AuthResponse {
  final UserDTO user;
  final String accessToken;
  final String refreshToken;
  const AuthResponse({required this.user, required this.accessToken, required this.refreshToken});
}

class TokenResponse {
  final String accessToken;
  final String refreshToken;
  const TokenResponse({required this.accessToken, required this.refreshToken});
}

/// Remote data source for authentication API calls
/// 
/// In production, this calls real API endpoints.
/// For portfolio demo, implements mock responses.
abstract class AuthRemoteDataSource {
  Future<AuthResponse> login({required String email, required String password});
  Future<AuthResponse> signup({required String name, required String email, required String password});
  Future<void> forgotPassword({required String email});
  Future<UserDTO> getCurrentUser();
  Future<void> logout();
  Future<TokenResponse> refreshTokens({required String refreshToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthResponse> login({required String email, required String password}) async {
    // Mock implementation for portfolio demo
    // In production: final response = await _dioClient.post('/auth/login', data: {'email': email, 'password': password});
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Mock successful response
    if (email.isNotEmpty && password.length >= 6) {
      return AuthResponse(
        user: UserDTO(
          id: 'user_001',
          email: email,
          name: email.split('@').first.replaceAll('.', ' ').split(' ').map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1)).join(' '),
          avatarUrl: 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(email.split('@').first)}&background=E50914&color=fff&size=128',
          createdAt: DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
          isEmailVerified: true,
          subscription: 'premium',
        ),
        accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      );
    }
    throw const AuthException('Invalid credentials');
  }

  @override
  Future<AuthResponse> signup({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthResponse(
      user: UserDTO(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email, name: name,
        avatarUrl: 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=E50914&color=fff&size=128',
        createdAt: DateTime.now().toIso8601String(),
        isEmailVerified: false,
        subscription: 'free',
      ),
      accessToken: 'mock_access_token_new',
      refreshToken: 'mock_refresh_token_new',
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock: email sent successfully
  }

  @override
  Future<UserDTO> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw const AuthException('No user session');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<TokenResponse> refreshTokens({required String refreshToken}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return TokenResponse(
      accessToken: 'mock_access_token_refreshed_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token_refreshed_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
