// lib/features/medications/models/medication_frequency.dart

import 'package:flutter/material.dart';
import 'package:meditrack/features/medications/models/medication.dart';

class MedicationFrequency {
  final int timesPerDay;
  final List<TimeOfDay> times; // ex: [TimeOfDay(hour: 8, minute: 0)]
  final List<int> daysOfWeek; // ex: [1, 2, 3, 4, 5] pour les jours de semaine

  MedicationFrequency({
    required this.timesPerDay,
    required this.times,
    required this.daysOfWeek,
  });
}