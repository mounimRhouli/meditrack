// lib/features/home/widgets/next_medication_card.dart

import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_dimensions.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/shared/widgets/custom_button.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';
import 'package:meditrack/features/medications/models/medication.dart';

class NextMedicationCard extends StatelessWidget {
  final Medication? medication;
  final String time;
  final VoidCallback onTaken;

  const NextMedicationCard({
    Key? key,
    required this.medication,
    required this.time,
    required this.onTaken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(AppDimensions.paddingMedium),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLarge)),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.nextDose, style: context.textTheme.bodyLarge),
            const SizedBox(height: AppDimensions.paddingSmall),
            if (medication != null) ...[
              Text(
                medication!.name,
                style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Text('${medication!.dosageString} • $time'),
              const SizedBox(height: AppDimensions.paddingMedium),
              CustomButton(
                text: AppStrings.reminderActionTaken,
                onPressed: onTaken,
              ),
            ] else ...[
              Text(
                'Aucun médicament à prendre prochainement.',
                style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}