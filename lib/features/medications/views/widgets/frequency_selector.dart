// lib/features/medications/widgets/frequency_selector.dart

import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_dimensions.dart';
import 'package:meditrack/features/medications/views/widgets/time_picker_widget.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';
import 'package:meditrack/shared/widgets/custom_button.dart';
import './time_picker_widget.dart';
import 'package:meditrack/features/medications/models/medication_frequency.dart';

class FrequencySelector extends StatelessWidget {
  final MedicationFrequency frequency;
  final ValueChanged<MedicationFrequency> onFrequencyChanged;

  const FrequencySelector({
    Key? key,
    required this.frequency,
    required this.onFrequencyChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fréquence', style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: AppDimensions.paddingSmall),
        // TODO: Implémenter la logique pour sélectionner les jours de la semaine et le nombre de fois par jour
        // Pour l'instant, un simple exemple avec un sélecteur d'heure
        Text('Heures de prise:'),
        const SizedBox(height: AppDimensions.paddingSmall),
        ...frequency.times.map((time) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TimePickerWidget(
            selectedTime: time,
            onTimeChanged: (newTime) {
              // Logique pour mettre à jour l'heure dans la liste
            },
          ),
        )).toList(),
        CustomButton(
          text: 'Ajouter une heure de prise',
          isSecondary: true,
          onPressed: () {
            // Logique pour ajouter une nouvelle heure à la liste
          },
        )
      ],
    );
  }
}