import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import '../widgets/streamx_logo.dart';

/// Splash Screen with animated StreamX logo
/// Handles initial routing based on auth state
class SplashView extends GetView<AuthController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: child,
                  ),
                );
              },
              child: const StreamXLogo(size: 80),
            ),
            const SizedBox(height: 24),
            
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) => Opacity(opacity: value, child: child),
              child: Text(
                'StreamX',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1400),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) => Opacity(opacity: value, child: child),
              child: Text(
                'Stream Everything.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  letterSpacing: 2,
                  color: Colors.grey,
                ),
              ),
            ),
            
            const SizedBox(height: 80),
            
            const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(
                color: AppConstants.primaryColor,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
