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

  /// Loads all medications from the repository
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

  /// NEW: Searches medications by name to fix the error in medications_list_screen.dart
  Future<void> searchMedications(String query) async {
    if (query.isEmpty) {
      await loadMedications();
      return;
    }

    _setLoading(true);
    try {
      // Calls the search method in the repository
      _medications = await repository.search(query);
      _error = null;
    } catch (e) {
      _error = 'Erreur lors de la recherche.';
      debugPrint('Erreur lors de la recherche: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Deletes a medication with optimistic UI update
  Future<void> deleteMedication(String id) async {
    final originalMedications = _medications.toList();

    // Optimistically remove from list
    _medications.removeWhere((med) => med.id == id);
    notifyListeners();

    try {
      await repository.deleteMedication(id);
    } catch (e) {
      _error = 'Échec de la suppression du médicament.';
      _medications = originalMedications; // Revert on failure
      notifyListeners();
      debugPrint('Erreur lors de la suppression: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
