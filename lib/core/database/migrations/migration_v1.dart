import 'package:sqflite/sqflite.dart';

class MigrationV1 {
  static const int version = 1;

  /// execute the initial schema creation
  static Future<void> create(Database db) async {
    // We use a Batch to run multiple SQL commands at once for performance
    var batch = db.batch();

    // 1. Users Table
    batch.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE,
        name TEXT,
        profile_picture TEXT,
        created_at INTEGER,
        last_updated INTEGER,
        sync_status TEXT DEFAULT 'pending' 
      )
    ''');

    // 2. Medications Table
    // note: sync_status is crucial for Developer C (Integration) later
    batch.execute('''
      CREATE TABLE medications (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        name TEXT,
        dosage TEXT,
        frequency TEXT,
        start_date INTEGER,
        end_date INTEGER,
        sync_status TEXT DEFAULT 'pending',
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Commit the batch
    await batch.commit();
  }
}
