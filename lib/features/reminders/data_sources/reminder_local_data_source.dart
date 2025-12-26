import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/reminder.dart';

class ReminderLocalDataSource {
  final DatabaseHelper _dbHelper;
  ReminderLocalDataSource(this._dbHelper);

  Future<void> insertReminder(Reminder reminder) async {
    final db = await _dbHelper.database;
    await db.insert('reminders', reminder.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Reminder>> fetchReminders() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return maps.map((json) => Reminder.fromJson(json)).toList();
  }

  Future<void> updateReminder(Reminder reminder) async {
    final db = await _dbHelper.database;
    await db.update('reminders', reminder.toJson(), where: 'id = ?', whereArgs: [reminder.id]);
  }
}