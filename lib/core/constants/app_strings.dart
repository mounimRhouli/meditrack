class AppStrings {
  AppStrings._();

  // -- General --
  static const String appName = 'MediTrack';
  static const String welcomeMessage =
      'Bienvenue'; // Changed to French to match your other strings
  static const String welcomeBack = 'De retour ?';
  static const String dashboardTitle = 'Tableau de bord';

  // -- Auth --
  static const String signIn = 'Se connecter';
  static const String register = "S'inscrire";
  static const String email = 'Email';
  static const String password = 'Mot de passe';
  static const String dontHaveAccount = "Pas encore de compte ?";
  static const String alreadyHaveAccount = "Déjà un compte ?";
  static const String joinMessage = "Rejoignez MediTrack";
  static const String joinSubtitle = "Votre santé, votre priorité.";
  static const String googleLogin = "Continuer avec Google";
  static const String appleLogin = "Continuer avec Apple";

  // -- Pillar 1: Profile & Treatments --
  static const String profileTitle = 'Profil Médical';
  static const String basicInfo = 'Infos de base';
  static const String age = 'Âge';
  static const String height = 'Taille';
  static const String weight = 'Poids';
  static const String allergies = 'Allergies';
  static const String chronicDiseases = 'Maladies Chroniques';
  static const String editProfile = 'Modifier le profil';

  // -- Pillar 3: Symptoms --
  static const String symptomsTitle = 'Suivi Santé';
  static const String addSymptom = 'Nouveau relevé';
  static const String saveEntry = 'Enregistrer';
  static const String bloodPressure = 'Tension Artérielle';
  static const String painLevel = 'Douleur';
  static const String mood = 'Humeur';
  static const String notes = 'Notes / Remarques';
  static const String sys = 'SYS';
  static const String dia = 'DIA';

  // -- Emergency --
  static const String emergencyTitle = 'MODE URGENCE';
  static const String callAmbulance =
      'APPELER SECOURS (15)'; // 15 is standard in Morocco/France, or 112
  static const String medicalId = 'Identité Médicale';
  static const String emergencyContacts = 'Contacts d\'urgence';
  static const String noContacts = 'Aucun contact défini';

  // -- Common Actions --
  static const String save = 'Enregistrer';
  static const String cancel = 'Annuler';
  static const String delete = 'Supprimer';
  static const String edit = 'Modifier';
  static const String searchPlaceholder = 'Rechercher';
  static const String retry = 'Réessayer';
  static const String loading = 'Chargement...';
}
