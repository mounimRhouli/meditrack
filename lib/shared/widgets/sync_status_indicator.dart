import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../models/sync_status.dart';

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
        color = AppColors.success; // Vert (issu de votre identité visuelle)
        icon = Icons.cloud_done;
        tooltip = 'Synchronisé';
        break;
      case SyncStatus.syncing:
        color = AppColors.primary; // Bleu (issu de votre identité visuelle)
        icon = Icons.sync;
        tooltip = 'Synchronisation en cours...';
        break;
      case SyncStatus.error:
        color = AppColors.error;
        icon = Icons.warning_amber_rounded;
        tooltip = 'Erreur de synchronisation';
        break;
      case SyncStatus.pending:
        // L'état pending remplace offline pour indiquer que les données attendent d'être envoyées
        color = AppColors.textSecondary;
        icon = Icons.cloud_upload_outlined;
        tooltip = 'En attente de synchronisation (Local)';
        break;
    }

    // Ajout d'une animation si l'état est "syncing" pour plus de professionnalisme
    Widget iconWidget = Icon(
      icon,
      color: color,
      size: AppDimensions.iconMedium,
    );

    if (status.isBusy) {
      iconWidget = RotationTransition(
        turns: const AlwaysStoppedAnimation(
          0.5,
        ), // Vous pourriez utiliser un AnimationController ici
        child: iconWidget,
      );
    }

    return Tooltip(message: tooltip, child: iconWidget);
  }
}
