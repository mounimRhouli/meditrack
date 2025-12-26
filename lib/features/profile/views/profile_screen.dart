import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../profile/viewmodels/profile_viewmodel.dart';

import 'widgets/profile_info_card.dart';
import 'widgets/allergy_list_item.dart';
import 'widgets/sync_settings_card.dart';
import '../../../../routes/route_names.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: AppStrings.editProfile,
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
                style: TextStyle(color: theme.colorScheme.error),
              ),
            );
          }

          final profile = viewModel.profile;

          return RefreshIndicator(
            onRefresh: () async =>
                await viewModel.loadProfile(authUser?.id ?? ''),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.colorScheme.secondary
                              .withOpacity(0.2),
                          backgroundImage: authUser?.photoUrl != null
                              ? NetworkImage(authUser!.photoUrl!)
                              : null,
                          child: authUser?.photoUrl == null
                              ? Text(
                                  authUser?.name?[0].toUpperCase() ?? 'U',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: theme.colorScheme.primary,
                                      ),
                                )
                              : null,
                        ),
                        const SizedBox(height: AppDimensions.paddingSmall),
                        Text(
                          authUser?.name ?? 'Utilisateur',
                          style: theme.textTheme.titleLarge,
                        ),
                        Text(
                          authUser?.email ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),

                  // Sync Card
                  SyncSettingsCard(
                    isSynced: profile?.isSynced ?? true,
                    onSyncPressed: () => viewModel.updateBasicInfo(),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),

                  // Vitals
                  Text(
                    AppStrings.basicInfo,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  ProfileInfoCard(
                    bloodType: profile?.bloodType,
                    height: profile?.height,
                    weight: profile?.weight,
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),

                  // Allergies
                  Text(
                    AppStrings.allergies,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  if (profile?.allergies.isEmpty ?? true)
                    const Text(
                      'Aucune allergie enregistrée.',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ...profile!.allergies.map(
                      (a) => AllergyListItem(allergy: a),
                    ),

                  const SizedBox(height: AppDimensions.paddingLarge),

                  // Diseases
                  Text(
                    AppStrings.chronicDiseases,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  if (profile?.chronicDiseases.isEmpty ?? true)
                    const Text(
                      'Aucune maladie enregistrée.',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ...profile!.chronicDiseases.map(
                      (d) => Card(
                        child: ListTile(
                          title: Text(d.name),
                          leading: Icon(
                            Icons.medical_services_outlined,
                            color: theme.colorScheme.primary,
                          ),
                        ),
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
