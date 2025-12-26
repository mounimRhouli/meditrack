// lib/features/home/widgets/quick_stats_card.dart

import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_dimensions.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';

class QuickStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const QuickStatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppDimensions.iconLarge, color: iconColor ?? AppColors.primary),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(
              value,
              style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}