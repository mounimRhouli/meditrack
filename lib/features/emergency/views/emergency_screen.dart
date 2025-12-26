import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/emergency_viewmodel.dart';
import '../models/emergency_info.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = context.read<AuthViewModel>().user;
      if (user != null)
        context.read<EmergencyViewModel>().loadEmergencyInfo(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.emergencyTitle),
        backgroundColor: AppColors.error,
      ),
      body: Consumer<EmergencyViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading)
            return const Center(child: CircularProgressIndicator());
          final info = viewModel.info;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.phone_in_talk, size: 32),
                    label: const Text(
                      AppStrings.callAmbulance,
                      style: AppTextStyles.h2,
                    ),
                    onPressed: () => viewModel.callAmbulance(),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLarge),

                Text(
                  AppStrings.medicalId,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.error, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          AppStrings.bloodType,
                          info?.bloodType ?? "N/A",
                        ),
                        const Divider(),
                        _buildInfoRow(
                          AppStrings.allergies,
                          info?.medicalNotes ?? "None",
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          AppStrings.showToFirstResponders,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingLarge),

                Text(
                  AppStrings.emergencyContacts,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (info == null || info.contacts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      AppStrings.noContacts,
                      style: AppTextStyles.bodyMd,
                    ),
                  )
                else
                  ...info.contacts.map(
                    (c) => Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.error.withOpacity(0.1),
                          child: Text(c.name[0]),
                        ),
                        title: Text(c.name, style: AppTextStyles.h3),
                        subtitle: Text("${c.relationship} • ${c.phoneNumber}"),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.call,
                            color: AppColors.success,
                          ),
                          onPressed: () => viewModel.callNumber(c.phoneNumber),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySm),
        Text(value, style: AppTextStyles.h2),
      ],
    );
  }
}
