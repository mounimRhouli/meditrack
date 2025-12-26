// lib/features/home/models/dashboard_data.dart

import 'package:meditrack/features/medications/models/medication.dart';

class DashboardData {
  final Medication? nextMedication;
  final int totalMedications;
  final int activeReminders;
  final double monthlyCompliance; // e.g., 0.95 for 95%
  final String nextMedicationTime;

  DashboardData({
    required this.nextMedication,
    required this.totalMedications,
    required this.activeReminders,
    required this.monthlyCompliance,
    required this.nextMedicationTime,
  });
}