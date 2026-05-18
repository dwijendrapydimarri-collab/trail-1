import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/repositories/workout_repository.dart';
import 'package:app/repositories/mock_workout_repository.dart';
import 'package:app/models/workout_session.dart';
import 'package:app/models/personal_record.dart';

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return MockWorkoutRepository();
});

final workoutHistoryProvider = FutureProvider.family<List<WorkoutSession>, String>((ref, userId) {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getWorkoutHistory(userId);
});

final routinesProvider = FutureProvider.family<List<Routine>, String>((ref, userId) {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getRoutines(userId);
});

final personalRecordsProvider = FutureProvider.family<List<PersonalRecord>, String>((ref, userId) {
  final repo = ref.watch(workoutRepositoryProvider);
  return repo.getPersonalRecords(userId);
});
