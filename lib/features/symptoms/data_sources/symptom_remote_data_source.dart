import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/symptom_entry.dart';

class SymptomRemoteDataSource {
  final FirebaseFirestore _firestore;

  SymptomRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // SAVE (Create or Update)
  // ---------------------------------------------------------------------------
  Future<void> saveSymptomEntry(SymptomEntry entry) async {
    try {
      // Path: users/{userId}/symptoms/{symptomId}
      await _firestore
          .collection('users')
          .doc(entry.userId)
          .collection('symptoms')
          .doc(entry.id)
          .set(entry.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to sync symptom to cloud: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // FETCH (With Filters)
  // ---------------------------------------------------------------------------
  /// Fetches symptoms for a specific user, ordered by newest first.
  /// Optional [limit] to avoid fetching 10 years of data at once.
  Future<List<SymptomEntry>> getSymptoms(
    String userId, {
    int limit = 20,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('symptoms')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        // Inject the ID from the document reference just in case
        final data = doc.data();
        data['id'] = doc.id;
        return SymptomEntry.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch remote symptoms: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // FETCH BY DATE RANGE (For Charts)
  // ---------------------------------------------------------------------------
  Future<List<SymptomEntry>> getSymptomsByDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('symptoms')
          .where(
            'timestamp',
            isGreaterThanOrEqualTo: start.millisecondsSinceEpoch,
          )
          .where('timestamp', isLessThanOrEqualTo: end.millisecondsSinceEpoch)
          .orderBy(
            'timestamp',
            descending: false,
          ) // Oldest to Newest for charts
          .get();

      return snapshot.docs
          .map((doc) => SymptomEntry.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch chart data: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------
  Future<void> deleteSymptomEntry(String userId, String symptomId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('symptoms')
          .doc(symptomId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete remote symptom: $e');
    }
  }
}
