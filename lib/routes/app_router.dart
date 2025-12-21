// lib/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      path: AppRouteNames.home,
      builder: (context, state) => const PlaceholderScreen(
        title: 'Tableau de bord',
        subtitle: 'Bienvenue sur MediTrack!',
      ),
    ),
    GoRoute(
      path: AppRouteNames.profile,
      builder: (context, state) => const PlaceholderScreen(title: 'Profil'),
    ),
    GoRoute(
      path: AppRouteNames.medicationsList,
      builder: (context, state) => const PlaceholderScreen(title: 'Traitements'),
    ),
    GoRoute(
      path: AppRouteNames.reminders,
      builder: (context, state) => const PlaceholderScreen(title: 'Rappels'),
    ),
    GoRoute(
      path: AppRouteNames.history,
      builder: (context, state) => const PlaceholderScreen(title: 'Historique'),
    ),
    GoRoute(
      path: AppRouteNames.documents,
      builder: (context, state) => const PlaceholderScreen(title: 'Mes Documents'),
    ),
    GoRoute(
      path: AppRouteNames.symptoms,
      builder: (context, state) => const PlaceholderScreen(title: 'Suivi des Symptômes'),
    ),
    GoRoute(
      path: AppRouteNames.emergency,
      builder: (context, state) => const PlaceholderScreen(title: 'Mode Urgence'),
    ),
    GoRoute(
      path: AppRouteNames.chatbot,
      builder: (context, state) => const PlaceholderScreen(title: 'Assistant Santé'),
    ),
    GoRoute(
      path: AppRouteNames.syncSettings,
      builder: (context, state) => const PlaceholderScreen(title: 'Paramètres de Synchronisation'),
    ),
    // Add other routes as needed...
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: CustomAppBar(title: 'Erreur'),
    body: Center(
      child: Text('Page non trouvée: ${state.uri}'),
    ),
  ),
);