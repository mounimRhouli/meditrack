// lib/shared/models/sync_status.dart

enum SyncStatus {
  synced,   // Data is up-to-date with the cloud
  syncing,  // Currently in the process of syncing
  error,    // An error occurred during the last sync
  offline,  // The device is offline, changes are queued
}