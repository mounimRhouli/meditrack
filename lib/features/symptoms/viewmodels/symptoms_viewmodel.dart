import 'package:flutter/foundation.dart';
import '../models/symptom_entry.dart';
import '../repositories/symptom_repository.dart';

enum SymptomStatus { initial, loading, loaded, error }

class SymptomsViewModel extends ChangeNotifier {
  final SymptomRepository _repository;

  SymptomsViewModel({required SymptomRepository repository})
    : _repository = repository;

  // ---------------------------------------------------------------------------
  // STATE
  // ---------------------------------------------------------------------------
  List<SymptomEntry> _symptoms = [];
  SymptomStatus _status = SymptomStatus.initial;
  String? _errorMessage;

  List<SymptomEntry> get symptoms => _symptoms;
  SymptomStatus get status => _status;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == SymptomStatus.loading;

  // ---------------------------------------------------------------------------
  // ACTIONS: Load History
  // ---------------------------------------------------------------------------
  Future<void> loadSymptoms(String userId) async {
    _status = SymptomStatus.loading;
    notifyListeners();

    final result = await _repository.getRecentSymptoms(userId);

    if (result.isSuccess) {
      _symptoms = result.data ?? [];
      _status = SymptomStatus.loaded;
    } else {
      _status = SymptomStatus.error;
      _errorMessage = result.error?.message ?? "Failed to load history";
    }
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // ACTIONS: Add Entry
  // ---------------------------------------------------------------------------
  Future<bool> addSymptom(SymptomEntry entry) async {
    // Note: We don't set global 'loading' state here because we might
    // want to show a small spinner on the button, not block the whole screen.

    // 1. Optimistic Update (Optional, but makes UI snappy)
    _symptoms.insert(0, entry);
    notifyListeners();

    // 2. Persist
    final result = await _repository.addSymptom(entry);

    if (!result.isSuccess) {
      // Revert optimism if critical failure (or just show error toast)
      _symptoms.remove(entry);
      _errorMessage = "Failed to save entry: ${result.error?.message}";
      notifyListeners();
      return false;
    }

    return true;
  }
}
