import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/medication_history.dart';

class HistoryLocalDataSource {
  final DatabaseHelper _dbHelper;
  HistoryLocalDataSource(this._dbHelper);

  Future<void> logIntake(MedicationHistory history) async {
    final db = await _dbHelper.database;
    await db.insert('medication_history', history.toJson(), 
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MedicationHistory>> getHistoryByRange(int start, int end) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medication_history',
      where: 'scheduled_time BETWEEN ? AND ?',
      whereArgs: [start, end],
      orderBy: 'scheduled_time DESC',
    );
    return maps.map((json) => MedicationHistory.fromJson(json)).toList();
  }
}