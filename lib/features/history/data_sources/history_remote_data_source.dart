import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medication_history.dart';

class HistoryRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncHistoryToCloud(MedicationHistory history, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .doc(history.id)
        .set(history.toJson());
  }
}