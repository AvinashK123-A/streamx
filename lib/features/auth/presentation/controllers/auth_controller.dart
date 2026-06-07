import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/failure.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/repositories/auth_repository.dart';

/// Authentication Controller - manages all auth state and operations
/// 
/// Follows MVVM pattern with GetX reactive state management.
/// Handles login, signup, forgot password, and auto-login flows.
class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final AuthRepository _authRepository;

  AuthController({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _authRepository = authRepository;

  // ============ Reactive State ============
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool rememberMe = false.obs;
  final RxString errorMessage = ''.obs;

  // Form Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  // Form Keys
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();

  // ============ Lifecycle ============
  @override
  void onInit() {
    super.onInit();
    _checkAutoLogin();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  // ============ Business Logic ============
  
  Future<void> _checkAutoLogin() async {
    final result = await _authRepository.autoLogin();
    result.fold(
      (failure) => null, // Not logged in, stay on login
      (user) {
        if (user != null) {
          currentUser.value = user;
          Get.offAllNamed(AppRoutes.home);
        }
      },
    );
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _loginUseCase(LoginParams(
      email: emailController.text.trim(),
      password: passwordController.text,
      rememberMe: rememberMe.value,
    ));

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        _showError(failure.message);
      },
      (user) {
        currentUser.value = user;
        AnalyticsService.instance.logLogin('email');
        AnalyticsService.instance.setUserId(user.id);
        Get.offAllNamed(AppRoutes.home);
      },
    );

    isLoading.value = false;
  }

  Future<void> signup() async {
    if (!signupFormKey.currentState!.validate()) return;
    
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _signupUseCase(SignupParams(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    ));

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        _showError(failure.message);
      },
      (user) {
        currentUser.value = user;
        AnalyticsService.instance.logSignUp('email');
        AnalyticsService.instance.setUserId(user.id);
        Get.offAllNamed(AppRoutes.home);
      },
    );

    isLoading.value = false;
  }

  Future<void> forgotPassword() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;
    
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: emailController.text.trim()),
    );

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        _showError(failure.message);
      },
      (_) {
        Get.snackbar(
          'Email Sent',
          'Password reset instructions sent to ${emailController.text.trim()}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        Get.back();
      },
    );

    isLoading.value = false;
  }

  Future<void> logout() async {
    isLoading.value = true;
    await _authRepository.logout();
    currentUser.value = null;
    AnalyticsService.instance.logLogout();
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.login);
  }

  // ============ UI Helpers ============
  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();
  void toggleRememberMe() => rememberMe.toggle();
  void clearError() => errorMessage.value = '';

  void navigateToSignup() {
    _clearForms();
    Get.toNamed(AppRoutes.signup);
  }

  void navigateToLogin() {
    _clearForms();
    Get.back();
  }

  void navigateToForgotPassword() => Get.toNamed(AppRoutes.forgotPassword);

  // ============ Validators ============
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(value)) return 'Enter a valid email address';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    if (value.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFCF6679),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _clearForms() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    errorMessage.value = '';
  }
}
