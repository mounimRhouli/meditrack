// lib/features/medications/data_sources/medication_remote_data_source.dart

import 'package:meditrack/features/medications/models/medication.dart';

/// Définit les opérations pour la source de données distante (Firebase).
/// L'implémentation concrète sera gérée par le Développeur B.
abstract class MedicationRemoteDataSource {
  /// Synchronise un médicament vers le cloud (Firebase).
  Future<void> syncMedicationToCloud(Medication medication);

  /// Récupère les médicaments depuis le cloud.
  Future<List<Medication>> getMedicationsFromCloud();
}