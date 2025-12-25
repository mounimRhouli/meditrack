import '../../../shared/models/sync_status.dart';
import 'reminder_status.dart';

class Reminder {
  final String id;
  final String medicationId;
  final String time; // Format HH:mm
  final ReminderStatus status;
  final SyncStatus syncStatus;

  Reminder({
    required this.id,
    required this.medicationId,
    required this.time,
    this.status = ReminderStatus.active,
    this.syncStatus = SyncStatus.pending,
  });

  // Pour SQLite et Sync
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medication_id': medicationId,
      'time': time,
      'is_active': status == ReminderStatus.active ? 1 : 0,
      'sync_status': syncStatus.name,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      medicationId: json['medication_id'],
      time: json['time'],
      status: json['is_active'] == 1 ? ReminderStatus.active : ReminderStatus.paused,
      syncStatus: SyncStatus.values.byName(json['sync_status'] ?? 'pending'),
    );
  }

  Reminder copyWith({ReminderStatus? status, SyncStatus? syncStatus}) {
    return Reminder(
      id: id,
      medicationId: medicationId,
      time: time,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}