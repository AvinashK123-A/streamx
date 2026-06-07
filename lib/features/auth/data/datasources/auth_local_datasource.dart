import '../../../../core/storage/secure_storage.dart';
import '../models/user_dto.dart';
import 'dart:convert';

/// Local data source for auth data (secure storage)
abstract class AuthLocalDataSource {
  Future<void> saveTokens({required String accessToken, required String refreshToken});
  Future<void> saveUser(UserDTO user);
  Future<UserDTO?> getUser();
  Future<void> clearData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  @override
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await SecureStorage.saveAccessToken(accessToken);
    await SecureStorage.saveRefreshToken(refreshToken);
  }

  @override
  Future<void> saveUser(UserDTO user) async {
    // Store serialized user in secure storage
    await SecureStorage.saveUserId(user.id);
    await SecureStorage.saveUserEmail(user.email);
    // In production, store full user JSON encrypted
  }

  @override
  Future<UserDTO?> getUser() async {
    final userId = await SecureStorage.getUserId();
    final email = await SecureStorage.getUserEmail();
    if (userId == null || email == null) return null;
    
    return UserDTO(
      id: userId, email: email, name: email.split('@').first,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<void> clearData() async {
    await SecureStorage.clearAll();
  }
}
