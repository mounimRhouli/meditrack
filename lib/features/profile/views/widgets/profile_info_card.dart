import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/constants/app_dimensions.dart';

class ProfileInfoCard extends StatelessWidget {
  final String? bloodType;
  final double? height;
  final double? weight;

  const ProfileInfoCard({Key? key, this.bloodType, this.height, this.weight})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              Icons.bloodtype,
              AppStrings.bloodType,
              bloodType ?? "-",
            ),
            _buildDivider(),
            _buildStatItem(
              context,
              Icons.height,
              AppStrings.height,
              "${height?.toStringAsFixed(0) ?? '-'}",
            ),
            _buildDivider(),
            _buildStatItem(
              context,
              Icons.monitor_weight,
              AppStrings.weight,
              "${weight?.toStringAsFixed(1) ?? '-'}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: AppColors.border);
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: AppDimensions.iconLarge,
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Text(label, style: AppTextStyles.bodySm),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.h3),
      ],
    );
  }
}
