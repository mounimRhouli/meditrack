import 'package:flutter/foundation.dart';
import '../repositories/symptom_repository.dart';

enum ChartStatus { initial, loading, loaded, error }

class SymptomChartsViewModel extends ChangeNotifier {
  final SymptomRepository _repository;

  SymptomChartsViewModel({required SymptomRepository repository})
    : _repository = repository;

  // ---------------------------------------------------------------------------
  // STATE
  // ---------------------------------------------------------------------------
  ChartStatus _status = ChartStatus.initial;
  String? _errorMessage;

  // Weekly Averages
  int _avgSystolic = 0;
  int _avgDiastolic = 0;
  int _totalReadings = 0;

  ChartStatus get status => _status;
  int get avgSystolic => _avgSystolic;
  int get avgDiastolic => _avgDiastolic;
  int get totalReadings => _totalReadings;

  bool get isLoading => _status == ChartStatus.loading;

  // ---------------------------------------------------------------------------
  // ACTIONS: Load Weekly Stats
  // ---------------------------------------------------------------------------
  Future<void> loadWeeklyStats(String userId) async {
    _status = ChartStatus.loading;
    notifyListeners();

    final now = DateTime.now();
    // Start of 7 days ago (set time to midnight for clean boundaries)
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final start = DateTime(
      sevenDaysAgo.year,
      sevenDaysAgo.month,
      sevenDaysAgo.day,
    );

    final result = await _repository.getAverageBloodPressure(
      userId,
      start,
      now,
    );

    if (result.isSuccess) {
      final data = result.data!;
      _avgSystolic = data['systolic'] ?? 0;
      _avgDiastolic = data['diastolic'] ?? 0;
      _totalReadings = data['count'] ?? 0;
      _status = ChartStatus.loaded;
    } else {
      _status = ChartStatus.error;
      _errorMessage = result.error?.message ?? "Failed to calculate stats";
    }
    notifyListeners();
  }
}
