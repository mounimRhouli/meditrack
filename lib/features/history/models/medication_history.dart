import '../../../shared/models/sync_status.dart';
import 'intake_status.dart';

class MedicationHistory {
  final String id;
  final String medicationId;
  final DateTime scheduledTime;
  final DateTime? takenTime;
  final IntakeStatus intakeStatus;
  final SyncStatus syncStatus;

  MedicationHistory({
    required this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.takenTime,
    required this.intakeStatus,
    this.syncStatus = SyncStatus.pending,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medication_id': medicationId,
      'scheduled_time': scheduledTime.millisecondsSinceEpoch,
      'taken_time': takenTime?.millisecondsSinceEpoch,
      'intake_status': intakeStatus.name,
      'sync_status': syncStatus.name,
    };
  }

  factory MedicationHistory.fromJson(Map<String, dynamic> json) {
    return MedicationHistory(
      id: json['id'],
      medicationId: json['medication_id'],
      scheduledTime: DateTime.fromMillisecondsSinceEpoch(json['scheduled_time']),
      takenTime: json['taken_time'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['taken_time']) 
          : null,
      intakeStatus: IntakeStatus.values.byName(json['intake_status']),
      syncStatus: SyncStatus.values.byName(json['sync_status'] ?? 'pending'),
    );
  }
}