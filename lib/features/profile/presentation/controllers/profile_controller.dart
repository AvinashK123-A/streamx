import 'package:get/get.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/storage/hive_storage.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../routes/app_routes.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository;
  ProfileController({required AuthRepository authRepository}) : _authRepository = authRepository;

  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxString userAvatar = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxBool autoPlayEnabled = true.obs;
  final RxString selectedQuality = 'Auto'.obs;
  final RxString selectedLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadSettings();
    AnalyticsService.instance.logScreenView('profile');
  }

  Future<void> _loadUserData() async {
    final email = await SecureStorage.getUserEmail();
    final userId = await SecureStorage.getUserId();
    if (email != null) {
      userEmail.value = email;
      userName.value = email.split('@').first.split('.').map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1)).join(' ');
      userAvatar.value = 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName.value)}&background=E50914&color=fff&size=128';
    }
  }

  void _loadSettings() {
    notificationsEnabled.value = HiveStorage.getSetting('notifications_enabled', defaultValue: true);
    autoPlayEnabled.value = HiveStorage.getSetting('autoplay_enabled', defaultValue: true);
    selectedQuality.value = HiveStorage.getSetting('video_quality', defaultValue: 'Auto');
    selectedLanguage.value = HiveStorage.getSetting('language', defaultValue: 'English');
  }

  void navigateToWatchHistory() => Get.toNamed(AppRoutes.watchHistory);
  void navigateToSettings() => Get.toNamed(AppRoutes.settings);

  Future<void> logout() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout', style: TextStyle(color: Color(0xFFE50914))),
          ),
        ],
      ),
    );
    if (confirm == true) {
      isLoading.value = true;
      await _authRepository.logout();
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    HiveStorage.saveSetting('notifications_enabled', value);
  }

  void toggleAutoPlay(bool value) {
    autoPlayEnabled.value = value;
    HiveStorage.saveSetting('autoplay_enabled', value);
  }

  void setVideoQuality(String quality) {
    selectedQuality.value = quality;
    HiveStorage.saveSetting('video_quality', quality);
  }
}
