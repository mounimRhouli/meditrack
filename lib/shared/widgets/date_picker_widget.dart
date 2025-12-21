// lib/shared/widgets/date_picker_widget.dart

import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateChanged;
  final String? labelText;

  const DatePickerWidget({
    super.key,
    this.selectedDate,
    required this.onDateChanged,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: selectedDate != null
          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
          : '',
    );

    return CustomTextField(
      labelText: labelText,
      controller: controller,
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null && picked != selectedDate) {
          onDateChanged(picked);
        }
      },
      prefixIcon: Icons.calendar_today,
    );
  }
}