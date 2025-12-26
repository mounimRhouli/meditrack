import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'migrations/migration_v1.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Professional fix: Prevent race conditions during init
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'meditrack.db');

    return await openDatabase(
      path,
      version: MigrationV1.version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      // CRITICAL: Enable Foreign Key support
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await MigrationV1.create(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migration logic for future versions
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
