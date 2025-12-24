import 'dart:convert';
import '../../../core/constants/database_constants.dart';

class User {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;

  // Profile Fields (Stored in same table for efficiency)
  final String? bloodType;
  final double? height;
  final double? weight;

  final DateTime createdAt;
  final DateTime? updatedAt;

  // Architect's Note: Crucial for Sync Service (0 = unsynced, 1 = synced)
  final bool isSynced;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.bloodType,
    this.height,
    this.weight,
    required this.createdAt,
    this.updatedAt,
    this.isSynced = true, // Default to true (synced) unless specified
  });

  // ---------------------------------------------------------------------------
  // JSON Serialization (For Firebase/API)
  // ---------------------------------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo_url': photoUrl,
      'blood_type': bloodType,
      'height': height,
      'weight': weight,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      photoUrl: map['photo_url'],
      bloodType: map['blood_type'],
      height: map['height']?.toDouble(),
      weight: map['weight']?.toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] ?? 0),
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
          : null,
      isSynced: true, // Data coming from API is, by definition, synced.
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  // ---------------------------------------------------------------------------
  // SQLite Serialization (For Local Database)
  // ---------------------------------------------------------------------------
  Map<String, dynamic> toSqlMap() {
    return {
      DatabaseConstants.colId: id,
      DatabaseConstants.colEmail: email,
      DatabaseConstants.colName: name,
      DatabaseConstants.colPhotoUrl: photoUrl,
      DatabaseConstants.colBloodType: bloodType,
      DatabaseConstants.colHeight: height,
      DatabaseConstants.colWeight: weight,
      DatabaseConstants.colCreatedAt: createdAt.millisecondsSinceEpoch,
      DatabaseConstants.colUpdatedAt: updatedAt?.millisecondsSinceEpoch,
      // Convert bool to INT (0 or 1) for SQLite
      DatabaseConstants.colIsSynced: isSynced ? 1 : 0,
    };
  }

  factory User.fromSqlMap(Map<String, dynamic> map) {
    return User(
      id: map[DatabaseConstants.colId],
      email: map[DatabaseConstants.colEmail],
      name: map[DatabaseConstants.colName],
      photoUrl: map[DatabaseConstants.colPhotoUrl],
      bloodType: map[DatabaseConstants.colBloodType],
      height: map[DatabaseConstants.colHeight],
      weight: map[DatabaseConstants.colWeight],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[DatabaseConstants.colCreatedAt],
      ),
      updatedAt: map[DatabaseConstants.colUpdatedAt] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map[DatabaseConstants.colUpdatedAt],
            )
          : null,
      // Convert INT back to bool
      isSynced: (map[DatabaseConstants.colIsSynced] ?? 1) == 1,
    );
  }

  // ---------------------------------------------------------------------------
  // CopyWith (For Immutable State Updates)
  // ---------------------------------------------------------------------------
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    String? bloodType,
    double? height,
    double? weight,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      bloodType: bloodType ?? this.bloodType,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
