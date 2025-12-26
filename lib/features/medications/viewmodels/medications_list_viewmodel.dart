// lib/features/medications/viewmodels/medications_list_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:meditrack/features/medications/models/medication.dart';
import 'package:meditrack/features/medications/repositories/medication_repository.dart';

class MedicationsListViewModel extends ChangeNotifier {
  final MedicationRepository repository;

  MedicationsListViewModel({required this.repository});

  List<Medication> _medications = [];
  bool _isLoading = false;
  String? _error;

  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMedications() async {
    _setLoading(true);
    try {
      _medications = await repository.getAllMedications();
      _error = null;
    } catch (e) {
      _error = 'Échec du chargement des médicaments. Veuillez réessayer.';
      debugPrint('Erreur lors du chargement: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteMedication(String id) async {
    // --- FIX: Use .toList() for a safe, typed copy ---
    final originalMedications = _medications.toList();
    // ------------------------------------------------

    // Optimistically remove from list
    _medications.removeWhere((med) => med.id == id);
    notifyListeners();

    try {
      await repository.deleteMedication(id);
    } catch (e) {
      _error = 'Échec de la suppression du médicament.';
      // This line now works perfectly because originalMedications is correctly typed
      _medications = originalMedications;
      notifyListeners();
      debugPrint('Erreur lors de la suppression: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}