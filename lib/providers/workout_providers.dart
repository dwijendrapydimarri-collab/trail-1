import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/repositories/workout_repository.dart';
import 'package:app/repositories/mock_workout_repository.dart';
import 'package:app/models/routine.dart';
import 'package:app/models/workout_session.dart';
import 'package:app/models/personal_record.dart';
import 'package:app/models/advanced/event_sourcing.dart';

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return MockWorkoutRepository();
});

final workoutHistoryProvider =
    FutureProvider.family<List<WorkoutSession>, String>((ref, userId) {
      final repo = ref.watch(workoutRepositoryProvider);
      return repo.getWorkoutHistory(userId);
    });

final routinesProvider = FutureProvider.family<List<Routine>, String>((
  ref,
  userId,
) {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getRoutines(userId);
});

final personalRecordsProvider =
    FutureProvider.family<List<PersonalRecord>, String>((ref, userId) {
      final repo = ref.watch(workoutRepositoryProvider);
      return repo.getPersonalRecords(userId);
    });

final eventStoreProvider = Provider<WorkoutEventStore>((ref) {
  return WorkoutEventStore();
});

class ActiveSessionNotifier extends StateNotifier<WorkoutSession?> {
  final WorkoutEventStore _store;
  final String _sessionId;
  final WorkoutSessionProjector _projector = WorkoutSessionProjector();

  ActiveSessionNotifier(this._store, this._sessionId) : super(null) {
    _updateState();
  }

  void _updateState() {
    final events = _store.getEventsForSession(_sessionId);
    state = _projector.project(events);
  }

  void dispatch(WorkoutEvent event) {
    _store.append(event);
    _updateState();
  }
}

final activeSessionProvider =
    StateNotifierProvider.family<
      ActiveSessionNotifier,
      WorkoutSession?,
      String
    >((ref, sessionId) {
      final store = ref.watch(eventStoreProvider);
      return ActiveSessionNotifier(store, sessionId);
    });
