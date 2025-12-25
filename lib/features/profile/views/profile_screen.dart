import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/viewmodels/auth_viewmodel.dart';
import '../../profile/viewmodels/profile_viewmodel.dart';

// Widgets
import 'widgets/profile_info_card.dart';
import 'widgets/allergy_list_item.dart';
import 'widgets/sync_settings_card.dart';
import '../../../../routes/route_names.dart'; // Assumed from Dev C

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Architect's Note: Fetch data as soon as screen loads.
    // We use Microtask to safely access Provider in initState.
    Future.microtask(() {
      final user = context.read<AuthViewModel>().user;
      if (user != null) {
        context.read<ProfileViewModel>().loadProfile(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get Auth User for Name/Email
    final authUser = context.select((AuthViewModel vm) => vm.user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to Edit Screen (Next Step)
              Navigator.pushNamed(context, AppRouteNames.editProfile);
            },
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          // A. Loading State
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // B. Error State
          if (viewModel.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(viewModel.errorMessage ?? 'Error loading profile'),
                  TextButton(
                    onPressed: () => viewModel.loadProfile(authUser?.id ?? ''),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final profile = viewModel.profile;

          // C. Loaded State
          return RefreshIndicator(
            onRefresh: () async {
              await viewModel.loadProfile(authUser?.id ?? '');
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. User Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade100,
                          backgroundImage: authUser?.photoUrl != null
                              ? NetworkImage(authUser!.photoUrl!)
                              : null,
                          child: authUser?.photoUrl == null
                              ? Text(
                                  authUser?.name?[0].toUpperCase() ?? 'U',
                                  style: const TextStyle(fontSize: 32),
                                )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          authUser?.name ?? 'Unknown User',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          authUser?.email ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Sync Status (Hybrid Architecture Feature)
                  SyncSettingsCard(
                    isSynced: profile?.isSynced ?? true,
                    onSyncPressed: () {
                      // Trigger a save to force sync retry
                      // In real app, call a specific sync method
                      viewModel.updateBasicInfo();
                    },
                  ),
                  const SizedBox(height: 24),

                  // 3. Vitals Card
                  Text('Vitals', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ProfileInfoCard(
                    bloodType: profile?.bloodType,
                    height: profile?.height,
                    weight: profile?.weight,
                  ),
                  const SizedBox(height: 24),

                  // 4. Allergies List
                  _buildSectionHeader(context, 'Allergies'),
                  if (profile?.allergies.isEmpty ?? true)
                    const Text(
                      'No allergies recorded.',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ...profile!.allergies.map(
                      (allergy) => AllergyListItem(allergy: allergy),
                    ),

                  const SizedBox(height: 24),

                  // 5. Chronic Diseases List
                  _buildSectionHeader(context, 'Chronic Conditions'),
                  if (profile?.chronicDiseases.isEmpty ?? true)
                    const Text(
                      'No chronic conditions recorded.',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    ...profile!.chronicDiseases.map(
                      (disease) => Card(
                        child: ListTile(
                          title: Text(disease.name),
                          subtitle: Text(
                            "Diagnosed: ${disease.diagnosedDate ?? 'Unknown'}",
                          ),
                          leading: const Icon(Icons.medical_services_outlined),
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

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
