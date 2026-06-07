import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class SocialLoginButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  const SocialLoginButton({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF333333), width: 1),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          color: AppConstants.surfaceColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Center(child: Text('G', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)))),
            const SizedBox(width: 12),
            Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey[300])),
          ],
        ),
      ),
    );
  }
}
