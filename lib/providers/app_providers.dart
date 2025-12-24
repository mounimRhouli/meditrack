// lib/providers/app_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/database_helper.dart'; // 1. Import your helper

// 2. Create a provider for the DatabaseHelper
// We use a Provider because DatabaseHelper itself is a singleton and doesn't need to be recreated.
final dbProvider = Provider<DatabaseHelper>((ref) {
  // This simply provides an instance of your DatabaseHelper class.
  // The database itself won't be opened until the first time a data source calls `db.database`.
  return DatabaseHelper();
});


// In any data source file, e.g., medication_local_data_source.dart

// class MedicationLocalDataSource {
//   // Get a reference to your provider
//   final DatabaseHelper _dbHelper;

//   // Inject it via the constructor (best practice)
//   MedicationLocalDataSource(this._dbHelper);

//   Future<void> addMedication(Medication med) async {
//     // Get the actual database connection
//     final db = await _dbHelper.database;
//     // ... now run your SQL queries
//   }
// }



// In the future, you will add other providers here:
// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   final dbHelper = ref.read(dbProvider); // See how you can use it!
//   final authService = FirebaseAuthService();
//   return AuthRepository(authService, dbHelper);
// });