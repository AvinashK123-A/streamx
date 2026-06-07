import '../../domain/entities/user.dart';

/// User Data Transfer Object for API communication
class UserDTO {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? bio;
  final String createdAt;
  final bool isEmailVerified;
  final String subscription;

  const UserDTO({
    required this.id, required this.email, required this.name,
    this.avatarUrl, this.bio, required this.createdAt,
    this.isEmailVerified = false, this.subscription = 'free',
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => UserDTO(
    id: json['id'] ?? '', email: json['email'] ?? '',
    name: json['name'] ?? json['display_name'] ?? '',
    avatarUrl: json['avatar_url'] ?? json['profile_picture'],
    bio: json['bio'], createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
    isEmailVerified: json['email_verified'] ?? false,
    subscription: json['subscription'] ?? 'free',
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'email': email, 'name': name, 'avatar_url': avatarUrl,
    'bio': bio, 'created_at': createdAt, 'email_verified': isEmailVerified,
    'subscription': subscription,
  };

  User toDomain() => User(
    id: id, email: email, name: name, avatarUrl: avatarUrl, bio: bio,
    createdAt: DateTime.parse(createdAt), isEmailVerified: isEmailVerified,
    subscription: _parseSubscription(subscription),
  );

  static UserSubscription _parseSubscription(String sub) {
    switch (sub) {
      case 'basic': return UserSubscription.basic;
      case 'premium': return UserSubscription.premium;
      case 'family': return UserSubscription.family;
      default: return UserSubscription.free;
    }
  }

  static UserDTO fromDomain(User user) => UserDTO(
    id: user.id, email: user.email, name: user.name, avatarUrl: user.avatarUrl,
    bio: user.bio, createdAt: user.createdAt.toIso8601String(),
    isEmailVerified: user.isEmailVerified,
    subscription: user.subscription.name,
  );
}
