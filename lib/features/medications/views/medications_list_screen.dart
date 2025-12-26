// lib/features/medications/views/medications_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/routes/route_names.dart';
import 'package:meditrack/shared/widgets/custom_app_bar.dart';
import 'package:meditrack/shared/widgets/loading_indicator.dart';
import 'package:meditrack/shared/widgets/empty_state_widget.dart';
import 'package:meditrack/shared/widgets/error_widget.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';
import 'package:meditrack/features/medications/viewmodels/medications_list_viewmodel.dart';
import '../views/widgets/medication_card.dart';

class MedicationsListScreen extends StatelessWidget {
  const MedicationsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.treatmentsTitle,
        actions: [
          // NOUVEAU: Barre de recherche
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: Consumer<MedicationsListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const LoadingIndicator();
          }

          if (viewModel.error != null) {
            return CustomErrorWidget(
              message: viewModel.error!,
              onRetry: viewModel.loadMedications,
            );
          }

          if (viewModel.medications.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.medication_outlined,
              title: 'Aucun médicament',
              message:
                  'Vous n\'avez pas encore ajouté de médicaments. Appuyez sur le bouton ci-dessous pour en ajouter un.',
            );
          }

          return Column(
            children: [
              // NOUVEAU: Champ de recherche
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher un médicament...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: viewModel
                      .searchMedications, // NOUVEAU: connecter la recherche
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: viewModel.loadMedications,
                  color: AppColors.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: viewModel.medications.length,
                    itemBuilder: (context, index) {
                      final medication = viewModel.medications[index];
                      return MedicationCard(
                        medication: medication,
                        onTap: () {
                          // TODO: Naviguer vers l'écran de détails
                          // context.pushNamed(AppRouteNames.medicationDetail, extra: medication);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRouteNames.addMedication),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textInverse),
      ),
    );
  }

  // NOUVEAU: Dialogue de recherche
  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rechercher un médicament'),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Entrez le nom du médicament...',
            ),
            onSubmitted: (value) {
              Navigator.of(context).pop();
              // TODO: Naviguer vers une page de résultats de recherche
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text('Annuler'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
