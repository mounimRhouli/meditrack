import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // You might need to add 'intl' to pubspec.yaml

import '../../auth/viewmodels/auth_viewmodel.dart';
import '../viewmodels/symptoms_viewmodel.dart';
import '../models/symptom_entry.dart';
import '../../../../routes/route_names.dart'; // Assumed

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({Key? key}) : super(key: key);

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data on load
    Future.microtask(() {
      final user = context.read<AuthViewModel>().user;
      if (user != null) {
        context.read<SymptomsViewModel>().loadSymptoms(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthViewModel vm) => vm.user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Log'),
        actions: [
          // Navigation to Charts
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'View Trends',
            onPressed: () {
              Navigator.pushNamed(context, AppRouteNames.symptomCharts);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRouteNames.addSymptom);
        },
        icon: const Icon(Icons.add),
        label: const Text('Check-in'),
      ),
      body: Consumer<SymptomsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.status == SymptomStatus.error) {
            return Center(
              child: Text(viewModel.errorMessage ?? 'Error loading data'),
            );
          }

          if (viewModel.symptoms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history_edu, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No symptoms logged yet.'),
                  TextButton(
                    onPressed: () => viewModel.loadSymptoms(user?.id ?? ''),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.loadSymptoms(user?.id ?? ''),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.symptoms.length,
              itemBuilder: (context, index) {
                final entry = viewModel.symptoms[index];
                return _SymptomCard(entry: entry);
              },
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// INTERNAL WIDGET: Smart Card to display dynamic content
// -----------------------------------------------------------------------------
class _SymptomCard extends StatelessWidget {
  final SymptomEntry entry;

  const _SymptomCard({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Format Date: "Mon, Dec 26 • 10:30 AM"
    final dateStr = DateFormat('EEE, MMM d • h:mm a').format(entry.timestamp);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Date & Sync Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                if (!entry.isSynced)
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 16,
                    color: Colors.orange,
                  ),
              ],
            ),
            const Divider(),

            // Content Rows (Only show what exists)
            if (entry.bloodPressure != null)
              _buildRow(
                Icons.favorite,
                "Blood Pressure",
                "${entry.bloodPressure!.systolic}/${entry.bloodPressure!.diastolic}",
                Colors.red,
              ),

            if (entry.pain != null)
              _buildRow(
                Icons.healing,
                "Pain Level",
                "${entry.pain!.value}/10 ${entry.pain!.location != null ? '(${entry.pain!.location})' : ''}",
                Colors.orange,
              ),

            if (entry.mood != null)
              _buildRow(
                Icons.mood,
                "Mood",
                entry.mood!.value.name.toUpperCase(),
                Colors.blue,
              ),

            if (entry.note != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Note: ${entry.note}",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
