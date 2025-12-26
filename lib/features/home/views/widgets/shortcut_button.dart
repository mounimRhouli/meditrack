// lib/features/home/widgets/shortcut_button.dart

import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_dimensions.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';

class ShortcutButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ShortcutButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: AppDimensions.iconLarge),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}