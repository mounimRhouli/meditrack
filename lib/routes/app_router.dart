// lib/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/features/auth/views/login_screen.dart';
import 'package:meditrack/features/home/views/home_screen.dart';
import 'package:meditrack/features/profile/views/profile_screen.dart';
import '../shared/widgets/custom_app_bar.dart';
import 'route_names.dart';
import 'route_guards.dart';

// A more polished placeholder widget
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  const PlaceholderScreen({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final appRouter = GoRouter(
  initialLocation: AppRouteNames.home,
  redirect: (context, state) => authGuard(context, state),
  routes: [
    
    GoRoute(
      path: AppRouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRouteNames.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRouteNames.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRouteNames.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRouteNames.medicationsList,
      builder: (context, state) => const MedicationsListScreen(),
    ),
    GoRoute(
      path: AppRouteNames.addMedication,
      builder: (context, state) => const AddMedicationScreen(),
    ),
    GoRoute(
      path: AppRouteNames.editMedication,
      builder: (context, state) => const EditMedicationScreen()
    ),
    GoRoute(
      path: AppRouteNames.medicationDetail,
      builder: (context, state) => const MedicationDetailScreen(),
    ),
    GoRoute(
      path: AppRouteNames.barcodeScanner,
      builder: (context, state) => const BarcodeScannerScreen(),
    ),
    GoRoute(
      path: AppRouteNames.reminders,
      builder: (context, state) => const RemindersScreen(),
    ),
    GoRoute(
      path: AppRouteNames.history,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: AppRouteNames.historyCalendar,
      builder: (context, state) => const HistoryCalendarScreen(),
    ),
    GoRoute(
      path: AppRouteNames.historyStats,
      builder: (context, state) => const HistoryStatsScreen()
    ),
    GoRoute(
      path: AppRouteNames.documents,
      builder: (context, state) => const DocumentsScreen(),
    ),
    GoRoute(
      path: AppRouteNames.addDocument,
      builder: (context, state) => const AddDocumentScreen(),
    ),
    GoRoute(
      path: AppRouteNames.documentDetail,
      builder: (context, state) => const DocumentDetailScreen()
    ),
    GoRoute(
      path: AppRouteNames.ocrPreview,
      builder: (context, state) => const OcrPreviewScreen(),
    ),
    GoRoute(
      path: AppRouteNames.symptoms,
      builder: (context, state) => const SymptomsScreen(),
    ),
    GoRoute(
      path: AppRouteNames.addSymptom,
      builder: (context, state) => const AddSymptomScreen(),
    ),
    GoRoute(
      path: AppRouteNames.symptomCharts,
      builder: (context, state) => const SymptomChartsScreen(),
    ),
    GoRoute(
      path: AppRouteNames.emergency,
      builder: (context, state) => const EmergencyScreen(), 
    ),
    GoRoute(
      path: AppRouteNames.chatbot,
      builder: (context, state) => const ChatbotScreen(),
    ),
    GoRoute(
      path: AppRouteNames.syncSettings,
      builder: (context, state) => const SyncSettingsScreen(),
    ),
    // Add other routes as needed...
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: const CustomAppBar(title: 'Erreur'),
    body: Center(
      child: Text('Page non trouvée: ${state.uri}'),
    ),
  ),
);