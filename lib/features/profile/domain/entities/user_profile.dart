import 'package:equatable/equatable.dart';

/// Pure domain entity for user profile — zero Flutter dependencies
class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final DateTime? joinedAt;
  final SubscriptionTier subscriptionTier;
  final List<String> favoriteGenres;
  final int totalWatchTimeMinutes;
  final int videosWatched;
  final bool notificationsEnabled;
  final AppLanguage language;
  final VideoQuality preferredQuality;
  final bool autoplayEnabled;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.joinedAt,
    this.subscriptionTier = SubscriptionTier.free,
    this.favoriteGenres = const [],
    this.totalWatchTimeMinutes = 0,
    this.videosWatched = 0,
    this.notificationsEnabled = true,
    this.language = AppLanguage.english,
    this.preferredQuality = VideoQuality.auto,
    this.autoplayEnabled = true,
  });

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? name,
    String? avatarUrl,
    String? bio,
    SubscriptionTier? subscriptionTier,
    List<String>? favoriteGenres,
    int? totalWatchTimeMinutes,
    int? videosWatched,
    bool? notificationsEnabled,
    AppLanguage? language,
    VideoQuality? preferredQuality,
    bool? autoplayEnabled,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      joinedAt: joinedAt,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      totalWatchTimeMinutes:
          totalWatchTimeMinutes ?? this.totalWatchTimeMinutes,
      videosWatched: videosWatched ?? this.videosWatched,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      preferredQuality: preferredQuality ?? this.preferredQuality,
      autoplayEnabled: autoplayEnabled ?? this.autoplayEnabled,
    );
  }

  /// Human-readable watch time
  String get formattedWatchTime {
    final hours = totalWatchTimeMinutes ~/ 60;
    final minutes = totalWatchTimeMinutes % 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        subscriptionTier,
        totalWatchTimeMinutes,
        videosWatched,
        preferredQuality,
      ];
}

/// Subscription tier enum
enum SubscriptionTier {
  free,
  basic,
  premium,
  enterprise;

  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.basic:
        return 'Basic';
      case SubscriptionTier.premium:
        return 'Premium';
      case SubscriptionTier.enterprise:
        return 'Enterprise';
    }
  }

  bool get hasHDAccess => this != SubscriptionTier.free;
  bool get hasOfflineAccess => this == SubscriptionTier.premium || this == SubscriptionTier.enterprise;
  bool get hasAdFreeExperience => this != SubscriptionTier.free;
}

/// App language enum
enum AppLanguage {
  english,
  spanish,
  french,
  german,
  japanese;

  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.spanish:
        return 'es';
      case AppLanguage.french:
        return 'fr';
      case AppLanguage.german:
        return 'de';
      case AppLanguage.japanese:
        return 'ja';
    }
  }
}

/// Video quality preference enum
enum VideoQuality {
  auto,
  sd,
  hd,
  fullHd,
  uhd4k;

  String get displayName {
    switch (this) {
      case VideoQuality.auto:
        return 'Auto';
      case VideoQuality.sd:
        return '480p SD';
      case VideoQuality.hd:
        return '720p HD';
      case VideoQuality.fullHd:
        return '1080p Full HD';
      case VideoQuality.uhd4k:
        return '4K UHD';
    }
  }
}
