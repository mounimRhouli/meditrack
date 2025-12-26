import 'package:sqflite/sqflite.dart';

class MigrationV1 {
  static const int version = 1;

  /// Executes the initial schema creation for the entire application.
  static Future<void> create(Database db) async {
    // We use a Batch to run multiple SQL commands at once for performance.
    var batch = db.batch();

    // 1. Users Table (Auth & Profile)
    batch.execute('''
  CREATE TABLE users (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    name TEXT,
    blood_type TEXT, -- Metric
    height REAL,      -- Metric
    weight REAL,      -- Metric
    profile_picture TEXT,
    created_at INTEGER NOT NULL,
    last_updated INTEGER NOT NULL,
    sync_status TEXT DEFAULT 'pending'
  )
''');

    // 2. Allergies Table (Profile)
    batch.execute('''
      CREATE TABLE allergies (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        severity TEXT NOT NULL, -- 'mild', 'moderate', 'severe'
        sync_status TEXT DEFAULT 'pending',
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 3. Chronic Diseases Table (Profile)
    batch.execute('''
      CREATE TABLE chronic_diseases (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        notes TEXT,
        sync_status TEXT DEFAULT 'pending',
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 4. Medications Table
    batch.execute('''
      CREATE TABLE medications (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        form TEXT NOT NULL, -- 'pill', 'syrup', 'injection'
        frequency TEXT NOT NULL, -- e.g., 'daily', 'twice_a_day', 'weekly'
        start_date INTEGER NOT NULL,
        end_date INTEGER, -- Can be null for ongoing medications
        sync_status TEXT DEFAULT 'pending',
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 5. Reminders Table
    batch.execute('''
      CREATE TABLE reminders (
        id TEXT PRIMARY KEY,
        medication_id TEXT NOT NULL,
        time TEXT NOT NULL, -- Format: 'HH:mm'
        is_active INTEGER NOT NULL DEFAULT 1, -- 1 for true, 0 for false
        sync_status TEXT DEFAULT 'pending',
        FOREIGN KEY (medication_id) REFERENCES medications (id) ON DELETE CASCADE
      )
    ''');

    // 6. Medication History Table
    batch.execute('''
      CREATE TABLE medication_history (
        id TEXT PRIMARY KEY,
        medication_id TEXT NOT NULL,
        scheduled_time INTEGER NOT NULL,
        taken_time INTEGER, -- Null if missed
        intake_status TEXT NOT NULL, -- 'taken', 'missed', 'late'
        sync_status TEXT DEFAULT 'pending',
        FOREIGN KEY (medication_id) REFERENCES medications (id) ON DELETE CASCADE
      )
    ''');

    // 7. Medical Documents Table
    batch.execute('''
      CREATE TABLE documents (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL, -- 'analysis', 'xray', 'prescription'
        local_path TEXT NOT NULL,
        remote_url TEXT, -- URL in Firebase Storage
        ocr_text TEXT, -- Text extracted by OCR
        upload_date INTEGER NOT NULL,
        sync_status TEXT DEFAULT 'pending',
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 8. Symptoms Table
    batch.execute('''
      CREATE TABLE symptoms (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        type TEXT NOT NULL, -- 'pain', 'blood_pressure', 'mood', 'temperature', 'glucose'
        value TEXT NOT NULL, -- JSON string to store flexible data
        notes TEXT,
        sync_status TEXT DEFAULT 'pending',
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 9. Emergency Contacts Table
    batch.execute('''
      CREATE TABLE emergency_contacts (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        relation TEXT,
        is_primary INTEGER NOT NULL DEFAULT 0,
        sync_status TEXT DEFAULT 'pending',
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 10. Sync Queue Table (For Cloud Sync)
    batch.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name TEXT NOT NULL,
        record_id TEXT NOT NULL,
        action TEXT NOT NULL, -- 'create', 'update', 'delete'
        data TEXT NOT NULL, -- JSON string of the record's data
        created_at INTEGER NOT NULL
      )
    ''');

    // Commit the batch to execute all creations
    await batch.commit();
  }
}
