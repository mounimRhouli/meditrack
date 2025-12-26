// lib/features/home/widgets/emergency_fab.dart

import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';

class EmergencyFab extends StatelessWidget {
  final VoidCallback onPressed;

  const EmergencyFab({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.error,
      child: const Icon(Icons.emergency, color: AppColors.textInverse),
    );
  }
}