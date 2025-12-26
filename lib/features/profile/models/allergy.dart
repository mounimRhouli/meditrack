import 'dart:convert';

class Allergy {
  final String id;
  final String name;
  final String severity;
  final String? reaction;

  Allergy({
    required this.id,
    required this.name,
    required this.severity,
    this.reaction,
  });

  // Used for SQLite insertions
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'severity': severity,
      'reaction': reaction,
    };
  }

  // Use this for SQLite queries to fix the "Map cannot be assigned to String" error
  factory Allergy.fromMap(Map<String, dynamic> map) {
    return Allergy(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      severity: map['severity'] ?? 'Mild',
      reaction: map['reaction'],
    );
  }

  // Keep these for API/JSON interactions if needed
  String toJson() => json.encode(toMap());
  
  // Note: Standard practice for SQLite is to use fromMap directly
  factory Allergy.fromJson(String source) =>
      Allergy.fromMap(json.decode(source));
}