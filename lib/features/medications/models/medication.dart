import 'package:meditrack/features/medications/models/medication_form.dart';

class Medication {
  final String id;
  final String name;
  final double dosage; 
  final String dosageUnit; 
  final MedicationForm form;
  final String instructions;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final String? barcode;

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

  // --- ADD THESE GETTERS TO FIX THE ERROR ---

  /// Returns a formatted dosage string (e.g., "500mg")
  String get dosageString => '${dosage.toInt()}$dosageUnit';

  /// Returns a localized string for the medication form
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
      default:
        return 'Inconnu';
    }
  }

  // --- DATABASE MAPPING ---

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'dosage_unit': dosageUnit,
      'form': form.name, 
      'instructions': instructions,
      'start_date': startDate.millisecondsSinceEpoch,
      'end_date': endDate?.millisecondsSinceEpoch,
      'is_active': isActive ? 1 : 0,
      'barcode': barcode,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] as String,
      name: map['name'] as String,
      dosage: (map['dosage'] as num).toDouble(),
      dosageUnit: map['dosage_unit'] as String,
      form: MedicationForm.values.byName(map['form'] as String),
      instructions: map['instructions'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['start_date'] as int),
      endDate: map['end_date'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['end_date'] as int) 
          : null,
      isActive: (map['is_active'] as int) == 1,
      barcode: map['barcode'] as String?,
    );
  }
}