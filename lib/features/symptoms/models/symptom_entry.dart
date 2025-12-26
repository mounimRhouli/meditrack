import 'dart:convert';
import 'blood_pressure.dart';
import 'mood.dart';
import 'pain_level.dart';

class SymptomEntry {
  final String id;
  final String userId;
  final DateTime timestamp;

  // Nullable sub-models: An entry might only contain one of these
  final BloodPressure? bloodPressure;
  final Mood? mood;
  final PainLevel? pain;

  // Generic text note for the entry
  final String? note;

  // Sync Status (Architectural Requirement)
  final bool isSynced;

  const SymptomEntry({
    required this.id,
    required this.userId,
    required this.timestamp,
    this.bloodPressure,
    this.mood,
    this.pain,
    this.note,
    this.isSynced = true,
  });

  // ---------------------------------------------------------------------------
  // JSON Serialization (Remote/Firestore)
  // ---------------------------------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'blood_pressure': bloodPressure?.toMap(), // Nested Map
      'mood': mood?.toMap(), // Nested Map
      'pain': pain?.toMap(), // Nested Map
      'note': note,
    };
  }

  factory SymptomEntry.fromMap(Map<String, dynamic> map) {
    return SymptomEntry(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      bloodPressure: map['blood_pressure'] != null
          ? BloodPressure.fromMap(map['blood_pressure'])
          : null,
      mood: map['mood'] != null ? Mood.fromMap(map['mood']) : null,
      pain: map['pain'] != null ? PainLevel.fromMap(map['pain']) : null,
      note: map['note'],
      isSynced: true, // Incoming from remote is always synced
    );
  }

  // ---------------------------------------------------------------------------
  // Helper: CopyWith
  // ---------------------------------------------------------------------------
  SymptomEntry copyWith({String? id, bool? isSynced}) {
    return SymptomEntry(
      id: id ?? this.id,
      userId: userId,
      timestamp: timestamp,
      bloodPressure: bloodPressure,
      mood: mood,
      pain: pain,
      note: note,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
