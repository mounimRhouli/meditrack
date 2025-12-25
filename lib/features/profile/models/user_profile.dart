import '../../auth/models/user.dart';
import 'allergy.dart';
import 'chronic_disease.dart';

class UserProfile {
  final String userId;
  final String? bloodType;
  final double? height;
  final double? weight;

  // Lists of medical conditions
  final List<Allergy> allergies;
  final List<ChronicDisease> chronicDiseases;

  // Sync status
  final bool isSynced;

  UserProfile({
    required this.userId,
    this.bloodType,
    this.height,
    this.weight,
    this.allergies = const [],
    this.chronicDiseases = const [],
    this.isSynced = true,
  });

  // ---------------------------------------------------------------------------
  // Factory: Create Profile from the Base User
  // ---------------------------------------------------------------------------
  factory UserProfile.fromUser(
    User user, {
    List<Allergy>? allergies,
    List<ChronicDisease>? diseases,
  }) {
    return UserProfile(
      userId: user.id,
      bloodType: user.bloodType,
      height: user.height,
      weight: user.weight,
      allergies: allergies ?? [],
      chronicDiseases: diseases ?? [],
      isSynced: user.isSynced,
    );
  }

  // ---------------------------------------------------------------------------
  // CopyWith (For Immutable Updates)
  // ---------------------------------------------------------------------------
  UserProfile copyWith({
    String? bloodType,
    double? height,
    double? weight,
    List<Allergy>? allergies,
    List<ChronicDisease>? chronicDiseases,
    bool? isSynced,
  }) {
    return UserProfile(
      userId: this.userId, // ID never changes
      bloodType: bloodType ?? this.bloodType,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  // Architect's Note:
  // We typically don't have a single "toSqlMap" for this class because
  // it spans multiple tables (Users, Allergies, Diseases).
  // The Repository will handle breaking this object down into those parts.
}
