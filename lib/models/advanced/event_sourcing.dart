
abstract class WorkoutEvent {
  final String id;
  final DateTime timestamp;
  final String type;
  final Map<String, dynamic> payload;

  WorkoutEvent({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.payload,
  });
}

class WorkoutStartedEvent extends WorkoutEvent {
  WorkoutStartedEvent({required super.id, required super.timestamp, required super.payload})
    : super(type: 'WORKOUT_STARTED');
}

class SetLoggedEvent extends WorkoutEvent {
  SetLoggedEvent({required super.id, required super.timestamp, required super.payload})
    : super(type: 'SET_LOGGED');
}

class WorkoutFinishedEvent extends WorkoutEvent {
  WorkoutFinishedEvent({required super.id, required super.timestamp, required super.payload})
    : super(type: 'WORKOUT_FINISHED');
}

class WorkoutSessionProjector {
  Map<String, dynamic> project(List<WorkoutEvent> events) {
    var state = <String, dynamic>{};
    for (var event in events) {
      if (event is WorkoutStartedEvent) {
        state['startTime'] = event.timestamp;
        state['routineId'] = event.payload['routineId'];
      } else if (event is SetLoggedEvent) {
        state['sets'] ??= [];
        state['sets'].add(event.payload);
      } else if (event is WorkoutFinishedEvent) {
        state['endTime'] = event.timestamp;
      }
    }
    return state;
  }
}

class WorkoutEventStore {
  final List<WorkoutEvent> _events = [];

  void append(WorkoutEvent event) {
    _events.add(event);
  }

  List<WorkoutEvent> getEventsForSession(String sessionId) {
    return _events.where((e) => e.payload['sessionId'] == sessionId).toList();
  }
}
