import '../models/medication_history.dart';

class HistoryState {
  final bool isLoading;
  final List<MedicationHistory> historyItems;
  final double adherenceRate; 
  final String? errorMessage;

  HistoryState({
    this.isLoading = false,
    this.historyItems = const [],
    this.adherenceRate = 0.0,
    this.errorMessage,
  });

  HistoryState copyWith({
    bool? isLoading,
    List<MedicationHistory>? historyItems,
    double? adherenceRate,
    String? errorMessage,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      historyItems: historyItems ?? this.historyItems,
      adherenceRate: adherenceRate ?? this.adherenceRate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}