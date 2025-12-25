import 'package:flutter/material.dart';

class SyncSettingsCard extends StatelessWidget {
  final bool isSynced;
  final VoidCallback onSyncPressed;

  const SyncSettingsCard({
    Key? key,
    required this.isSynced,
    required this.onSyncPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSynced ? Colors.green.shade50 : Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSynced ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: ListTile(
        leading: Icon(
          isSynced ? Icons.cloud_done : Icons.cloud_off,
          color: isSynced ? Colors.green : Colors.orange,
        ),
        title: Text(
          isSynced ? "Profile Synced" : "Unsynced Changes",
          style: TextStyle(
            color: isSynced ? Colors.green.shade800 : Colors.orange.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          isSynced
              ? "Your medical data is backed up."
              : "Tap to force sync with cloud.",
          style: TextStyle(
            fontSize: 12,
            color: isSynced ? Colors.green.shade700 : Colors.orange.shade800,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onSyncPressed,
        ),
      ),
    );
  }
}
