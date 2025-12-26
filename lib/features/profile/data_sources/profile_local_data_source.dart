import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/user_profile.dart';
import '../models/allergy.dart';
import '../models/chronic_disease.dart';
import '../repositories/profile_repository.dart';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final DatabaseHelper _dbHelper;

  ProfileLocalDataSourceImpl(this._dbHelper);

  @override
  Future<UserProfile?> getLastUserProfile(String userId) async {
    final db = await _dbHelper.database;

    // 1. Fetch core user metrics
    final userMap = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (userMap.isEmpty) return null;

    // 2. Fetch associated lists
    final allergyMaps = await db.query(
      'allergies',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    final diseaseMaps = await db.query(
      'chronic_diseases',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    // 3. Reconstruct the UserProfile object
    return UserProfile(
      userId: userId,
      bloodType: userMap.first['blood_type'] as String?,
      height: userMap.first['height'] as double?,
      weight: userMap.first['weight'] as double?,
      isSynced: userMap.first['sync_status'] == 'synced',
      // FIX: Use fromMap (accepts Map) instead of fromJson (accepts String)
      allergies: allergyMaps.map((map) => Allergy.fromMap(map)).toList(),
      chronicDiseases: diseaseMaps
          .map((map) => ChronicDisease.fromMap(map))
          .toList(),
    );
  }

  @override
  Future<void> cacheUserProfile(UserProfile profile) async {
    final db = await _dbHelper.database;

    // Use a transaction to ensure atomic updates across multiple tables
    await db.transaction((txn) async {
      // Update core user record
      await txn.update(
        'users',
        {
          'blood_type': profile.bloodType,
          'height': profile.height,
          'weight': profile.weight,
          'sync_status': 'pending', // Mark as pending for sync engine
        },
        where: 'id = ?',
        whereArgs: [profile.userId],
      );

      // Refresh Allergies
      await txn.delete(
        'allergies',
        where: 'user_id = ?',
        whereArgs: [profile.userId],
      );
      for (var allergy in profile.allergies) {
        await txn.insert('allergies', {
          ...allergy.toMap(), // FIX: Spread operator now works with Map return
          'user_id': profile.userId,
        });
      }

      // Refresh Chronic Diseases
      await txn.delete(
        'chronic_diseases',
        where: 'user_id = ?',
        whereArgs: [profile.userId],
      );
      for (var disease in profile.chronicDiseases) {
        await txn.insert('chronic_diseases', {
          ...disease.toMap(),
          'user_id': profile.userId,
        });
      }
    });
  }

  @override
  Future<void> markAsSynced(String userId) async {
    final db = await _dbHelper.database;
    await db.update(
      'users',
      {'sync_status': 'synced'},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
