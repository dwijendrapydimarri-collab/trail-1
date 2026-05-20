import 'package:app/models/advanced/intelligence_models.dart';
import 'package:app/models/workout_session.dart';

class MuscleBalanceService {
  MuscleBalanceReport calculateBalance(List<WorkoutSession> history) {
    final now = DateTime.now();
    Map<String, double> currentWeekly = {};
    Map<String, double> totalBaseline = {};

    for (final session in history) {
      final daysDiff = now
          .difference(session.endTime ?? session.startTime)
          .inDays;
      session.muscleGroupVolumes.forEach((muscle, volume) {
        if (daysDiff <= 7) {
          currentWeekly[muscle] = (currentWeekly[muscle] ?? 0) + volume;
        }
        if (daysDiff <= 28) {
          totalBaseline[muscle] = (totalBaseline[muscle] ?? 0) + volume;
        }
      });
    }

    Map<String, double> baselineWeekly = {};
    totalBaseline.forEach((muscle, volume) {
      baselineWeekly[muscle] = volume / 4;
    });

    List<String> undertrained = [];
    List<String> overtrained = [];
    double scoreOffset = 0;

    baselineWeekly.forEach((muscle, baselineVolume) {
      final currentVolume = currentWeekly[muscle] ?? 0;
      if (baselineVolume > 0) {
        final ratio = currentVolume / baselineVolume;
        if (ratio < 0.6) {
          undertrained.add(muscle);
          scoreOffset += 10;
        } else if (ratio > 1.5) {
          overtrained.add(muscle);
          scoreOffset += 5;
        }
      }
    });

    // Provide a default fallback if nothing is happening
    if (undertrained.isEmpty && history.isNotEmpty) {
      // Find the absolute lowest volume muscle trained historically to suggest
      var sortedByVolume = totalBaseline.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      if (sortedByVolume.isNotEmpty) {
        undertrained.add(sortedByVolume.first.key);
      }
    }

    return MuscleBalanceReport(
      currentWeeklyVolume: currentWeekly,
      baselineWeeklyVolume: baselineWeekly,
      undertrainedMuscles: undertrained,
      overtrainedMuscles: overtrained,
      balanceScore: (100 - scoreOffset).clamp(0, 100),
    );
  }
}
