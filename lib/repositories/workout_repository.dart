import 'package:app/models/workout_session.dart';
import 'package:app/models/routine.dart';
import 'package:app/models/personal_record.dart';
import 'package:app/models/user_progress.dart';

abstract class WorkoutRepository {
  Future<void> saveWorkoutSession(WorkoutSession session);
  Future<List<WorkoutSession>> getWorkoutHistory(String userId);
  Future<void> saveRoutine(Routine routine);
  Future<List<Routine>> getRoutines(String userId);
  Future<List<PersonalRecord>> getPersonalRecords(String userId);
  Future<void> savePersonalRecord(String userId, PersonalRecord pr);
  Future<UserProgress?> getUserProgress(String userId);
  Future<void> saveUserProgress(UserProgress progress);
}
