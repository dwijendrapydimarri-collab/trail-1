import 'package:app/models/advanced/gamification_models.dart';
import 'package:app/models/workout_session.dart';
import 'package:app/models/user_progress.dart';

class QuestService {
  List<Quest> generateDailyQuests(UserProgress user) {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return [
      Quest(
        id: 'q1',
        title: 'Daily Lifter',
        description: 'Complete 1 workout today.',
        type: 'Daily',
        targetValue: 1.0,
        rewardEggs: 50,
        expiresAt: endOfDay,
      ),
      Quest(
        id: 'q2',
        title: 'Volume Pusher',
        description: 'Log 5,000kg total volume today.',
        type: 'Daily',
        targetValue: 5000.0,
        rewardEggs: 100,
        expiresAt: endOfDay,
      ),
    ];
  }

  List<Quest> evaluateQuests(List<Quest> activeQuests, WorkoutSession session) {
    return activeQuests.map((q) {
      if (q.isCompleted) return q;

      double newValue = q.currentValue;
      if (q.id == 'q1') {
        newValue += 1;
      } else if (q.id == 'q2') {
        newValue += session.totalVolume;
      }

      bool completed = newValue >= q.targetValue;
      return q.copyWith(currentValue: newValue, isCompleted: completed);
    }).toList();
  }
}

class AchievementService {
  List<Achievement> checkAchievements(
    UserProgress progress,
    List<WorkoutSession> history,
  ) {
    List<Achievement> results = [];

    // Evaluate 7 day streak
    results.add(
      Achievement(
        id: 'a_streak_7',
        name: '7-Day Streak',
        description: 'Maintained a workout streak for 7 consecutive days.',
        isUnlocked: progress.currentStreak >= 7,
        unlockedAt: progress.currentStreak >= 7 ? DateTime.now() : null,
      ),
    );

    // Evaluate 10k Volume
    final has10kSession = history.any((s) => s.totalVolume >= 10000);
    results.add(
      Achievement(
        id: 'a_vol_10k',
        name: '10K Volume Day',
        description: 'Lifted 10,000kg in a single session.',
        isUnlocked: has10kSession,
        unlockedAt: has10kSession ? DateTime.now() : null,
      ),
    );

    return results;
  }
}
