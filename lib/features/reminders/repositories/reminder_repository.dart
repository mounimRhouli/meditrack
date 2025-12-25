import '../data_sources/reminder_local_data_source.dart';
import '../models/reminder.dart';
import '../models/reminder_status.dart';
import '../services/notification_service.dart';

class ReminderRepository {
  final ReminderLocalDataSource _local;
  final NotificationService _notifications;

  ReminderRepository(this._local, this._notifications);

  Future<void> addReminder(Reminder reminder) async {
    await _local.insertReminder(reminder);
    if (reminder.status == ReminderStatus.active) {
      await _notifications.scheduleReminder(reminder, "Médicament");
    }
  }

  Future<List<Reminder>> getReminders() => _local.fetchReminders();
}
