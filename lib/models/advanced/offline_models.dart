enum SyncStatus { localOnly, queued, syncing, synced, failed }

class SyncEvent {
  final String id;
  final String entityType; // 'WorkoutSession', 'Routine', 'PersonalRecord'
  final String entityId;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final SyncStatus status;

  SyncEvent({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.payload,
    required this.createdAt,
    this.status = SyncStatus.localOnly,
  });
}
