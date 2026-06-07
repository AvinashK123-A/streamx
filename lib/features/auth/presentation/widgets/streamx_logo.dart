import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class StreamXLogo extends StatelessWidget {
  final double size;
  const StreamXLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(size * 0.2),
          boxShadow: [BoxShadow(color: AppConstants.primaryColor.withOpacity(0.3), blurRadius: size * 0.4, spreadRadius: size * 0.1)],
        ),
        child: Center(
          child: Text('SX', style: TextStyle(color: Colors.white, fontSize: size * 0.38, fontWeight: FontWeight.w900, letterSpacing: 1)),
        ),
      ),
    );
  }
}
