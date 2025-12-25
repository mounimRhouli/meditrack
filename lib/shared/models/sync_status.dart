// lib/shared/models/sync_status.dart

enum SyncStatus {
  /// Data exists only locally and is waiting to be sent to the cloud.
  pending,

  /// Data is currently being uploaded/downloaded.
  syncing,

  /// Data is successfully backed up and matches the cloud.
  synced,

  /// The last sync attempt failed (e.g., timeout or server error).
  error;

  // --- Helpers to make your code cleaner ---

  /// Use this to show a "Sync Required" icon in the UI.
  bool get needsSync => this == SyncStatus.pending || this == SyncStatus.error;

  /// Use this to disable "Edit" buttons while a sync is in progress.
  bool get isBusy => this == SyncStatus.syncing;
}
