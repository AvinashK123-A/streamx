import 'package:equatable/equatable.dart';

/// User entity in the domain layer
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? bio;
  final DateTime createdAt;
  final bool isEmailVerified;
  final UserSubscription subscription;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.bio,
    required this.createdAt,
    this.isEmailVerified = false,
    this.subscription = UserSubscription.free,
  });

  User copyWith({
    String? id, String? email, String? name, String? avatarUrl,
    String? bio, DateTime? createdAt, bool? isEmailVerified, UserSubscription? subscription,
  }) {
    return User(
      id: id ?? this.id, email: email ?? this.email, name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl, bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt, isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      subscription: subscription ?? this.subscription,
    );
  }

  @override
  List<Object?> get props => [id, email, name, avatarUrl, bio, createdAt, isEmailVerified, subscription];
}

enum UserSubscription { free, basic, premium, family }
