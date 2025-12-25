import 'dart:convert';

class ChronicDisease {
  final String id;
  final String name;
  final String? diagnosedDate; // Store as ISO String YYYY-MM-DD
  final String? treatmentPlan; // Brief notes

  ChronicDisease({
    required this.id,
    required this.name,
    this.diagnosedDate,
    this.treatmentPlan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'diagnosed_date': diagnosedDate,
      'treatment_plan': treatmentPlan,
    };
  }

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
