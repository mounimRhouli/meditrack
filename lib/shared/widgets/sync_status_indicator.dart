// lib/shared/widgets/sync_status_indicator.dart

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../models/sync_status.dart';

// You'll need to create this enum in your shared models folder


class SyncStatusIndicator extends StatelessWidget {
  final SyncStatus status;

  const SyncStatusIndicator({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late Color color;
    late IconData icon;
    String tooltip = '';

    switch (status) {
      case SyncStatus.synced:
        color = AppColors.success;
        icon = Icons.cloud_done;
        tooltip = 'Synchronisé';
        break;
      case SyncStatus.syncing:
        color = AppColors.primary;
        icon = Icons.sync;
        tooltip = 'Synchronisation...';
        break;
      case SyncStatus.error:
        color = AppColors.error;
        icon = Icons.cloud_off;
        tooltip = 'Erreur de synchronisation';
        break;
      case SyncStatus.offline:
        color = AppColors.textSecondary;
        icon = Icons.cloud_queue;
        tooltip = 'Hors ligne';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Icon(
        icon,
        color: color,
        size: AppDimensions.iconMedium,
      ),
    );
  }
}