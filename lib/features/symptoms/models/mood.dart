import 'dart:convert';

enum MoodType { veryHappy, happy, neutral, sad, angry, anxious }

class Mood {
  final MoodType value;
  final String? note;

  const Mood({required this.value, this.note});

  Map<String, dynamic> toMap() {
    return {
      'value': value.index, // Store as integer for database efficiency
      'note': note,
    };
  }

  factory Mood.fromMap(Map<String, dynamic> map) {
    return Mood(
      value:
          MoodType.values[map['value'] ?? 2], // Default to neutral if missing
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());
  factory Mood.fromJson(String source) => Mood.fromMap(json.decode(source));
}
