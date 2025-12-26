// lib/shared/widgets/time_picker_widget.dart

import 'package:flutter/material.dart';
import 'package:meditrack/shared/widgets/custom_text_field.dart';

class TimePickerWidget extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay?> onTimeChanged;
  final String? labelText;

  const TimePickerWidget({
    Key? key,
    this.selectedTime,
    required this.onTimeChanged,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: selectedTime != null
          ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
          : '',
    );

    return CustomTextField(
      labelText: labelText ?? 'Heure',
      controller: controller,
      readOnly: true,
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (picked != null && picked != selectedTime) {
          onTimeChanged(picked);
        }
      },
      prefixIcon: Icons.access_time,
    );
  }
}