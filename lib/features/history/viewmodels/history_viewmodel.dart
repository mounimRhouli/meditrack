import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/history_repository.dart';
import '../models/intake_status.dart'; // Required for adherence math
import 'history_stats_viewmodel.dart'; // Your state file

class HistoryViewModel extends StateNotifier<HistoryState> {
  final HistoryRepository _repo;

  HistoryViewModel(this._repo) : super(HistoryState());

  Future<void> loadHistoryAndStats(DateTime start, DateTime end) async {
    state = state.copyWith(isLoading: true);
    try {
      final items = await _repo.getHistoryForDateRange(start, end);
      
      // Calculate Adherence Math
      double rate = 0.0;
      if (items.isNotEmpty) {
        final taken = items.where((h) => h.intakeStatus == IntakeStatus.taken).length;
        rate = (taken / items.length) * 100;
      }

      state = state.copyWith(
        isLoading: false, 
        historyItems: items,
        adherenceRate: rate,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}