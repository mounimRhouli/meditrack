import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../routes/route_names.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';

import 'widgets/profile_info_card.dart';
import 'widgets/allergy_list_item.dart';
import 'widgets/disease_list_item.dart'; // Import the new widget
import 'widgets/sync_settings_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = context.read<AuthViewModel>().user;
      if (user != null) {
        context.read<ProfileViewModel>().loadProfile(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authUser = context.select((AuthViewModel vm) => vm.user);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                Navigator.pushNamed(context, AppRouteNames.editProfile),
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.isError) {
            return Center(
              child: Text(
                viewModel.errorMessage ?? 'Error',
                style: AppTextStyles.bodyMd,
              ),
            );
          }

          final profile = viewModel.profile;

          return RefreshIndicator(
            onRefresh: () async =>
                await viewModel.loadProfile(authUser?.id ?? ''),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          backgroundImage: authUser?.photoUrl != null
                              ? NetworkImage(authUser!.photoUrl!)
                              : null,
                          child: authUser?.photoUrl == null
                              ? Text(
                                  authUser?.name?[0].toUpperCase() ?? 'U',
                                  style: AppTextStyles.h1,
                                )
                              : null,
                        ),
                        const SizedBox(height: AppDimensions.paddingSmall),
                        Text(
                          authUser?.name ?? 'Utilisateur',
                          style: AppTextStyles.h2,
                        ),
                        Text(
                          authUser?.email ?? '',
                          style: AppTextStyles.bodyMd,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),

                  // Sync Status
                  SyncSettingsCard(
                    isSynced: profile?.isSynced ?? true,
                    onSyncPressed: () => viewModel.updateBasicInfo(),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),

                  // Vitals
                  Text(AppStrings.basicInfo, style: AppTextStyles.h2),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  ProfileInfoCard(
                    bloodType: profile?.bloodType,
                    height: profile?.height,
                    weight: profile?.weight,
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),

                  // Allergies
                  Text(AppStrings.allergies, style: AppTextStyles.h2),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  if (profile?.allergies.isEmpty ?? true)
                    const Text(
                      AppStrings.noAllergies,
                      style: AppTextStyles.bodyMd,
                    )
                  else
                    ...profile!.allergies.map(
                      (a) => AllergyListItem(allergy: a.name),
                    ),

                  const SizedBox(height: AppDimensions.paddingLarge),

                  // Diseases
                  Text(AppStrings.chronicDiseases, style: AppTextStyles.h2),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  if (profile?.chronicDiseases.isEmpty ?? true)
                    const Text(
                      AppStrings.noDiseases,
                      style: AppTextStyles.bodyMd,
                    )
                  else
                    ...profile!.chronicDiseases.map(
                      (d) => DiseaseListItem(
                        diseaseName: d.name,
                        diagnosedDate: d.diagnosedDate,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
