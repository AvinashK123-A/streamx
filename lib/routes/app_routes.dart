/// All application route paths
/// 
/// Centralized route name management for type-safe navigation.
class AppRoutes {
  AppRoutes._();

  // Splash & Onboarding
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Authentication
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Main Navigation (Shell)
  static const String main = '/main';

  // Home
  static const String home = '/home';

  // Search
  static const String search = '/search';
  static const String searchResults = '/search/results';

  // Player
  static const String player = '/player';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String watchHistory = '/profile/watch-history';
  static const String settings = '/profile/settings';
  static const String about = '/profile/about';
}
