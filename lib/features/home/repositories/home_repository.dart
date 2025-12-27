// lib/features/home/repositories/home_repository.dart
import 'package:meditrack/core/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/features/history/data_sources/history_local_data_source.dart';
import 'package:meditrack/features/medications/data_sources/medication_local_data_source.dart';
import 'package:meditrack/features/medications/models/medication.dart';
import 'package:meditrack/features/reminders/data_sources/reminder_local_data_source.dart';
import 'package:sqflite/sqflite.dart';

// =============================================================================
// IMPORTS DES MODÈLES ET SOURCES DE DONNÉES
// =============================================================================
import '../../../core/database/database_helper.dart';
import '../../../shared/models/sync_status.dart';
import '../models/dashboard_data.dart';

// Les modèles qui n'ont pas été fournis mais sont nécessaires
// (Ils seront probablement dans leurs propres fichiers dans le projet final)
enum ReminderStatus { active, paused, completed }
enum IntakeStatus { taken, missed, late }

// =============================================================================
// IMPLÉMENTATIONS CONCRÈTES DES REPOSITORIES
// =============================================================================

class MedicationRepository {
  final MedicationLocalDataSource _localDataSource;

  MedicationRepository(this._localDataSource);

  Future<List<Medication>> getAllMedications() async {
    return await _localDataSource.fetchAll();
  }
}

class ReminderRepository {
  final ReminderLocalDataSource _localDataSource;

  ReminderRepository(this._localDataSource);

  Future<int> getActiveRemindersCount() async {
    final allReminders = await _localDataSource.fetchReminders();
    // Filtre pour ne compter que les rappels actifs
    return allReminders.where((reminder) => reminder.status == ReminderStatus.active).length;
  }
}

class HistoryRepository {
  final HistoryLocalDataSource _localDataSource;

  HistoryRepository(this._localDataSource);

  Future<double> getMonthlyCompliance() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    // Convertit en timestamps pour la requête
    final startTimestamp = startOfMonth.millisecondsSinceEpoch;
    final endTimestamp = endOfMonth.millisecondsSinceEpoch;

    final historyEntries = await _localDataSource.getHistoryByRange(startTimestamp, endTimestamp);

    if (historyEntries.isEmpty) {
      return 0.0; // Pas d'historique, pas de conformité
    }

    final takenCount = historyEntries.where((entry) => entry.intakeStatus == IntakeStatus.taken).length;
    final totalCount = historyEntries.length;

    return totalCount > 0 ? takenCount / totalCount : 0.0;
  }
}

// =============================================================================
// IMPLÉMENTATION CONCRÈTE DE HOME REPOSITORY
// =============================================================================

class HomeRepository {
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
      // Utilise Future.wait pour exécuter les appels en parallèle
      final results = await Future.wait([
        _medicationRepo.getAllMedications(),
        _reminderRepo.getActiveRemindersCount(),
        _historyRepo.getMonthlyCompliance(),
      ]);

      final medications = results[0] as List<Medication>;
      final reminderCount = results[1] as int;
      final compliance = results[2] as double;

      // Logique pour trouver le "prochain médicament" (simple pour l'exemple)
      // Une vraie logique analyserait les heures de prise des rappels du jour.
      final nextMed = medications.isNotEmpty ? medications.first : null;
      final nextTime = '08:00'; // Heure simulée

      return DashboardData(
        nextMedication: nextMed,
        totalMedications: medications.length,
        activeReminders: reminderCount,
        monthlyCompliance: compliance,
        nextMedicationTime: nextTime,
      );
    } catch (e) {
      debugPrint('Erreur lors de la récupération des données du tableau de bord: $e');
      // En cas d'erreur, on relance pour que l'UI puisse l'afficher
      rethrow;
    }
  }
}


// =============================================================================
// FONCTION D'USINE POUR CRÉER L'INSTANCE COMPLÈTE
// =============================================================================
// C'est une bonne pratique pour centraliser la création des dépendances.

Future<HomeRepository> createHomeRepository() async {
  // 1. Initialiser la connexion à la base de données
  final dbHelper = DatabaseHelper();
  await dbHelper.database; // S'assure que la base est initialisée

  // 2. Créer les instances des sources de données locales
  final medicationLocalDS = MedicationLocalDataSource(dbHelper);
  final reminderLocalDS = ReminderLocalDataSource(dbHelper);
  final historyLocalDS = HistoryLocalDataSource(dbHelper);

  // 3. Créer les instances des repositories en injectant les sources de données
  final medicationRepo = MedicationRepository(medicationLocalDS);
  final reminderRepo = ReminderRepository(reminderLocalDS);
  final historyRepo = HistoryRepository(historyLocalDS);

  // 4. Créer et retourner l'instance de HomeRepository
  return HomeRepository(
    medicationRepo: medicationRepo,
    reminderRepo: reminderRepo,
    historyRepo: historyRepo,
  );
}