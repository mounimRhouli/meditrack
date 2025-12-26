// lib/features/medications/views/add_medication_screen.dart

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
import './widgets/medication_form_selector.dart';
import './widgets/barcode_scan_button.dart';

class AddMedicationScreen extends StatelessWidget {
  const AddMedicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedicationFormViewModel(repository: DummyMedicationRepository()),
      child: Scaffold(
        appBar: CustomAppBar(title: AppStrings.addMedicine),
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
                    onChanged: viewModel.updateName,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          labelText: AppStrings.medicineDosage,
                          keyboardType: TextInputType.number,
                          onChanged: (value) => viewModel.updateDosage(double.tryParse(value) ?? 0),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingSmall),
                      // TODO: Ajouter un dropdown pour l'unité de dosage
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.outline),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('mg', style: context.textTheme.bodyMedium),
                      )
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  MedicationFormSelector(
                    selectedForm: viewModel.form,
                    onFormChanged: viewModel.updateForm,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  CustomTextField(
                    labelText: 'Instructions',
                    onChanged: viewModel.updateInstructions,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  BarcodeScanButton(
                    onBarcodeScanned: viewModel.updateBarcode,
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  if (viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                      child: Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  CustomButton(
                    text: AppStrings.save,
                    onPressed: () async {
                      final success = await viewModel.saveMedication();
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Médicament enregistré avec succès!')),
                        );
                        context.pop();
                      }
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