import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/text_styles.dart';

class SyncSettingsCard extends StatelessWidget {
  final bool isSynced;
  final VoidCallback onSyncPressed;

  const SyncSettingsCard({
    Key? key,
    required this.isSynced,
    required this.onSyncPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSynced
          ? AppColors.success.withOpacity(0.1)
          : AppColors.warning.withOpacity(0.1),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.paddingMedium),
        leading: Icon(
          isSynced ? Icons.cloud_done : Icons.cloud_off,
          color: isSynced ? AppColors.success : AppColors.warning,
          size: AppDimensions.iconLarge,
        ),
        title: Text(
          isSynced ? "Profil Synchronisé" : "Modifications non synchronisées",
          style: AppTextStyles.h3.copyWith(
            color: isSynced ? AppColors.success : AppColors.warning,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            isSynced
                ? "Vos données médicales sont sauvegardées."
                : "Appuyez pour synchroniser avec le cloud.",
            style: AppTextStyles.bodySm,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.refresh),
          color: AppColors.textPrimary,
          onPressed: onSyncPressed,
        ),
      ),
    );
  }
}
