import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../controllers/profile_controller.dart';

class SettingsView extends GetView<ProfileController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        title: const Text('Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Get.back()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _buildSectionTitle('Playback'),
          _buildCard([
            Obx(() => _SettingsTile(
              title: 'Auto-Play Next Episode',
              subtitle: 'Automatically play next video',
              trailing: Switch(
                value: controller.autoPlayEnabled.value,
                onChanged: controller.toggleAutoPlay,
                activeColor: AppConstants.primaryColor,
              ),
            )),
            _buildDivider(),
            Obx(() => _SettingsTile(
              title: 'Video Quality',
              subtitle: controller.selectedQuality.value,
              onTap: () => _showQualityPicker(context),
              showArrow: true,
            )),
            _buildDivider(),
            const _SettingsTile(
              title: 'Download Quality',
              subtitle: 'Wi-Fi only',
              showArrow: true,
            ),
          ]),

          const SizedBox(height: 24),
          _buildSectionTitle('Notifications'),
          _buildCard([
            Obx(() => _SettingsTile(
              title: 'Push Notifications',
              subtitle: 'Get notified about new content',
              trailing: Switch(
                value: controller.notificationsEnabled.value,
                onChanged: controller.toggleNotifications,
                activeColor: AppConstants.primaryColor,
              ),
            )),
          ]),

          const SizedBox(height: 24),
          _buildSectionTitle('Storage'),
          _buildCard([
            const _SettingsTile(title: 'Clear Cache', subtitle: 'Free up storage space', showArrow: true),
            _buildDivider(),
            const _SettingsTile(title: 'Download Location', subtitle: 'Internal Storage', showArrow: true),
          ]),

          const SizedBox(height: 24),
          _buildSectionTitle('About'),
          _buildCard([
            const _SettingsTile(title: 'App Version', subtitle: 'StreamX v1.0.0'),
            _buildDivider(),
            const _SettingsTile(title: 'Build Number', subtitle: '1'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(color: AppConstants.surfaceColor, borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() => const Divider(color: Color(0xFF333333), height: 1, indent: 16);

  void _showQualityPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Color(0xFF1F1F1F), borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Video Quality', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...AppConstants.videoQualities.map((q) => ListTile(
              title: Text(q, style: const TextStyle(color: Colors.white)),
              trailing: Obx(() => controller.selectedQuality.value == q
                  ? const Icon(Icons.check, color: AppConstants.primaryColor) : null),
              onTap: () {
                controller.setVideoQuality(q);
                Get.back();
              },
            )),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showArrow;
  const _SettingsTile({required this.title, this.subtitle, this.trailing, this.onTap, this.showArrow = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(color: Colors.grey, fontSize: 12)) : null,
      trailing: trailing ?? (showArrow ? const Icon(Icons.chevron_right, color: Colors.grey, size: 20) : null),
      onTap: onTap,
    );
  }
}
