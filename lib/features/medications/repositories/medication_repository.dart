// lib/features/medications/repositories/medication_repository.dart

import 'package:meditrack/features/medications/models/medication.dart';

// Classe abstraite définissant le contrat pour les opérations sur les médicaments.
// Le Développeur B créera l'implémentation concrète.
abstract class MedicationRepository {
  Future<void> addMedication(Medication medication);
  Future<void> updateMedication(Medication medication);
  Future<void> deleteMedication(String id);
  Future<List<Medication>> getAllMedications();
  Future<Medication?> getMedicationById(String id);
}