import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/models/user.dart';
import '../models/user_profile.dart';
import '../models/allergy.dart';
import '../models/chronic_disease.dart';

class ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // FETCH: Get Full Profile (User Info + Sub-collections)
  // ---------------------------------------------------------------------------
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      // 1. Fetch Main User Document (Height, Weight, Blood Type)
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception("User not found in remote database");
      }

      // Convert Firestore data to our User model
      // Note: We use the existing User.fromMap logic
      final userData = userDoc.data()!;
      userData['id'] = userDoc.id; // Ensure ID is present
      final user = User.fromMap(userData);

      // 2. Fetch Allergies Sub-collection
      final allergySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('allergies')
          .get();

      final allergies = allergySnapshot.docs
          .map((doc) => Allergy.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      // 3. Fetch Chronic Diseases Sub-collection
      final diseaseSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chronic_diseases')
          .get();

      final diseases = diseaseSnapshot.docs
          .map((doc) => ChronicDisease.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      // 4. Combine into Aggregate Profile
      return UserProfile.fromUser(
        user,
        allergies: allergies,
        diseases: diseases,
      );
    } catch (e) {
      throw Exception('Failed to fetch remote profile: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // SAVE: Update Profile (Batch Write for Atomicity)
  // ---------------------------------------------------------------------------
  Future<void> saveUserProfile(UserProfile profile) async {
    final batch = _firestore.batch();
    final userRef = _firestore.collection('users').doc(profile.userId);

    // 1. Update Main User Fields (Height, Weight, Blood Type)
    batch.set(userRef, {
      'blood_type': profile.bloodType,
      'height': profile.height,
      'weight': profile.weight,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true)); // Merge prevents overwriting email/name

    // 2. Update Allergies (Overwrite strategy for simplicity)
    // In a complex app, we would calculate diffs. Here we just overwrite.
    final allergyCollection = userRef.collection('allergies');

    // Ideally, delete old ones first or use specific IDs.
    // For this implementation, we assume we are Upserting based on ID.
    for (var allergy in profile.allergies) {
      final docRef = allergyCollection.doc(
        allergy.id.isNotEmpty ? allergy.id : null,
      );
      batch.set(docRef, allergy.toMap());
    }

    // 3. Update Chronic Diseases
    final diseaseCollection = userRef.collection('chronic_diseases');
    for (var disease in profile.chronicDiseases) {
      final docRef = diseaseCollection.doc(
        disease.id.isNotEmpty ? disease.id : null,
      );
      batch.set(docRef, disease.toMap());
    }

    // 4. Commit all changes at once
    await batch.commit();
  }
}
