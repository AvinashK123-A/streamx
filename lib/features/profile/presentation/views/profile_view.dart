import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_constants.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Get.back()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A0A0A), AppConstants.backgroundColor],
                ),
              ),
              child: Column(
                children: [
                  Obx(() => CircleAvatar(
                    radius: 50,
                    backgroundColor: AppConstants.primaryColor,
                    backgroundImage: controller.userAvatar.value.isNotEmpty
                        ? NetworkImage(controller.userAvatar.value) : null,
                    child: controller.userAvatar.value.isEmpty
                        ? const Icon(Icons.person, color: Colors.white, size: 40) : null,
                  )),
                  const SizedBox(height: 16),
                  Obx(() => Text(
                    controller.userName.value.isEmpty ? 'StreamX User' : controller.userName.value,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                  )),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    controller.userEmail.value,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  )),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppConstants.primaryColor, width: 1),
                    ),
                    child: const Text('PREMIUM', style: TextStyle(color: AppConstants.primaryColor, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2)),
                  ),
                ],
              ),
            ),

            // Menu Items
            _buildSection('Account', [
              _MenuItem(icon: Icons.history, label: 'Watch History', onTap: controller.navigateToWatchHistory),
              _MenuItem(icon: Icons.download_outlined, label: 'Downloads', onTap: () => Get.snackbar('Coming Soon', 'Downloads coming soon', snackPosition: SnackPosition.BOTTOM)),
              _MenuItem(icon: Icons.favorite_outline, label: 'My List', onTap: () {}),
            ]),

            _buildSection('Settings', [
              _MenuItem(icon: Icons.settings_outlined, label: 'App Settings', onTap: controller.navigateToSettings),
              _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
              _MenuItem(icon: Icons.language, label: 'Language', subtitle: 'English', onTap: () {}),
            ]),

            _buildSection('Support', [
              _MenuItem(icon: Icons.help_outline, label: 'Help & Support', onTap: () {}),
              _MenuItem(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () {}),
              _MenuItem(icon: Icons.info_outline, label: 'About StreamX', subtitle: 'v1.0.0', onTap: () {}),
            ]),

            // Logout
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Obx(() => ElevatedButton.icon(
                onPressed: controller.isLoading.value ? null : controller.logout,
                icon: const Icon(Icons.logout),
                label: controller.isLoading.value
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Sign Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                  foregroundColor: AppConstants.primaryColor,
                  side: const BorderSide(color: AppConstants.primaryColor),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
                ),
              )),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: AppConstants.surfaceColor, borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
          child: Column(
            children: items.asMap().entries.map((e) {
              final idx = e.key;
              final item = e.value;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: Colors.grey[400], size: 20),
                    title: Text(item.label, style: const TextStyle(color: Colors.white, fontSize: 14)),
                    subtitle: item.subtitle != null ? Text(item.subtitle!, style: const TextStyle(color: Colors.grey, fontSize: 12)) : null,
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                    onTap: item.onTap,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  ),
                  if (idx < items.length - 1)
                    const Divider(color: Color(0xFF333333), height: 1, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, this.subtitle, required this.onTap});
}
