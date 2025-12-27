import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../models/medication.dart';
import 'package:meditrack/core/constants/database_constants.dart';

class MedicationLocalDataSource {
  final DatabaseHelper _dbHelper;

  MedicationLocalDataSource(this._dbHelper);

  Future<void> insertMedication(Medication medication) async {
    final db = await _dbHelper.database;
    await db.insert(
      DatabaseConstants.tableMedications,
      medication.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Medication>> fetchAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(DatabaseConstants.tableMedications);
    return maps.map((map) => Medication.fromMap(map)).toList();
  }

  Future<void> removeById(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Medication>> searchMedications(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseConstants.tableMedications,
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
    return maps.map((map) => Medication.fromMap(map)).toList();
  }
}