// lib/routes/route_names.dart

class AppRouteNames {
  // Auth
  static const String login = '../features/auth/views/login_screen.dart';
  static const String register = '../features/auth/views/register_screen.dart';

  // Main App
  static const String home = '../features/home/views/home_screen.dart';
  static const String profile = '../features/profile/views/profile_screen.dart';
  static const String editProfile = '../features/profile/views/edit_profile_screen.dart';

  // Medications
  static const String medicationsList = '../features/medications/views/medications_list_screen.dart';
  static const String addMedication = '../features/medications/views/add_medication_screen.dart';
  static const String editMedication = '../features/medications/views/edit_medication_screen.dart';
  static const String medicationDetail = '../features/medications/views/medication_detail_screen.dart';
  static const String barcodeScanner = '../features/medications/views/barcode_scanner_screen.dart';
  // Reminders
  static const String reminders = '../features/reminders/views/reminders_screen.dart';

  // History
  static const String history = '../features/history/views/history_screen.dart';
  static const String historyCalendar = '../features/history/views/history_calendar_screen.dart';
  static const String historyStats = '../features/history/views/history_stats_screen.dart';

  // Documents
  static const String documents = '../features/documents/views/documents_screen.dart';
  static const String addDocument = '../features/documents/views/add_document_screen.dart';
  static const String documentDetail = '../features/documents/views/document_detail_screen.dart';
  static const String ocrPreview = '../features/documents/views/ocr_preview_screen.dart';

  // Symptoms
  static const String symptoms = '../features/symptoms/views/symptoms_screen.dart';
  static const String addSymptom = '../features/symptoms/views/add_symptom_screen.dart';
  static const String symptomCharts = '../features/symptoms/views/symptom_charts_screen.dart';

  // Emergency
  static const String emergency = '../features/emergency/views/emergency_screen.dart';
  // Chatbot
  static const String chatbot = '../features/chatbot/views/chatbot_screen.dart';

  // Sync
  static const String syncSettings = '../features/sync/views/sync_settings_screen.dart';
}
