import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'core/services/analytics_service.dart';
import 'core/services/crashlytics_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/remote_config_service.dart';
import 'core/storage/hive_storage.dart';
import 'core/storage/secure_storage.dart';
import 'core/themes/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

/// StreamX - Production-Ready Netflix-Style Video Streaming Application
/// 
/// Architecture: Clean Architecture + MVVM + GetX
/// Author: Built for portfolio demonstration
/// Version: 1.0.0
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppConstants.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await HiveStorage.init();

  // Initialize services
  await SecureStorage.init();
  await RemoteConfigService.instance.init();
  await NotificationService.instance.init();
  CrashlyticsService.instance.init();
  AnalyticsService.instance.init();

  runApp(const StreamXApp());
}

/// Root application widget
class StreamXApp extends StatelessWidget {
  const StreamXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
    );
  }
}
