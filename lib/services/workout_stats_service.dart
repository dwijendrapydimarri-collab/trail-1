import 'package:app/models/workout_session.dart';

class WorkoutStatsService {
  WorkoutSession calculateSessionStats(WorkoutSession session) {
    double totalVolume = 0.0;
    int totalSets = 0;
    Map<String, double> muscleGroupVolumes = {};

    for (final exercise in session.routine.exercises) {
      double exerciseVolume = 0;
      int completedSets = 0;

      for (final set in exercise.sets) {
        if (set.isCompleted) {
          final setVolume = set.weight * set.reps;
          exerciseVolume += setVolume;
          completedSets += 1;
        }
      }

      if (completedSets > 0) {
        totalVolume += exerciseVolume;
        totalSets += completedSets;

        final muscle = exercise.exercise.muscleGroup;
        muscleGroupVolumes[muscle] =
            (muscleGroupVolumes[muscle] ?? 0.0) + exerciseVolume;
      }
    }

    // XP Calculation base logic: 10 XP per set + 1 XP per 1000kg volume
    final xpEarned = (totalSets * 10) + (totalVolume / 1000).floor();

    return session.copyWith(
      totalVolume: totalVolume,
      totalSets: totalSets,
      muscleGroupVolumes: muscleGroupVolumes,
      xpEarned: xpEarned,
      endTime: session.endTime ?? DateTime.now(),
    );
  }
}
