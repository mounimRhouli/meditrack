import 'dart:convert';

class Allergy {
  final String id;
  final String name;
  final String severity; // e.g., "Mild", "Severe"
  final String? reaction; // e.g., "Rash", "Anaphylaxis"

  Allergy({
    required this.id,
    required this.name,
    required this.severity,
    this.reaction,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'severity': severity, 'reaction': reaction};
  }

  factory Allergy.fromMap(Map<String, dynamic> map) {
    return Allergy(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      severity: map['severity'] ?? 'Mild',
      reaction: map['reaction'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Allergy.fromJson(String source) =>
      Allergy.fromMap(json.decode(source));
}
