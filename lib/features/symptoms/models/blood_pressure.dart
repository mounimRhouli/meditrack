import 'dart:convert';

class BloodPressure {
  final int systolic; // Top number (e.g., 120)
  final int diastolic; // Bottom number (e.g., 80)
  final int? pulse; // Heart rate (bpm)

  const BloodPressure({
    required this.systolic,
    required this.diastolic,
    this.pulse,
  });

  Map<String, dynamic> toMap() {
    return {'systolic': systolic, 'diastolic': diastolic, 'pulse': pulse};
  }

  factory BloodPressure.fromMap(Map<String, dynamic> map) {
    return BloodPressure(
      systolic: map['systolic'] ?? 0,
      diastolic: map['diastolic'] ?? 0,
      pulse: map['pulse'],
    );
  }

  String toJson() => json.encode(toMap());
  factory BloodPressure.fromJson(String source) =>
      BloodPressure.fromMap(json.decode(source));

  // Helper for formatting
  @override
  String toString() => '$systolic/$diastolic';
}
