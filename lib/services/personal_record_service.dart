import 'package:app/models/personal_record.dart';
import 'package:app/models/routine.dart';
import 'package:app/models/workout_session.dart';

class PersonalRecordService {
  double calculateEpley1RM(double weight, int reps) {
    if (reps == 0) return 0;
    if (reps == 1) return weight;
    return weight * (1 + (reps / 30.0));
  }

  // Future extension: Brzycki, Lombardi, O'Conner

  List<PersonalRecord> detectPRs(
    WorkoutSession session,
    List<PersonalRecord> history,
  ) {
    List<PersonalRecord> newPRs = [];
    final achievedAt = session.endTime ?? DateTime.now();

    // Group history by exercise for faster lookup
    final historyByExercise = <String, List<PersonalRecord>>{};
    for (var pr in history) {
      historyByExercise.putIfAbsent(pr.exerciseId, () => []).add(pr);
    }

    for (final routineEx in session.routine.exercises) {
      final exerciseId = routineEx.exercise.id;
      final pastPrs = historyByExercise[exerciseId] ?? [];

      double bestSession1RM = 0;
      double bestSessionWeight = 0;
      double sessionExerciseVolume = 0;
      int maxRepsWithWeight = 0;

      for (final set in routineEx.sets) {
        if (!set.isCompleted) continue;

        final current1RM = calculateEpley1RM(set.weight, set.reps);
        if (current1RM > bestSession1RM) bestSession1RM = current1RM;
        if (set.weight > bestSessionWeight) bestSessionWeight = set.weight;
        sessionExerciseVolume += (set.weight * set.reps);
      }

      if (bestSession1RM == 0) continue;

      // Check Heavy Weight PR
      final pastMaxWeight = _getHistoricalMax(pastPrs, 'MaxWeight');
      if (bestSessionWeight > pastMaxWeight) {
        newPRs.add(
          PersonalRecord(
            exerciseId: exerciseId,
            prType: 'MaxWeight',
            value: bestSessionWeight,
            weight: bestSessionWeight,
            reps: 0,
            estimatedOneRepMax: bestSession1RM,
            achievedAt: achievedAt,
          ),
        );
      }

      // Check 1RM PR
      final pastMax1RM = _getHistoricalMax(pastPrs, '1RM');
      if (bestSession1RM > pastMax1RM) {
        newPRs.add(
          PersonalRecord(
            exerciseId: exerciseId,
            prType: '1RM',
            value: bestSession1RM,
            weight: bestSessionWeight,
            reps: 0,
            estimatedOneRepMax: bestSession1RM,
            achievedAt: achievedAt,
          ),
        );
      }

      // Check Volume PR
      final pastMaxVolume = _getHistoricalMax(pastPrs, 'MaxVolume');
      if (sessionExerciseVolume > pastMaxVolume) {
        newPRs.add(
          PersonalRecord(
            exerciseId: exerciseId,
            prType: 'MaxVolume',
            value: sessionExerciseVolume,
            weight: 0,
            reps: 0,
            estimatedOneRepMax: bestSession1RM,
            achievedAt: achievedAt,
          ),
        );
      }
    }

    return newPRs;
  }

  double _getHistoricalMax(List<PersonalRecord> prs, String type) {
    return prs
        .where((pr) => pr.prType == type)
        .fold<double>(0.0, (max, pr) => pr.value > max ? pr.value : max);
  }
}
