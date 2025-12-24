import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'migrations/migration_v1.dart';
// You will import future migrations here as you create them
// import 'migrations/migration_v2.dart';

class DatabaseHelper {
  // The singleton instance of DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Factory constructor to return the singleton instance
  factory DatabaseHelper() => _instance;

  // Internal private constructor
  DatabaseHelper._internal();

  // The actual database instance
  static Database? _database;

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // If the database doesn't exist, initialize it
    _database = await _initDatabase();
    return _database!;
  }

  // Initializes the database
  Future<Database> _initDatabase() async {
    // Get the path for the database
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'meditrack.db');

    // Open the database
    return await openDatabase(
      path,
      version: MigrationV1.version, // The current version of the database
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Called when the database is first created
  Future<void> _onCreate(Database db, int version) async {
    print("Database: Creating database with version $version");
    // Run the initial migration
    await MigrationV1.create(db);
  }

  // Called when the database version is upgraded
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print(
      "Database: Upgrading database from version $oldVersion to $newVersion",
    );
    // This is where you will handle future migrations
    // Example:
    // if (oldVersion < 2) {
    //   await MigrationV2.upgrade(db);
    // }
    // if (oldVersion < 3) {
    //   await MigrationV3.upgrade(db);
    // }
  }

  // Closes the database
  Future<void> close() async {
    final db = await database;
    if (db.isOpen) {
      await db.close();
      _database = null;
    }
  }
}
