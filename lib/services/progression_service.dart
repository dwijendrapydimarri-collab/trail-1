import 'package:app/models/user_progress.dart';
import 'package:app/models/workout_session.dart';
import 'package:app/models/personal_record.dart';
import 'package:app/models/advanced/gamification_models.dart';

class ProgressionService {
  UserProgress calculateNewProgress(
    UserProgress currentProgress,
    WorkoutSession session,
    List<PersonalRecord> newPrs,
  ) {
    int earnedXp = session.xpEarned;

    // Bonus XP for PRs
    earnedXp += (newPrs.length * 50);

    // Streak Calculation
    int newStreak = currentProgress.currentStreak;
    final lastWorkout = currentProgress.lastWorkoutDate;
    final sessionDate = session.endTime ?? DateTime.now();

    if (lastWorkout == null) {
      newStreak = 1;
    } else {
      final difference = sessionDate.difference(lastWorkout).inDays;
      if (difference == 1 || difference == 2) {
        // 48h grace period for gym routines
        newStreak += 1;
      } else if (difference > 2) {
        newStreak = 1; // Streak broken
      }
      // If difference == 0 (multiple workouts in one day), streak stays the same
    }

    int earnedEggs = 10; // Default egg reward for completing a workout
    earnedEggs += newPrs.length * 5; // Bonus eggs for PRs

    return currentProgress.copyWith(
      totalXp: currentProgress.totalXp + earnedXp,
      currentStreak: newStreak,
      lastWorkoutDate: sessionDate,
      prCount: currentProgress.prCount + newPrs.length,
      eggs: currentProgress.eggs + earnedEggs,
      totalEggsEarned: currentProgress.totalEggsEarned + earnedEggs,
    );
  }
}
