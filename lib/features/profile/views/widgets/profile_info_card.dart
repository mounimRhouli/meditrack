import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';

class ProfileInfoCard extends StatelessWidget {
  final String? bloodType;
  final double? height;
  final double? weight;

  const ProfileInfoCard({Key? key, this.bloodType, this.height, this.weight})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Rely on AppTheme's CardTheme
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStat(context, Icons.bloodtype, "Sang", bloodType ?? "-"),
            Container(height: 30, width: 1, color: AppColors.border),
            _buildStat(
              context,
              Icons.height,
              AppStrings.height,
              "${height?.toInt() ?? '-'}",
            ),
            Container(height: 30, width: 1, color: AppColors.border),
            _buildStat(
              context,
              Icons.monitor_weight,
              AppStrings.weight,
              "${weight?.toInt() ?? '-'}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 28),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodySmall),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
