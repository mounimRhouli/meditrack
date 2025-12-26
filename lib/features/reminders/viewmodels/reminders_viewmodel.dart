import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart'; // Add this for unique IDs
import '../repositories/reminder_repository.dart';
import '../models/reminder.dart';
import '../models/reminder_status.dart';

class RemindersState {
  final bool isLoading;
  final List<Reminder> reminders;
  RemindersState({this.isLoading = false, this.reminders = const []});
}

class RemindersViewModel extends StateNotifier<RemindersState> {
  final ReminderRepository _repository;
  final String medicationId;

  RemindersViewModel(this._repository, this.medicationId) : super(RemindersState()) {
    loadReminders(); // Auto-load when initialized
  }

  Future<void> loadHistory() async {
    state = RemindersState(isLoading: true, reminders: state.reminders);
    final result = await _repository.getReminders(); // Fetch from DB
    state = RemindersState(isLoading: false, reminders: result);
  }

  Future<void> addNewReminder(String time) async {
    final newReminder = Reminder(
      id: const Uuid().v4(), // Generate unique ID
      medicationId: medicationId,
      time: time,
      status: ReminderStatus.active,
    );
    await _repository.addReminder(newReminder); // Save to DB & Schedule
    await loadReminders(); // Refresh the list
  }
  
  // Method to satisfy the UI's load call
  Future<void> loadReminders() => loadHistory();
}