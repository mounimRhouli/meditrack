import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

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
      // Using opacity for a subtle tint based on your palette
      color: isSynced
          ? AppColors.success.withOpacity(0.1)
          : AppColors.warning.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSynced
              ? AppColors.success.withOpacity(0.3)
              : AppColors.warning.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        leading: Icon(
          isSynced ? Icons.cloud_done : Icons.cloud_off,
          color: isSynced ? AppColors.success : AppColors.warning,
        ),
        title: Text(
          isSynced ? "Profile Synced" : "Unsynced Changes",
          style: TextStyle(
            color: isSynced ? AppColors.success : AppColors.warning,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          isSynced
              ? "Your medical data is backed up."
              : "Tap to force sync with cloud.",
          style: TextStyle(
            fontSize: 12,
            color: isSynced ? AppColors.success : AppColors.warning,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.refresh, color: AppColors.textPrimary),
          onPressed: onSyncPressed,
        ),
      ),
    );
  }
}
