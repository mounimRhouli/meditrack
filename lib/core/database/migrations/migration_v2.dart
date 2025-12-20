import 'package:sqflite/sqflite.dart';

class MigrationV2 {
  static const int version = 2;

  /// Logic to upgrade from V1 to V2
  static Future<void> upgrade(Database db) async {
    // This is where you will eventually add columns without deleting data
    // Example:
    // await db.execute("ALTER TABLE users ADD COLUMN phone_number TEXT");

    print("Placeholder: Upgrade to V2 complete.");
  }
}
