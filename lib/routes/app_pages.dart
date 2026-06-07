import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../features/auth/presentation/bindings/auth_binding.dart';
import '../features/auth/presentation/views/splash_view.dart';
import '../features/auth/presentation/views/login_view.dart';
import '../features/auth/presentation/views/signup_view.dart';
import '../features/auth/presentation/views/forgot_password_view.dart';
import '../features/home/presentation/bindings/home_binding.dart';
import '../features/home/presentation/views/home_view.dart';
import '../features/player/presentation/bindings/player_binding.dart';
import '../features/player/presentation/views/player_view.dart';
import '../features/search/presentation/bindings/search_binding.dart';
import '../features/search/presentation/views/search_view.dart';
import '../features/profile/presentation/bindings/profile_binding.dart';
import '../features/profile/presentation/views/profile_view.dart';
import '../features/profile/presentation/views/settings_view.dart';
import '../features/profile/presentation/views/watch_history_view.dart';

/// GetX Route Management - Centralized route configuration
/// 
/// All routes are defined here with their corresponding bindings
/// for dependency injection and views for rendering.
class AppPages {
  AppPages._();

  static final List<GetPage> routes = [
    // Splash
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),

    // Authentication
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),

    // Home (Main Shell)
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),

    // Player
    GetPage(
      name: AppRoutes.player,
      page: () => const PlayerView(),
      binding: PlayerBinding(),
      transition: Transition.downToUp,
      fullscreenDialog: true,
    ),

    // Search
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition.fadeIn,
    ),

    // Profile
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.watchHistory,
      page: () => const WatchHistoryView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
