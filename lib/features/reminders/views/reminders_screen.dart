import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/app_providers.dart'; // Ensure providers are imported

class RemindersScreen extends ConsumerWidget {
  final String medicationId;

  const RemindersScreen({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the family provider with the medicationId
    final state = ref.watch(remindersViewModelProvider(medicationId));
    final vm = ref.read(remindersViewModelProvider(medicationId).notifier);

    final mainGradient = LinearGradient(
      colors: [const Color(0xFF42A5F5), const Color(0xFF66BB6A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mes Rappels",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: mainGradient),
        ),
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Show loader if busy
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.reminders.length,
              itemBuilder: (context, index) {
                final reminder = state.reminders[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.alarm, color: Color(0xFF42A5F5)),
                    title: Text(
                      reminder.time,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text("Statut : ${reminder.status.name}"),
                    trailing: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF66BB6A),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF66BB6A),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () =>
            vm.addNewReminder("08:00"), // Call logic through notifier
      ),
    );
  }
}
