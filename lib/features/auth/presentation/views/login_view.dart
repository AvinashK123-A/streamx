import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/streamx_logo.dart';
import '../widgets/social_login_button.dart';

/// Login Screen - Netflix-inspired dark theme
/// 
/// Features:
/// - Email/Password authentication
/// - Remember me toggle
/// - Forgot password navigation
/// - Social login placeholders
/// - Form validation
/// - Loading states
class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0A),
              AppConstants.backgroundColor,
              Color(0xFF1A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                
                // StreamX Logo
                const StreamXLogo(size: 56),
                const SizedBox(height: 8),
                Text(
                  'StreamX',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue watching',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Login Form
                Form(
                  key: controller.loginFormKey,
                  child: Column(
                    children: [
                      // Email Field
                      AuthTextField(
                        controller: controller.emailController,
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: controller.validateEmail,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      
                      // Password Field
                      Obx(() => AuthTextField(
                        controller: controller.passwordController,
                        label: 'Password',
                        hint: 'Enter your password',
                        obscureText: !controller.isPasswordVisible.value,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: controller.isPasswordVisible.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        onSuffixTap: controller.togglePasswordVisibility,
                        validator: controller.validatePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => controller.login(),
                      )),
                      
                      const SizedBox(height: 12),
                      
                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: controller.rememberMe.value,
                                  onChanged: (_) => controller.toggleRememberMe(),
                                  activeColor: AppConstants.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Remember me',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          )),
                          TextButton(
                            onPressed: controller.navigateToForgotPassword,
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Sign In Button
                      Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          backgroundColor: AppConstants.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'SIGN IN',
                                style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.5,
                                ),
                              ),
                      )),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFF333333))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR', style: Theme.of(context).textTheme.bodySmall),
                    ),
                    const Expanded(child: Divider(color: Color(0xFF333333))),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Social Login
                SocialLoginButton(
                  icon: 'assets/icons/google.png',
                  label: 'Continue with Google',
                  onTap: () => Get.snackbar('Coming Soon', 'Google login coming soon', snackPosition: SnackPosition.BOTTOM),
                ),
                const SizedBox(height: 12),
                SocialLoginButton(
                  icon: 'assets/icons/apple.png',
                  label: 'Continue with Apple',
                  onTap: () => Get.snackbar('Coming Soon', 'Apple login coming soon', snackPosition: SnackPosition.BOTTOM),
                ),
                
                const SizedBox(height: 40),
                
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: controller.navigateToSignup,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppConstants.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
