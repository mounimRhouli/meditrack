import 'dart:convert';

class EmergencyContact {
  final String id;
  final String name;
  final String relationship; // e.g., "Mother", "Spouse"
  final String phoneNumber;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'relationship': relationship,
      'phone_number': phoneNumber,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
    );
  }
}

class EmergencyInfo {
  final String userId;
  final String? bloodType;
  final String? medicalNotes; // "Diabetic, Allergic to Penicillin"
  final List<EmergencyContact> contacts;

  const EmergencyInfo({
    required this.userId,
    this.bloodType,
    this.medicalNotes,
    this.contacts = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'blood_type': bloodType,
      'medical_notes': medicalNotes,
      'contacts': contacts.map((x) => x.toMap()).toList(),
    };
  }

  factory EmergencyInfo.fromMap(Map<String, dynamic> map) {
    return EmergencyInfo(
      userId: map['user_id'] ?? '',
      bloodType: map['blood_type'],
      medicalNotes: map['medical_notes'],
      contacts: List<EmergencyContact>.from(
        (map['contacts'] as List<dynamic>? ?? []).map<EmergencyContact>(
          (x) => EmergencyContact.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory EmergencyInfo.fromJson(String source) =>
      EmergencyInfo.fromMap(json.decode(source));

  // Helper to quickly check if setup is complete
  bool get hasContacts => contacts.isNotEmpty;
}
