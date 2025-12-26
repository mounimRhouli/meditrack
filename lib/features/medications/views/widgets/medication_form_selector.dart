// lib/features/medications/widgets/medication_form_selector.dart

import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_dimensions.dart';
import 'package:meditrack/features/medications/models/medication.dart';
import 'package:meditrack/features/medications/models/medication_form.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';

class MedicationFormSelector extends StatelessWidget {
  final MedicationForm selectedForm;
  final ValueChanged<MedicationForm> onFormChanged;

  const MedicationFormSelector({
    Key? key,
    required this.selectedForm,
    required this.onFormChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Forme', style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: AppDimensions.paddingSmall),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: MedicationForm.values.map((form) {
            final isSelected = selectedForm == form;
            return ChoiceChip(
              label: Text(form.name),
              selected: isSelected,
              onSelected: (_) => onFormChanged(form),
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : context.textTheme.bodyMedium?.color,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}