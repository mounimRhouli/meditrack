import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../routes/route_names.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/symptoms_viewmodel.dart';
import '../models/symptom_entry.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({Key? key}) : super(key: key);

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = context.read<AuthViewModel>().user;
      if (user != null) context.read<SymptomsViewModel>().loadSymptoms(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.symptomsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () =>
                Navigator.pushNamed(context, AppRouteNames.symptomCharts),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouteNames.addSymptom),
        child: const Icon(Icons.add),
      ),
      body: Consumer<SymptomsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (viewModel.symptoms.isEmpty)
            return const Center(child: Text("Aucun historique."));

          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            itemCount: viewModel.symptoms.length,
            itemBuilder: (context, index) {
              final entry = viewModel.symptoms[index];
              final dateStr = DateFormat(
                'dd MMM • HH:mm',
              ).format(entry.timestamp);

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dateStr, style: AppTextStyles.bodySm),
                          if (!entry.isSynced)
                            const Icon(
                              Icons.cloud_off,
                              size: 16,
                              color: AppColors.warning,
                            ),
                        ],
                      ),
                      const Divider(),
                      if (entry.bloodPressure != null)
                        Text(
                          "${AppStrings.bloodPressure}: ${entry.bloodPressure!.systolic}/${entry.bloodPressure!.diastolic}",
                          style: AppTextStyles.bodyLg,
                        ),
                      if (entry.pain != null)
                        Text(
                          "${AppStrings.pain}: ${entry.pain!.value}/10",
                          style: AppTextStyles.bodyLg,
                        ),
                      if (entry.mood != null)
                        Text(
                          "${AppStrings.mood}: ${entry.mood!.value.name}",
                          style: AppTextStyles.bodyLg,
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
