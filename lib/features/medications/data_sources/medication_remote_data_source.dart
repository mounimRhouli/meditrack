// lib/features/medications/data_sources/medication_local_data_source.dart

import 'package:meditrack/features/medications/models/medication.dart';

/// Définit les opérations pour la base de données locale (SQLite).
/// L'implémentation concrète sera gérée par le Développeur B.
abstract class MedicationLocalDataSource {
  /// Sauvegarde un médicament dans la base de données locale.
  Future<void> cacheMedication(Medication medication);

  /// Récupère tous les médicaments de la base de données locale.
  Future<List<Medication>> getCachedMedications();

  /// Supprime un médicament de la base de données locale par son ID.
  Future<void> deleteCachedMedication(String id);
}