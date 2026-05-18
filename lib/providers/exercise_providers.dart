import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/exercise.dart';
import 'package:app/repositories/exercise_service.dart';

final exerciseServiceProvider = Provider((ref) => ExerciseService());

final exercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final service = ref.watch(exerciseServiceProvider);
  return await service.loadExercises();
});
