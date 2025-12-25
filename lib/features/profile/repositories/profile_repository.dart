import '../../../core/errors/failures.dart';
import '../models/user_profile.dart';
import '../data_sources/profile_remote_data_source.dart';

// Architect's Note:
// This Result class is the same pattern we used in AuthRepository.
// In a real app, define this once in core/utils/result.dart
class Result<T> {
  final T? data;
  final Failure? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => error == null;
}

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource; // Dev B's responsibility

  ProfileRepository({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  // ---------------------------------------------------------------------------
  // GET PROFILE (Smart Sync Strategy)
  // ---------------------------------------------------------------------------
  Future<Result<UserProfile>> getUserProfile(String userId) async {
    try {
      // Strategy: Remote First (Freshness), Fallback to Local (Offline)

      // 1. Try fetching from Cloud
      try {
        final remoteProfile = await _remoteDataSource.getUserProfile(userId);

        // 2. If successful, cache it locally for next time
        await _localDataSource.cacheUserProfile(remoteProfile);

        return Result.success(remoteProfile);
      } catch (e) {
        // 3. If Cloud fails (No Internet), try Local
        print("Remote fetch failed, trying local: $e");

        final localProfile = await _localDataSource.getLastUserProfile(userId);

        if (localProfile != null) {
          return Result.success(localProfile);
        } else {
          return Result.failure(
            const CacheFailure('No profile data found offline.'),
          );
        }
      }
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE PROFILE
  // ---------------------------------------------------------------------------
  Future<Result<void>> updateProfile(UserProfile profile) async {
    try {
      // Strategy: Optimistic UI (Save Local first, then Try Cloud)

      // 1. Save Local immediately (User sees success instantly)
      await _localDataSource.cacheUserProfile(profile);

      // 2. Try pushing to Cloud
      try {
        await _remoteDataSource.saveUserProfile(profile);
        // If successful, mark as synced in local DB (Logic for Dev B)
        await _localDataSource.markAsSynced(profile.userId);
      } catch (e) {
        // If Cloud fails, we don't throw error. We just leave it "dirty" (unsynced).
        // The Background Sync Service (Phase 4) will pick this up later.
        print("Sync failed, data saved locally only: $e");
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure("Failed to save profile locally: $e"));
    }
  }
}

// =============================================================================
// THE CONTRACT FOR DEVELOPER B
// =============================================================================
// You define this interface. Developer B writes the implementation in
// features/profile/data_sources/profile_local_data_source.dart
abstract class ProfileLocalDataSource {
  Future<UserProfile?> getLastUserProfile(String userId);
  Future<void> cacheUserProfile(UserProfile profile);
  Future<void> markAsSynced(String userId);
}
