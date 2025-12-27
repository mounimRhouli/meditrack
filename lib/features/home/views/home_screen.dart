// Dans lib/features/home/views/home_screen.dart

import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_dimensions.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/features/home/viewmodels/home_viewmodel.dart';
import 'package:meditrack/features/home/views/widgets/emergency_fab.dart';
import 'package:meditrack/features/home/views/widgets/next_medication_card.dart';
import 'package:meditrack/features/home/views/widgets/quick_stats_card.dart';
import 'package:meditrack/features/home/views/widgets/shortcut_button.dart';
import 'package:meditrack/routes/route_names.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';
import 'package:meditrack/shared/widgets/custom_app_bar.dart';
import 'package:meditrack/shared/widgets/error_widget.dart';
import 'package:meditrack/shared/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
// ... autres imports
import '../repositories/home_repository.dart'; // Importer la factory

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeRepository>(
      // --- MODIFICATION ICI ---
      future: createHomeRepository(), // Utiliser la factory asynchrone
      builder: (context, snapshot) {
        // 1. Afficher un indicateur de chargement pendant la création du repository
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: LoadingIndicator()),
          );
        }

        // 2. Afficher une erreur si la création échoue
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: CustomAppBar(title: AppStrings.dashboardTitle),
            body: CustomErrorWidget(
              message: 'Impossible d\'initialiser l\'application.',
              onRetry: () {
                // Forcer un rechargement complet de l'écran
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
          );
        }

        // 3. Une fois le repository prêt, créer le ViewModel et construire l'UI
        final homeRepo = snapshot.data!;
        return ChangeNotifierProvider(
          create: (_) => HomeViewModel(repository: homeRepo),
          child: Scaffold(
            appBar: CustomAppBar(title: AppStrings.dashboardTitle),
            body: Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                // ... Le reste du Consumer reste exactement le même ...
                if (viewModel.isLoading) {
                  return const LoadingIndicator();
                }
                if (viewModel.error != null) {
                  return CustomErrorWidget(
                    message: viewModel.error!,
                    onRetry: viewModel.loadDashboardData,
                  );
                }
                final data = viewModel.dashboardData;
                if (data == null) return const SizedBox.shrink();
                
                return RefreshIndicator(
                onRefresh: viewModel.loadDashboardData,
              color: AppColors.primary,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100), // Espace pour le FAB
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Prochain médicament
                    NextMedicationCard(
                      medication: data.nextMedication,
                      time: data.nextMedicationTime,
                      onTaken: () {
                        // TODO: Marquer comme pris
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Médicament marqué comme pris!')),
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Statistiques rapides
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
                      child: Row(
                        children: [
                          Expanded(
                            child: QuickStatsCard(
                              title: 'Total Médicaments',
                              value: data.totalMedications.toString(),
                              icon: Icons.medication,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.paddingMedium),
                          Expanded(
                            child: QuickStatsCard(
                              title: 'Rappels Actifs',
                              value: data.activeReminders.toString(),
                              icon: Icons.alarm,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),

                    // Raccourcis
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
                      child: Text('Raccourcis', style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: AppDimensions.paddingSmall),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: AppDimensions.paddingMedium,
                        crossAxisSpacing: AppDimensions.paddingMedium,
                        childAspectRatio: 1.2,
                        children: [
                          ShortcutButton(
                            icon: Icons.history,
                            label: AppStrings.historyTitle,
                            onTap: () => context.pushNamed(AppRouteNames.history),
                          ),
                          ShortcutButton(
                            icon: Icons.document_scanner,
                            label: AppStrings.documentsTitle,
                            onTap: () => context.pushNamed(AppRouteNames.documents),
                          ),
                          ShortcutButton(
                            icon: Icons.monitor_heart,
                            label: AppStrings.symptomsTitle,
                            onTap: () => context.pushNamed(AppRouteNames.symptoms),
                          ),
                          ShortcutButton(
                            icon: Icons.settings,
                            label: 'Paramètres',
                            onTap: () => context.pushNamed(AppRouteNames.profile),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
                
              },
            ),
            floatingActionButton: EmergencyFab(
              onPressed: () => context.pushNamed(AppRouteNames.emergency),
            ),
          ),
        );
      },
    );
  }
}