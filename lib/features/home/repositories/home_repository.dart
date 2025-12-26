// lib/features/home/repositories/home_repository.dart

import 'package:flutter/material.dart';
import 'package:meditrack/features/home/models/dashboard_data.dart';
import 'package:meditrack/features/medications/models/medication.dart';
import 'package:meditrack/features/medications/models/medication_form.dart';

// =============================================================================
// DÉPENDANCES (IMPLÉMENTATIONS SIMPLIFIÉES POUR L'EXEMPLE)
// =============================================================================
// Dans un vrai projet, ces classes seraient dans leurs propres fichiers et
// injectées via le constructeur de HomeRepository.

// Implémentation simple pour MedicationRepository
class MedicationRepository {
  // Cette méthode serait connectée à la vraie source de données (SQLite/Firebase)
  Future<List<Medication>> getAllMedications() async {
    // Simule un délai réseau
    await Future.delayed(const Duration(seconds: 1));
    // Retourne une liste de médicaments de test
    return [
      Medication(id: '1', name: 'Doliprane', dosage: 500, dosageUnit: 'mg', form: MedicationForm.pill, instructions: '2 comprimés en cas de douleur.', startDate: DateTime.now()),
      Medication(id: '2', name: 'Humex', dosage: 200, dosageUnit: 'ml', form: MedicationForm.syrup, instructions: '10 ml toutes les 8 heures.', startDate: DateTime.now()),
      Medication(id: '3', name: 'Ventoline', dosage: 100, dosageUnit: 'µg', form: MedicationForm.inhaler, instructions: '1-2 inhalations en cas de crise.', startDate: DateTime.now()),
    ];
  }
}

// Implémentation simple pour ReminderRepository (basée sur votre code)
class ReminderRepository {
  // Dans la vraie version, ceci dépendrait de ReminderLocalDataSource
  Future<int> getActiveRemindersCount() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simule le comptage de rappels actifs
    return 3;
  }
}

// Implémentation simple pour HistoryRepository (basée sur votre code)
class HistoryRepository {
  // Dans la vraie version, ceci dépendrait de HistoryLocalDataSource
  Future<double> getMonthlyCompliance() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simule un taux de conformité de 95%
    return 0.95;
  }
}


// =============================================================================
// IMPLÉMENTATION CONCRÈTE DE HOME REPOSITORY
// =============================================================================

class HomeRepository {
  // Dépendances aux autres repositories
  final MedicationRepository _medicationRepo;
  final ReminderRepository _reminderRepo;
  final HistoryRepository _historyRepo;

  // Constructeur pour injecter les dépendances
  HomeRepository({
    required MedicationRepository medicationRepo,
    required ReminderRepository reminderRepo,
    required HistoryRepository historyRepo,
  })  : _medicationRepo = medicationRepo,
        _reminderRepo = reminderRepo,
        _historyRepo = historyRepo;

  /// Agrège les données de plusieurs sources pour construire le tableau de bord.
  Future<DashboardData> getDashboardData() async {
    try {
      // Utilise Future.wait pour exécuter les appels en parallèle et gagner en performance
      final results = await Future.wait([
        _medicationRepo.getAllMedications(),
        _reminderRepo.getActiveRemindersCount(),
        _historyRepo.getMonthlyCompliance(),
      ]);

      final medications = results[0] as List<Medication>;
      final reminderCount = results[1] as int;
      final compliance = results[2] as double;

      // Logique simple pour déterminer le "prochain médicament"
      // Ici, on prend juste le premier de la liste pour l'exemple.
      // Une vraie logique vérifierait les heures de prise.
      final nextMed = medications.isNotEmpty ? medications.first : null;

      return DashboardData(
        nextMedication: nextMed,
        totalMedications: medications.length,
        activeReminders: reminderCount,
        monthlyCompliance: compliance,
        nextMedicationTime: '08:00', // Heure simulée
      );
    } catch (e) {
      debugPrint('Erreur lors de la récupération des données du tableau de bord: $e');
      // En cas d'erreur, on renvoie des données par défaut pour éviter de casser l'UI
      throw Exception('Impossible de charger les données du tableau de bord.');
    }
  }
}