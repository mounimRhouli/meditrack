import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/reminder.dart';
import 'package:meditrack/core/constants/database_constants.dart';

class ReminderLocalDataSource {
  final DatabaseHelper _dbHelper;
  ReminderLocalDataSource(this._dbHelper);

  Future<void> insertReminder(Reminder reminder) async {
    final db = await _dbHelper.database;
    await db.insert(DatabaseConstants.tableReminders, reminder.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Reminder>> fetchReminders() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseConstants.tableReminders);
    return maps.map((json) => Reminder.fromJson(json)).toList();
  }

  Future<void> updateReminder(Reminder reminder) async {
    final db = await _dbHelper.database;
    await db.update(DatabaseConstants.tableReminders, reminder.toJson(), where: 'id = ?', whereArgs: [reminder.id]);
  }
}