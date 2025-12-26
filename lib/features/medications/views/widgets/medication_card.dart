// lib/features/medications/widgets/medication_card.dart

import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_dimensions.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/features/medications/models/medication.dart';
import 'package:meditrack/features/medications/models/medication_form.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback onTap;

  const MedicationCard({
    Key? key,
    required this.medication,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMedium)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppDimensions.paddingMedium),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(
            _getIconForForm(medication.form),
            color: AppColors.textInverse,
          ),
        ),
        title: Text(
          medication.name,
          style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${medication.dosageString} • ${medication.formString}'),
        trailing: const Icon(Icons.chevron_right, color: AppColors.iconColor),
        onTap: onTap,
      ),
    );
  }

  IconData _getIconForForm(MedicationForm form) {
    switch (form) {
      case MedicationForm.pill:
        return Icons.medication;
      case MedicationForm.syrup:
        return Icons.local_drink;
      case MedicationForm.injection:
        return Icons.vaccines;
      case MedicationForm.inhaler:
        return Icons.air;
    }
  }
}