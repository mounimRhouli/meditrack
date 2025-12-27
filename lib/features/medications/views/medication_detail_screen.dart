// lib/features/medications/views/medication_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_dimensions.dart';
import 'package:meditrack/shared/extensions/date_extensions.dart';
import 'package:meditrack/shared/widgets/custom_app_bar.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';
import 'package:meditrack/features/medications/models/medication.dart';

class MedicationDetailScreen extends StatelessWidget {
  final Medication medication;

  const MedicationDetailScreen({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: medication.name),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Dosage', '${medication.dosageString} • ${medication.formString}'),
            _buildDetailRow('Début', medication.startDate.toFormattedDateString()),
            if (medication.endDate != null)
              _buildDetailRow('Fin', medication.endDate!.toFormattedDateString()),
            const SizedBox(height: AppDimensions.paddingLarge),
            const Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppDimensions.paddingSmall),
            Text(medication.instructions),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Text(' : '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}