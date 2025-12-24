// lib/routes/route_names.dart

class AppRouteNames {
  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Main App
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';

  // Medications
  static const String medicationsList = '/medications';
  static const String addMedication = '/medications/add';
  static const String editMedication = '/medications/edit';
  static const String medicationDetail = '/medications/detail';
  static const String barcodeScanner = '/medications/scan';

  // Reminders
  static const String reminders = '/reminders';

  // History
  static const String history = '/history';
  static const String historyCalendar = '/history/calendar';
  static const String historyStats = '/history/stats';

  // Documents
  static const String documents = '/documents';
  static const String addDocument = '/documents/add';
  static const String documentDetail = '/documents/detail';
  static const String ocrPreview = '/documents/ocr';

  // Symptoms
  static const String symptoms = '/symptoms';
  static const String addSymptom = '/symptoms/add';
  static const String symptomCharts = '/symptoms/charts';

  // Emergency
  static const String emergency = '/emergency';

  // Chatbot
  static const String chatbot = '/chatbot';

  // Sync
  static const String syncSettings = '/sync';
}
