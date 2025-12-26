import '../models/reminder.dart';

abstract class ReminderRemoteDataSource {
  Future<void> syncReminder(Reminder reminder);
}

class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  @override
  Future<void> syncReminder(Reminder reminder) async {
    // Implémentation Firestore
  }
}
