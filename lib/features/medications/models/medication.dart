// lib/features/medications/models/medication.dart

import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'medication_form.dart';


class Medication {
  final String id;
  final String name;
  final double dosage; // ex: 500
  final String dosageUnit; // ex: "mg"
  final MedicationForm form;
  final String instructions;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? barcode; // Pour le scanner de code-barres

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.dosageUnit,
    required this.form,
    required this.instructions,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.barcode,
  });

  // Helper pour obtenir une chaîne lisible pour la forme
  String get formString {
    switch (form) {
      case MedicationForm.pill:
        return 'Comprimé';
      case MedicationForm.syrup:
        return 'Sirop';
      case MedicationForm.injection:
        return 'Injection';
      case MedicationForm.inhaler:
        return 'Inhalateur';
    }
  }

  // Helper pour obtenir une chaîne lisible pour le dosage
  String get dosageString => '${dosage.toInt()}$dosageUnit';
}