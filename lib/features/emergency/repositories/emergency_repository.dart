import '../../../core/errors/failures.dart';
import '../models/emergency_info.dart';

// Reuse Result pattern
class Result<T> {
  final T? data;
  final Failure? error;
  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;
  bool get isSuccess => error == null;
}

class EmergencyRepository {
  // We assume a remote source exists similar to previous features
  // defined in: features/emergency/data_sources/emergency_remote_data_source.dart
  final EmergencyRemoteDataSource _remoteDataSource;
  final EmergencyLocalDataSource _localDataSource; // Dev B's responsibility

  EmergencyRepository({
    required EmergencyRemoteDataSource remoteDataSource,
    required EmergencyLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  // ---------------------------------------------------------------------------
  // GET INFO (Critical Path: Fast & Offline Capable)
  // ---------------------------------------------------------------------------
  Future<Result<EmergencyInfo>> getEmergencyInfo(String userId) async {
    try {
      // 1. Check Local Cache FIRST (Speed is priority)
      final localData = await _localDataSource.getEmergencyInfo(userId);

      if (localData != null) {
        // We have data! Return it immediately so the screen loads instantly.
        // We can optionally trigger a background sync here if needed.
        _refreshCacheInBackground(userId);
        return Result.success(localData);
      }

      // 2. If Local is empty (First run), try Remote
      try {
        final remoteData = await _remoteDataSource.fetchEmergencyInfo(userId);
        await _localDataSource.cacheEmergencyInfo(remoteData);
        return Result.success(remoteData);
      } catch (e) {
        return Result.failure(
          ServerFailure("No emergency info available offline or online."),
        );
      }
    } catch (e) {
      return Result.failure(
        CacheFailure("System error loading emergency info: $e"),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE INFO
  // ---------------------------------------------------------------------------
  Future<Result<void>> updateEmergencyInfo(EmergencyInfo info) async {
    try {
      // 1. Save Local
      await _localDataSource.cacheEmergencyInfo(info);

      // 2. Try Sync Remote
      try {
        await _remoteDataSource.saveEmergencyInfo(info);
      } catch (e) {
        // If remote fails, that's okay. Local is updated.
        // In a real app, we'd queue a retry.
        print("Emergency sync failed: $e");
      }
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure("Failed to save info locally"));
    }
  }

  // Helper: Silent background update
  void _refreshCacheInBackground(String userId) async {
    try {
      final remoteData = await _remoteDataSource.fetchEmergencyInfo(userId);
      await _localDataSource.cacheEmergencyInfo(remoteData);
    } catch (_) {
      // Silent failure is acceptable here
    }
  }
}

// =============================================================================
// CONTRACTS
// =============================================================================

// Implemented by Dev B (SQLite)
abstract class EmergencyLocalDataSource {
  Future<EmergencyInfo?> getEmergencyInfo(String userId);
  Future<void> cacheEmergencyInfo(EmergencyInfo info);
}

// Implemented by You (Firestore)
// I put this abstract class here for completeness so the file compiles,
// but usually this lives in its own file in data_sources/.
abstract class EmergencyRemoteDataSource {
  Future<EmergencyInfo> fetchEmergencyInfo(String userId);
  Future<void> saveEmergencyInfo(EmergencyInfo info);
}
