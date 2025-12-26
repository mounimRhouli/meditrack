// lib/features/medications/views/edit_medication_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/core/constants/app_dimensions.dart';
import 'package:meditrack/shared/widgets/custom_app_bar.dart';
import 'package:meditrack/shared/widgets/custom_button.dart';
import 'package:meditrack/shared/widgets/custom_text_field.dart';
import 'package:meditrack/shared/widgets/loading_indicator.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';
import 'package:meditrack/features/medications/viewmodels/medication_form_viewmodel.dart';
import 'package:meditrack/features/medications/models/medication.dart';
import './widgets/medication_form_selector.dart';
import './widgets/barcode_scan_button.dart';

class EditMedicationScreen extends StatelessWidget {
  final Medication medication;

  const EditMedicationScreen({Key? key, required this.medication}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = MedicationFormViewModel(repository: DummyMedicationRepository());
        // Pré-remplir le ViewModel avec les données du médicament
        viewModel.updateName(medication.name);
        viewModel.updateDosage(medication.dosage);
        viewModel.updateForm(medication.form);
        viewModel.updateInstructions(medication.instructions);
        viewModel.updateStartDate(medication.startDate);
        viewModel.updateEndDate(medication.endDate);
        return viewModel;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'Modifier ${medication.name}'),
        body: Consumer<MedicationFormViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const LoadingIndicator();
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    labelText: AppStrings.medicineName,
                    initialValue: medication.name, // Pré-remplir
                    onChanged: viewModel.updateName,
                  ),
                  // ... Le reste du formulaire est identique à add_medication_screen.dart ...
                  const SizedBox(height: AppDimensions.paddingLarge),
                  CustomButton(
                    text: 'Mettre à jour',
                    onPressed: () async {
                      // TODO: Implémenter la logique de mise à jour dans le ViewModel
                      // final success = await viewModel.updateMedication(medication.id);
                      // if (success) { context.pop(); }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}