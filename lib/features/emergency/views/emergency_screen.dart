import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // Load data immediately
    Future.microtask(() {
      final user = context.read<AuthViewModel>().user;
      if (user != null) {
        context.read<EmergencyViewModel>().loadEmergencyInfo(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EMERGENCY MODE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Emergency Info',
            onPressed: () {
              // Navigation to Edit Screen would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Edit feature would open here.")),
              );
            },
          ),
        ],
      ),
      body: Consumer<EmergencyViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.status == EmergencyStatus.error) {
            return Center(
              child: Text(viewModel.errorMessage ?? 'Error loading info'),
            );
          }

          final info = viewModel.info;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. THE BIG RED BUTTON
                SizedBox(
                  height: 60,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.phone_in_talk, size: 32),
                    label: const Text(
                      "CALL AMBULANCE (911)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => viewModel.callAmbulance(),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Medical ID Card
                _buildSectionTitle(context, "Medical ID"),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.shade100, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          "Blood Type",
                          info?.bloodType ?? "Unknown",
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(
                          "Allergies / Notes",
                          info?.medicalNotes ?? "None recorded",
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Show this screen to first responders.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Emergency Contacts
                _buildSectionTitle(context, "Emergency Contacts"),
                if (info == null || info.contacts.isEmpty)
                  _buildEmptyState()
                else
                  ...info.contacts.map(
                    (contact) => _buildContactTile(context, viewModel, contact),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildContactTile(
    BuildContext context,
    EmergencyViewModel vm,
    EmergencyContact contact,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade50,
          child: Text(
            contact.name[0].toUpperCase(),
            style: TextStyle(
              color: Colors.red.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${contact.relationship} • ${contact.phoneNumber}"),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.green),
          iconSize: 32,
          onPressed: () => vm.callNumber(contact.phoneNumber),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: BorderStyle.solid == BorderStyle.solid
            ? Border.all(color: Colors.grey.shade300)
            : null,
      ),
      child: const Column(
        children: [
          Icon(Icons.person_off, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            "No emergency contacts set.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
