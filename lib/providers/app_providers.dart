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

// --- Features: Documents (Phase 3) ---
import '../features/documents/services/image_picker_service.dart';
import '../features/documents/services/ocr_service.dart';
import '../features/documents/services/file_manager_service.dart';
import '../features/documents/data_sources/file_storage_data_source.dart';
import '../features/documents/repositories/document_repository.dart';
import '../features/documents/viewmodels/documents_viewmodel.dart';
import '../features/documents/viewmodels/ocr_viewmodel.dart';

import '../features/profile/data_sources/profile_local_data_source.dart';
import '../features/profile/data_sources/profile_remote_data_source.dart';
import '../features/profile/repositories/profile_repository.dart';
import '../features/profile/viewmodels/profile_viewmodel.dart';
import '../features/medications/data_sources/medication_local_data_source.dart';
import '../features/medications/repositories/medication_repository.dart';
import '../features/medications/data_sources/medication_local_data_source.dart';
import '../features/medications/repositories/medication_repository.dart';
import '../features/medications/viewmodels/medication_form_viewmodel.dart';
import '../features/medications/viewmodels/medications_list_viewmodel.dart';

// 1. CORE
final dbProvider = Provider<DatabaseHelper>((ref) => DatabaseHelper());

// 2. REMINDERS
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final reminderLocalDataSourceProvider = Provider<ReminderLocalDataSource>((
  ref,
) {
  return ReminderLocalDataSource(ref.read(dbProvider));
});

final reminderRemoteDataSourceProvider = Provider<ReminderRemoteDataSource>((
  ref,
) {
  return ReminderRemoteDataSourceImpl();
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository(
    ref.read(reminderLocalDataSourceProvider),
    ref.read(notificationServiceProvider),
  );
});

final remindersViewModelProvider =
    StateNotifierProvider.family<RemindersViewModel, RemindersState, String>((
      ref,
      medicationId,
    ) {
      final repository = ref.read(reminderRepositoryProvider);
      return RemindersViewModel(repository, medicationId);
    });

// 3. HISTORY
final historyLocalDataSourceProvider = Provider<HistoryLocalDataSource>((ref) {
  return HistoryLocalDataSource(ref.read(dbProvider));
});

final historyRemoteDataSourceProvider = Provider<HistoryRemoteDataSource>((
  ref,
) {
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
final historyViewModelProvider =
    StateNotifierProvider<HistoryViewModel, HistoryState>((ref) {
      final repository = ref.read(historyRepositoryProvider);
      return HistoryViewModel(repository);
    });

// ==========================================
// 2. DOCUMENT MANAGEMENT PROVIDERS (Phase 3)
// ==========================================

// Services
final imagePickerServiceProvider = Provider((ref) => ImagePickerService());
final ocrServiceProvider = Provider((ref) => OCRService());
final fileManagerServiceProvider = Provider((ref) => FileManagerService());

// Data Sources
final fileStorageDataSourceProvider = Provider(
  (ref) => FileStorageDataSource(),
);

// Repository
final documentRepositoryProvider = Provider(
  (ref) => DocumentRepository(
    ref.watch(dbProvider),
    ref.watch(fileStorageDataSourceProvider),
    ref.watch(fileManagerServiceProvider),
  ),
);

// ViewModels
// Gère la liste des documents et l'état de chargement
final documentsViewModelProvider =
    StateNotifierProvider<DocumentsViewModel, DocumentsState>((ref) {
      return DocumentsViewModel(ref.watch(documentRepositoryProvider));
    });

// Gère spécifiquement l'état du scan OCR (en cours, texte extrait)
final ocrViewModelProvider = StateNotifierProvider<OCRViewModel, OCRState>((
  ref,
) {
  return OCRViewModel(ref.watch(ocrServiceProvider));
});

/// 1. Remote Data Source (Developer A's logic)
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSource();
});

/// 2. Local Data Source Implementation (Developer B's logic)
/// This links the abstract class to your SQLite implementation.
final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  final dbHelper = ref.watch(dbProvider);
  return ProfileLocalDataSourceImpl(dbHelper);
});

/// 3. Repository
/// Orchestrates the 'Smart Sync Strategy' between Cloud and Local.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    localDataSource: ref.watch(profileLocalDataSourceProvider),
  );
});

/// 4. ViewModel (State Management)
/// Manages loading/error states and allows the UI to watch the profile.
/// 4. ViewModel (State Management)
/// Uses ChangeNotifierProvider to match the ProfileViewModel implementation.
final profileViewModelProvider = ChangeNotifierProvider<ProfileViewModel>((
  ref,
) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileViewModel(profileRepository: repository);
});

// ... existing imports

final medicationLocalDataSourceProvider = Provider(
  (ref) => MedicationLocalDataSource(ref.watch(dbProvider)),
);

final medicationRepositoryProvider = Provider(
  (ref) => MedicationRepository(ref.watch(medicationLocalDataSourceProvider)),
);

final medicationFormViewModelProvider = ChangeNotifierProvider(
  (ref) => MedicationFormViewModel(
    repository: ref.watch(medicationRepositoryProvider),
  ),
);

final medicationsListViewModelProvider = ChangeNotifierProvider(
  (ref) => MedicationsListViewModel(
    repository: ref.watch(medicationRepositoryProvider),
  ),
);
