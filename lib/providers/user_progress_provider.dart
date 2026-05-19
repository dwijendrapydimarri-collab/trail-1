import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/user_progress.dart';
import 'package:app/providers/workout_providers.dart';

final userProgressProvider = FutureProvider.family<UserProgress, String>((
  ref,
  userId,
) async {
  final repo = ref.watch(workoutRepositoryProvider);
  final progress = await repo.getUserProgress(userId);
  return progress ?? UserProgress(userId: userId);
});
