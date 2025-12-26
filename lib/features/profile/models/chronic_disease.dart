import 'dart:convert';

class ChronicDisease {
  final String id;
  final String name;
  final String? diagnosedDate;
  final String? treatmentPlan;

  ChronicDisease({
    required this.id,
    required this.name,
    this.diagnosedDate,
    this.treatmentPlan,
  });

  // Use this for SQLite insertions
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      // Ensure these match your MigrationV1 column names
      'diagnosed_date': diagnosedDate, 
      'treatment_plan': treatmentPlan,
    };
  }

  // Use this for SQLite queries
  factory ChronicDisease.fromMap(Map<String, dynamic> map) {
    return ChronicDisease(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      diagnosedDate: map['diagnosed_date'],
      treatmentPlan: map['treatment_plan'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChronicDisease.fromJson(String source) =>
      ChronicDisease.fromMap(json.decode(source));
}