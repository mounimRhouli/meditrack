import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; //
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/core/constants/app_dimensions.dart';
import 'package:meditrack/shared/widgets/custom_app_bar.dart';
import 'package:meditrack/shared/widgets/custom_button.dart';
import 'package:meditrack/shared/widgets/custom_text_field.dart';
import 'package:meditrack/shared/widgets/loading_indicator.dart';
import 'package:meditrack/shared/extensions/context_extensions.dart';
import 'package:meditrack/features/medications/models/medication.dart';
import 'package:meditrack/providers/app_providers.dart'; //
import './widgets/medication_form_selector.dart';
import './widgets/barcode_scan_button.dart';

// Use ConsumerStatefulWidget to handle initialization
class EditMedicationScreen extends ConsumerStatefulWidget {
  final Medication medication;

  const EditMedicationScreen({Key? key, required this.medication}) : super(key: key);

  @override
  ConsumerState<EditMedicationScreen> createState() => _EditMedicationScreenState();
}

class _EditMedicationScreenState extends ConsumerState<EditMedicationScreen> {
  
  @override
  void initState() {
    super.initState();
    // Pre-fill the ViewModel logic inside a post-frame callback
    Future.microtask(() {
      final viewModel = ref.read(medicationFormViewModelProvider);
      viewModel.updateName(widget.medication.name);
      viewModel.updateDosage(widget.medication.dosage);
      viewModel.updateForm(widget.medication.form);
      viewModel.updateInstructions(widget.medication.instructions);
      viewModel.updateStartDate(widget.medication.startDate);
      viewModel.updateEndDate(widget.medication.endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(medicationFormViewModelProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Modifier ${widget.medication.name}'),
      body: viewModel.isLoading
          ? const LoadingIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // NOTE: If CustomTextField lacks 'initialValue', use a controller or standard TextField
                  CustomTextField(
                    labelText: AppStrings.medicineName,
                    // Use the ViewModel's current name state
                    onChanged: viewModel.updateName,
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  CustomButton(
                    text: 'Mettre à jour',
                    onPressed: () async {
                      // Call the save logic which handles updates via 'ConflictAlgorithm.replace'
                      final success = await viewModel.saveMedication();
                      if (success) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}