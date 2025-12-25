import '../../../core/errors/failures.dart';
import '../models/symptom_entry.dart';
import '../data_sources/symptom_remote_data_source.dart';

// Architect's Note: Reusing the Result pattern
class Result<T> {
  final T? data;
  final Failure? error;
  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;
  bool get isSuccess => error == null;
}

class SymptomRepository {
  final SymptomRemoteDataSource _remoteDataSource;
  final SymptomLocalDataSource _localDataSource; // Dev B's responsibility

  SymptomRepository({
    required SymptomRemoteDataSource remoteDataSource,
    required SymptomLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  // ---------------------------------------------------------------------------
  // CRUD OPERATIONS
  // ---------------------------------------------------------------------------

  Future<Result<void>> addSymptom(SymptomEntry entry) async {
    try {
      // 1. Save Local First (Optimistic)
      await _localDataSource.cacheSymptom(entry);

      // 2. Sync to Cloud
      try {
        await _remoteDataSource.saveSymptomEntry(entry);
        // Mark as synced locally (Dev B logic)
        await _localDataSource.markAsSynced(entry.id);
      } catch (e) {
        print("Cloud sync failed, data saved locally: $e");
      }
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure("Failed to save symptom: $e"));
    }
  }

  Future<Result<List<SymptomEntry>>> getRecentSymptoms(String userId) async {
    try {
      // Strategy: Try Remote for fresh data, fallback to Local
      try {
        final symptoms = await _remoteDataSource.getSymptoms(userId);
        // Cache them
        await _localDataSource.cacheSymptoms(symptoms);
        return Result.success(symptoms);
      } catch (e) {
        // Fallback
        final localData = await _localDataSource.getSymptoms(userId);
        return Result.success(localData);
      }
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // AGGREGATION LOGIC (Business Logic for Charts)
  // ---------------------------------------------------------------------------

  /// Calculates the average Blood Pressure for a given date range.
  /// Returns a Map with 'systolic' and 'diastolic' averages.
  Future<Result<Map<String, int>>> getAverageBloodPressure(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    try {
      // 1. Get raw data for the period
      // Note: We prioritize local data for aggregation speed if offline,
      // but strictly we should try remote. For now, let's assume we fetch fresh.
      final logs = await _remoteDataSource.getSymptomsByDateRange(
        userId,
        start,
        end,
      );

      if (logs.isEmpty) {
        return Result.success({'systolic': 0, 'diastolic': 0});
      }

      // 2. Filter only entries that have BP data
      final bpLogs = logs.where((log) => log.bloodPressure != null).toList();

      if (bpLogs.isEmpty) {
        return Result.success({'systolic': 0, 'diastolic': 0});
      }

      // 3. Calculate Averages
      int totalSys = 0;
      int totalDia = 0;

      for (var log in bpLogs) {
        totalSys += log.bloodPressure!.systolic;
        totalDia += log.bloodPressure!.diastolic;
      }

      final avgSys = (totalSys / bpLogs.length).round();
      final avgDia = (totalDia / bpLogs.length).round();

      return Result.success({
        'systolic': avgSys,
        'diastolic': avgDia,
        'count': bpLogs.length, // Useful meta-data
      });
    } catch (e) {
      return Result.failure(ServerFailure("Failed to calculate stats: $e"));
    }
  }
}

// =============================================================================
// CONTRACT FOR DEVELOPER B
// =============================================================================
abstract class SymptomLocalDataSource {
  Future<void> cacheSymptom(SymptomEntry entry);
  Future<void> cacheSymptoms(List<SymptomEntry> symptoms);
  Future<List<SymptomEntry>> getSymptoms(String userId);
  Future<void> markAsSynced(String symptomId);
}
