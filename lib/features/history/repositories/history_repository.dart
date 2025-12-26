import '../data_sources/history_local_data_source.dart';
import '../data_sources/history_remote_data_source.dart';
import '../models/medication_history.dart';

class HistoryRepository {
  final HistoryLocalDataSource _local;
  final HistoryRemoteDataSource _remote;

  HistoryRepository(this._local, this._remote);

  Future<void> logIntake(MedicationHistory history, String userId) async {
    await _local.logIntake(history); // Local first for offline capability
    try {
      await _remote.syncHistoryToCloud(history, userId);
    } catch (e) {
      // Sync failure handled by Developer B's Phase 3 Sync Engine
    }
  }

  Future<List<MedicationHistory>> getHistoryForDateRange(DateTime start, DateTime end) {
    return _local.getHistoryByRange(
      start.millisecondsSinceEpoch, 
      end.millisecondsSinceEpoch,
    );
  }
}