import 'dart:convert';

class PainLevel {
  final int value; // 1 to 10
  final String? location; // e.g., "Head", "Lower Back"
  final String? description; // e.g., "Throbbing", "Sharp"

  const PainLevel({required this.value, this.location, this.description});

  Map<String, dynamic> toMap() {
    return {'value': value, 'location': location, 'description': description};
  }

  factory PainLevel.fromMap(Map<String, dynamic> map) {
    return PainLevel(
      value: map['value'] ?? 0,
      location: map['location'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());
  factory PainLevel.fromJson(String source) =>
      PainLevel.fromMap(json.decode(source));
}
