import 'package:flutter/material.dart';

/// Application-wide constants for StreamX
/// 
/// Contains all magic strings, dimensions, and configuration values
/// used throughout the application.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'StreamX';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appBundleId = 'com.portfolio.streamx';

  // Colors
  static const Color primaryColor = Color(0xFFE50914);
  static const Color backgroundColor = Color(0xFF141414);
  static const Color surfaceColor = Color(0xFF1F1F1F);
  static const Color cardColor = Color(0xFF2A2A2A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF999999);
  static const Color shimmerBase = Color(0xFF2A2A2A);
  static const Color shimmerHighlight = Color(0xFF3A3A3A);

  // API Configuration
  static const String baseUrl = 'https://api.streamx-mock.com/v1';
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000;    // 30 seconds

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String rememberMeKey = 'remember_me';
  static const String onboardingKey = 'onboarding_completed';
  static const String watchHistoryBox = 'watch_history';
  static const String searchHistoryBox = 'search_history';
  static const String settingsBox = 'settings';
  static const String videoCacheBox = 'video_cache';

  // Pagination
  static const int defaultPageSize = 20;
  static const int featuredLimit = 5;
  static const int trendingLimit = 10;
  static const int recommendedLimit = 20;

  // Video Configuration
  static const int bufferDuration = 30; // seconds
  static const int maxCacheSize = 200 * 1024 * 1024; // 200 MB
  static const double seekAmount = 10.0; // seconds
  static const List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  static const List<String> videoQualities = ['Auto', '1080p', '720p', '480p', '360p'];

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  static const Duration splashDuration = Duration(seconds: 2);

  // Layout
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double cardBorderRadius = 12.0;
  static const double thumbnailAspectRatio = 16 / 9;

  // Public Video Sources (Free for streaming)
  static const String bigBuckBunnyUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
  static const String sintelUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4';
  static const String elephantsDreamUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4';
  static const String forBiggerBlazesUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4';
  static const String forBiggerEscapesUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4';
  static const String subwaySurferUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubwaySurfers.mp4';
  static const String tearsOfSteelUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4';
  static const String volkswagenGTIUrl =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4';

  // Thumbnail URLs (public domain)
  static const String bigBuckBunnyThumb =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Camponotus_flavomarginatus_ant.jpg/320px-Camponotus_flavomarginatus_ant.jpg';

  // Error Messages
  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Server error. Please try again later';
  static const String sessionExpired = 'Your session has expired. Please login again';
  static const String unknownError = 'An unexpected error occurred';
  static const String validationError = 'Please check your input';

  // Success Messages
  static const String loginSuccess = 'Welcome back!';
  static const String logoutSuccess = 'Logged out successfully';
  static const String profileUpdated = 'Profile updated successfully';

  // Route Arguments
  static const String videoArg = 'video';
  static const String userArg = 'user';
}
