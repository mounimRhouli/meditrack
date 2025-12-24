class DatabaseConstants {
  // Private constructor to prevent instantiation
  DatabaseConstants._();

  // ==========================================
  // Table Names
  // ==========================================
  static const String tableUsers = 'users';
  static const String tableMedications = 'medications';
  static const String tableReminders = 'reminders';
  static const String tableHistory = 'medication_history';
  static const String tableDocuments = 'medical_documents';
  static const String tableSymptoms = 'symptom_logs';
  static const String tableEmergencyContacts = 'emergency_contacts';

  // V2: Chatbot Tables
  static const String tableChatSessions = 'chat_sessions';
  static const String tableChatMessages = 'chat_messages';

  // ==========================================
  // Common Column Names (Used across multiple tables)
  // ==========================================
  static const String colId = 'id';
  static const String colUserId = 'user_id';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';

  // Critical for Sync Service: 0 = Unsynced (Dirty), 1 = Synced
  static const String colIsSynced = 'is_synced';

  // ==========================================
  // Users Table
  // ==========================================
  static const String colEmail = 'email';
  static const String colName = 'name';
  static const String colPhotoUrl = 'photo_url';
  static const String colBloodType = 'blood_type';
  static const String colHeight = 'height';
  static const String colWeight = 'weight';

  // ==========================================
  // Medications Table
  // ==========================================
  static const String colMedName = 'name';
  static const String colDosage = 'dosage'; // e.g., "500mg"
  static const String colForm = 'form'; // e.g., "Pill", "Syrup"
  static const String colFrequency = 'frequency'; // e.g., "DAILY", "WEEKLY"
  static const String colStockCount = 'stock_count';
  static const String colInstructions = 'instructions';
  static const String colStartDate = 'start_date';
  static const String colEndDate = 'end_date';

  // ==========================================
  // Reminders Table
  // ==========================================
  static const String colMedicationId = 'medication_id';
  static const String colTime = 'time'; // Store as ISO8601 string (HH:mm)
  static const String colDays = 'days'; // e.g., "MON,WED,FRI"
  static const String colIsEnabled = 'is_enabled';

  // ==========================================
  // History (Intake Logs) Table
  // ==========================================
  static const String colReminderId = 'reminder_id';
  static const String colTakenAt = 'taken_at'; // Timestamp of actual intake
  static const String colStatus = 'status'; // "TAKEN", "MISSED", "SKIPPED"

  // ==========================================
  // Medical Documents Table
  // ==========================================
  static const String colTitle = 'title';
  static const String colDocType = 'type'; // "PRESCRIPTION", "LAB_RESULT"
  static const String colFilePath = 'file_path'; // Local path on device
  static const String colStorageUrl = 'storage_url'; // Firebase Storage URL
  static const String colDoctorName = 'doctor_name';
  static const String colDateAdded = 'date_added';

  // ==========================================
  // Symptoms Table
  // ==========================================
  static const String colSymptomType = 'symptom_type'; // "HEADACHE", "FEVER"
  static const String colSeverity = 'severity'; // Integer 1-10
  static const String colNotes = 'notes';
  static const String colDateLogged = 'date_logged';

  // ==========================================
  // Emergency Contacts Table
  // ==========================================
  static const String colContactName = 'contact_name';
  static const String colPhoneNumber = 'phone_number';
  static const String colRelation = 'relation'; // "Mother", "Doctor"

  // ==========================================
  // V2: Chatbot Columns
  // ==========================================
  static const String colSessionId = 'session_id';
  static const String colSender = 'sender'; // "USER" or "BOT"
  static const String colMessageContent = 'content';
  static const String colSentAt = 'sent_at';
  static const String colMessageType = 'message_type'; // "TEXT", "SUGGESTION"
}
