import 'package:flutter/material.dart';
import '../models/reminder.dart';
import '../repositories/reminder_repository.dart';

class RemindersViewModel extends ChangeNotifier {
  final ReminderRepository _repo;
  List<Reminder> _reminders = [];

  RemindersViewModel(this._repo) {
    loadReminders();
  }

  List<Reminder> get reminders => _reminders;

  Future<void> loadReminders() async {
    _reminders = await _repo.getReminders();
    notifyListeners();
  }

  Future<void> addNewReminder(String time) async {
    final reminder = Reminder(
      id: DateTime.now().toIso8601String(),
      medicationId: 'med_1',
      time: time,
    );
    await _repo.addReminder(reminder);
    await loadReminders();
  }
}
