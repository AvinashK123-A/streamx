import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/streamx_logo.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A0A), AppConstants.backgroundColor, Color(0xFF1A0A0A)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: controller.navigateToLogin,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const StreamXLogo(size: 48),
                const SizedBox(height: 24),
                Text('Create Account', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Join StreamX today', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 40),
                Form(
                  key: controller.signupFormKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        controller: controller.nameController,
                        label: 'Full Name', hint: 'Enter your full name',
                        prefixIcon: Icons.person_outline,
                        validator: controller.validateName,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: controller.emailController,
                        label: 'Email', hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: controller.validateEmail,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      Obx(() => AuthTextField(
                        controller: controller.passwordController,
                        label: 'Password', hint: 'Min. 6 characters',
                        obscureText: !controller.isPasswordVisible.value,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: controller.isPasswordVisible.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        onSuffixTap: controller.togglePasswordVisibility,
                        validator: controller.validatePassword,
                        textInputAction: TextInputAction.next,
                      )),
                      const SizedBox(height: 16),
                      Obx(() => AuthTextField(
                        controller: controller.confirmPasswordController,
                        label: 'Confirm Password', hint: 'Re-enter password',
                        obscureText: !controller.isConfirmPasswordVisible.value,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: controller.isConfirmPasswordVisible.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        onSuffixTap: controller.toggleConfirmPasswordVisibility,
                        validator: controller.validateConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => controller.signup(),
                      )),
                      const SizedBox(height: 32),
                      Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.signup,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 54),
                          backgroundColor: AppConstants.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('CREATE ACCOUNT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: controller.navigateToLogin,
                      child: const Text('Sign In', style: TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.w700)),
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
