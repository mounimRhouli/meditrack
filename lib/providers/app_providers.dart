import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/database_helper.dart';

// --- Reminders ---
import '../features/reminders/data_sources/reminder_local_data_source.dart';
import '../features/reminders/data_sources/reminder_remote_data_source.dart';
import '../features/reminders/services/notification_service.dart';
import '../features/reminders/repositories/reminder_repository.dart';
import '../features/reminders/viewmodels/reminders_viewmodel.dart';

// --- History ---
import '../features/history/data_sources/history_local_data_source.dart';
import '../features/history/data_sources/history_remote_data_source.dart';
import '../features/history/repositories/history_repository.dart';
import '../features/history/viewmodels/history_viewmodel.dart';
import '../features/history/viewmodels/history_stats_viewmodel.dart';

// 1. CORE
final dbProvider = Provider<DatabaseHelper>((ref) => DatabaseHelper());

// 2. REMINDERS
final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

final reminderLocalDataSourceProvider = Provider<ReminderLocalDataSource>((ref) {
  return ReminderLocalDataSource(ref.read(dbProvider));
});

final reminderRemoteDataSourceProvider = Provider<ReminderRemoteDataSource>((ref) {
  return ReminderRemoteDataSourceImpl(); 
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(
    ref.read(reminderLocalDataSourceProvider),
    ref.read(notificationServiceProvider),
  );
});

final remindersViewModelProvider = StateNotifierProvider.family<RemindersViewModel, RemindersState, String>((ref, medicationId) {
  final repository = ref.read(reminderRepositoryProvider);
  return RemindersViewModel(repository, medicationId);
});

// 3. HISTORY
final historyLocalDataSourceProvider = Provider<HistoryLocalDataSource>((ref) {
  return HistoryLocalDataSource(ref.read(dbProvider));
});

final historyRemoteDataSourceProvider = Provider<HistoryRemoteDataSource>((ref) {
  // Ensure this is not an abstract class
  return HistoryRemoteDataSource(); 
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(
    ref.read(historyLocalDataSourceProvider),
    ref.read(historyRemoteDataSourceProvider),
  );
});

// SINGLE History Provider (Managing both items and stats)
final historyViewModelProvider = StateNotifierProvider<HistoryViewModel, HistoryState>((ref) {
  final repository = ref.read(historyRepositoryProvider);
  return HistoryViewModel(repository);
});