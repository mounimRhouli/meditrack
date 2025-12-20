class AppStrings {
  // Prevent instantiation
  AppStrings._();

  // -- General --
  static const String appName = 'MediTrack';
  static const String welcomeMessage = 'Bonjour';
  static const String dashboardTitle = 'Tableau de bord';

  // -- Pillar 1: Profile & Treatments [cite: 138] --
  static const String profileTitle = 'Profil';
  static const String basicInfo = 'Informations de base';
  static const String age = 'Âge';
  static const String height = 'Taille (cm)';
  static const String weight = 'Poids (kg)';
  static const String allergies = 'Allergies';
  static const String chronicDiseases = 'Maladies Chroniques';

  static const String treatmentsTitle = 'Traitements';
  static const String addMedicine = 'Ajouter un Médicament';
  static const String medicineName = 'Nom du médicament';
  static const String medicineDosage = 'Dosage (ex: 500 mg)';
  static const String medicineForm = 'Forme (ex: Comprimé)';
  static const String medicineFrequency = 'Fréquence';

  // -- Pillar 2: Reminders & History [cite: 145] --
  static const String remindersTitle = 'Rappels';
  static const String nextDose = 'Prochain médicament à prendre';
  static const String reminderActionTaken = 'Pris';
  static const String reminderActionIgnore = 'Ignorer';

  static const String historyTitle = 'Historique';
  static const String complianceStats = 'Observance ce mois-ci';

  // -- Pillar 3: Symptoms [cite: 148] --
  static const String symptomsTitle = 'Suivi des Symptômes';
  static const String temp = 'Température';
  static const String pain = 'Douleur (1-10)';
  static const String bloodPressure = 'Tension';
  static const String glucose = 'Glycémie';
  static const String mood = 'Humeur';

  // -- Pillar 4: Documents [cite: 140] --
  static const String documentsTitle = 'Mes Documents';
  static const String docTypePrescription = 'Ordonnance';
  static const String docTypeAnalysis = 'Analyse';
  static const String docTypeRadio = 'Imagerie / Radio';

  // -- Common Actions --
  static const String save = 'Enregistrer';
  static const String cancel = 'Annuler';
  static const String delete = 'Supprimer';
  static const String edit = 'Modifier';
  static const String searchPlaceholder = 'Rechercher';
}
