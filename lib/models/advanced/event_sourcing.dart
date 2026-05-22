import 'package:app/models/workout_session.dart';
import 'package:app/models/set_log.dart';

abstract class WorkoutEvent {
  final String id;
  final String sessionId;
  final DateTime timestamp;
  final String type;
  final Map<String, dynamic> payload;

  WorkoutEvent({
    required this.id,
    required this.sessionId,
    required this.timestamp,
    required this.type,
    required this.payload,
  });
}

class WorkoutStartedEvent extends WorkoutEvent {
  WorkoutStartedEvent({
    required super.id,
    required super.sessionId,
    required super.timestamp,
    required super.payload,
  }) : super(type: 'WORKOUT_STARTED');
}

class SetLoggedEvent extends WorkoutEvent {
  SetLoggedEvent({
    required super.id,
    required super.sessionId,
    required super.timestamp,
    required super.payload,
  }) : super(type: 'SET_LOGGED');
}

class SetUpdatedEvent extends WorkoutEvent {
  SetUpdatedEvent({
    required super.id,
    required super.sessionId,
    required super.timestamp,
    required super.payload,
  }) : super(type: 'SET_UPDATED');
}

class SetDeletedEvent extends WorkoutEvent {
  SetDeletedEvent({
    required super.id,
    required super.sessionId,
    required super.timestamp,
    required super.payload,
  }) : super(type: 'SET_DELETED');
}

class WorkoutFinishedEvent extends WorkoutEvent {
  WorkoutFinishedEvent({
    required super.id,
    required super.sessionId,
    required super.timestamp,
    required super.payload,
  }) : super(type: 'WORKOUT_FINISHED');
}

class WorkoutSessionProjector {
  WorkoutSession? project(List<WorkoutEvent> events) {
    if (events.isEmpty) return null;

    String? id;
    DateTime? startTime;
    DateTime? endTime;
    String routineId = '';
    String routineName = '';
    List<SetLog> sets = [];
    int xpEarned = 0;

    for (var event in events) {
      if (event is WorkoutStartedEvent) {
        id = event.sessionId;
        startTime = event.timestamp;
        routineId = event.payload['routineId'] ?? '';
        routineName = event.payload['routineName'] ?? 'Custom Workout';
      } else if (event is SetLoggedEvent) {
        sets.add(
          SetLog(
            id: event.payload['setId'],
            exerciseId: event.payload['exerciseId'],
            weight: (event.payload['weight'] as num?)?.toDouble() ?? 0.0,
            reps: event.payload['reps'] ?? 0,
            isCompleted: true,
          ),
        );
      } else if (event is SetUpdatedEvent) {
        final setId = event.payload['setId'];
        final index = sets.indexWhere((s) => s.id == setId);
        if (index != -1) {
          sets[index] = SetLog(
            id: setId,
            exerciseId: sets[index].exerciseId,
            weight:
                (event.payload['weight'] as num?)?.toDouble() ??
                sets[index].weight,
            reps: event.payload['reps'] ?? sets[index].reps,
            isCompleted:
                event.payload['isCompleted'] ?? sets[index].isCompleted,
          );
        }
      } else if (event is SetDeletedEvent) {
        final setId = event.payload['setId'];
        sets.removeWhere((s) => s.id == setId);
      } else if (event is WorkoutFinishedEvent) {
        endTime = event.timestamp;
        xpEarned = event.payload['xpEarned'] ?? 0;
      }
    }

    if (id == null) return null;

    return WorkoutSession(
      id: id,
      routineId: routineId,
      routineName: routineName,
      startTime: startTime ?? events.first.timestamp,
      endTime: endTime,
      sets: sets,
      xpEarned: xpEarned,
    );
  }
}

class WorkoutEventStore {
  final List<WorkoutEvent> _events = [];

  void append(WorkoutEvent event) {
    _events.add(event);
  }

  List<WorkoutEvent> getEventsForSession(String sessionId) {
    return _events.where((e) => e.sessionId == sessionId).toList();
  }

  List<WorkoutEvent> get allEvents => List.unmodifiable(_events);
}
