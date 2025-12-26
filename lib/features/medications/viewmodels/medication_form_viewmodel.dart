// lib/features/medications/viewmodels/medication_form_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:meditrack/features/medications/models/medication.dart';
import 'package:meditrack/features/medications/models/medication_form.dart';
import 'package:meditrack/features/medications/repositories/medication_repository.dart';

class MedicationFormViewModel extends ChangeNotifier {
  final MedicationRepository repository;

  MedicationFormViewModel({required this.repository});

  String _name = '';
  double _dosage = 0;
  String _dosageUnit = 'mg';
  MedicationForm _form = MedicationForm.pill;
  String _instructions = '';
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  String _barcode = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get name => _name;
  double get dosage => _dosage;
  String get dosageUnit => _dosageUnit;
  MedicationForm get form => _form;
  String get instructions => _instructions;
  DateTime get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get barcode => _barcode;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Setters
  void updateName(String value) { _name = value; notifyListeners(); }
  void updateDosage(double value) { _dosage = value; notifyListeners(); }
  void updateDosageUnit(String value) { _dosageUnit = value; notifyListeners(); }
  void updateForm(MedicationForm value) { _form = value; notifyListeners(); }
  void updateInstructions(String value) { _instructions = value; notifyListeners(); }
  void updateStartDate(DateTime value) { _startDate = value; notifyListeners(); }
  void updateEndDate(DateTime? value) { _endDate = value; notifyListeners(); }
  void updateBarcode(String value) { _barcode = value; notifyListeners(); }

  Future<bool> saveMedication() async {
    if (!_validateForm()) return false;

    _setLoading(true);
    try {
      final medication = Medication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name,
        dosage: _dosage,
        dosageUnit: _dosageUnit,
        form: _form,
        instructions: _instructions,
        startDate: _startDate,
        endDate: _endDate,
        barcode: _barcode.isNotEmpty ? _barcode : null,
      );
      await repository.addMedication(medication);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Échec de l\'enregistrement du médicament.';
      debugPrint('Erreur lors de l\'enregistrement: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  bool _validateForm() {
    if (_name.trim().isEmpty) { _errorMessage = 'Le nom du médicament ne peut pas être vide.'; notifyListeners(); return false; }
    if (_dosage <= 0) { _errorMessage = 'Le dosage doit être supérieur à 0.'; notifyListeners(); return false; }
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}