import 'package:app/models/workout_session.dart';
import 'package:app/models/routine.dart';
import 'package:app/models/personal_record.dart';
import 'package:app/repositories/workout_repository.dart';

class MockWorkoutRepository implements WorkoutRepository {
  final List<WorkoutSession> _sessions = [];
  final List<Routine> _routines = [];
  final List<PersonalRecord> _prs = [];

  @override
  Future<void> saveWorkoutSession(WorkoutSession session) async {
    _sessions.add(session);
  }

  @override
  Future<List<WorkoutSession>> getWorkoutHistory(String userId) async {
    return _sessions;
  }

  @override
  Future<void> saveRoutine(Routine routine) async {
    _routines.add(routine);
  }

  @override
  Future<List<Routine>> getRoutines(String userId) async {
    return _routines;
  }

  @override
  Future<List<PersonalRecord>> getPersonalRecords(String userId) async {
    return _prs;
  }

  @override
  Future<void> savePersonalRecord(String userId, PersonalRecord pr) async {
    _prs.add(pr);
  }
}
