class SyncQueueItem {
  final String id;
  final String operation;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  bool isSyncing = false;

  SyncQueueItem({
    required this.id,
    required this.operation,
    required this.data,
    required this.createdAt,
  });
}

class ConflictResolver {
  Map<String, dynamic> resolve(
    Map<String, dynamic> local,
    Map<String, dynamic> remote,
  ) {
    // Simple Last-Write-Wins strategy based on updated_at timestamp
    final localTime = local['updated_at'] as DateTime?;
    final remoteTime = remote['updated_at'] as DateTime?;

    if (localTime == null) return remote;
    if (remoteTime == null) return local;

    return localTime.isAfter(remoteTime) ? local : remote;
  }
}
