import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; //
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/routes/route_names.dart';
import 'package:meditrack/shared/widgets/custom_app_bar.dart';
import 'package:meditrack/shared/widgets/loading_indicator.dart';
import 'package:meditrack/shared/widgets/empty_state_widget.dart';
import 'package:meditrack/shared/widgets/error_widget.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';
import 'package:meditrack/providers/app_providers.dart'; //
import '../views/widgets/medication_card.dart';

// Change to ConsumerWidget for Riverpod
class MedicationsListScreen extends ConsumerWidget {
  const MedicationsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the real ViewModel provider
    final viewModel = ref.watch(medicationsListViewModelProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.treatmentsTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, ref),
          ),
        ],
      ),
      body: Builder(builder: (context) {
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
          return const EmptyStateWidget(
            icon: Icons.medication_outlined,
            title: 'Aucun médicament',
            message: 'Vous n\'avez pas encore ajouté de médicaments.',
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Rechercher un médicament...',
                  prefixIcon: Icon(Icons.search),
                ),
                // This will work after adding the method to the ViewModel below
                onChanged: viewModel.searchMedications, 
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
                        context.pushNamed(
                          AppRouteNames.medicationDetail,
                          extra: medication,
                        );
                        // Navigate to detail using standard go_router context
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRouteNames.addMedication),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textInverse),
      ),
    );
  }

  void _showSearchDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechercher un médicament'),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Entrez le nom du médicament...',
            ),
            onSubmitted: (value) {
              ref.read(medicationsListViewModelProvider).searchMedications(value);
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}