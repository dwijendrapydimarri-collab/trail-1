import 'package:flutter_test/flutter_test.dart';
import 'package:app/models/workout_session.dart';
import 'package:app/models/routine.dart';
import 'package:app/models/exercise.dart';
import 'package:app/models/set_log.dart';
import 'package:app/services/advanced/training_load_service.dart';
import 'package:app/services/advanced/muscle_balance_service.dart';
import 'package:app/services/advanced/rival_gap_service.dart';
import 'package:app/models/user_leaderboard_stats.dart';

void main() {
  group('TrainingLoadService', () {
    test('calculates accurate readiness score based on volume ratio', () {
      final service = TrainingLoadService();
      final now = DateTime.now();

      final history = [
        // Acute (within 7 days)
        WorkoutSession(
          id: '1',
          startTime: now,
          routine: Routine(id: 'r', name: 'R', exercises: []),
          totalVolume: 10000,
        ),
        // Chronic (weeks 2-4)
        WorkoutSession(
          id: '2',
          startTime: now.subtract(const Duration(days: 14)),
          routine: Routine(id: 'r', name: 'R', exercises: []),
          totalVolume: 10000,
        ),
        WorkoutSession(
          id: '3',
          startTime: now.subtract(const Duration(days: 21)),
          routine: Routine(id: 'r', name: 'R', exercises: []),
          totalVolume: 10000,
        ),
        WorkoutSession(
          id: '4',
          startTime: now.subtract(const Duration(days: 28)),
          routine: Routine(id: 'r', name: 'R', exercises: []),
          totalVolume: 10000,
        ),
      ];

      final report = service.calculateLoad(history);
      expect(report.acuteLoad, 10000);
      expect(report.chronicLoad, 10000); // 40000 / 4
      expect(report.loadRatio, 1.0);
      expect(report.status, 'Productive');
    });
  });

  group('MuscleBalanceService', () {
    test('identifies undertrained muscles', () {
      final service = MuscleBalanceService();
      final now = DateTime.now();

      final history = [
        WorkoutSession(
          id: '1',
          startTime: now,
          routine: Routine(id: 'r', name: 'R', exercises: []),
          muscleGroupVolumes: {
            'Chest': 1000,
            'Back': 0,
          }, // Current week ignores back
        ),
        WorkoutSession(
          id: '2',
          startTime: now.subtract(const Duration(days: 14)),
          routine: Routine(id: 'r', name: 'R', exercises: []),
          muscleGroupVolumes: {'Chest': 1000, 'Back': 1000},
        ),
      ];

      final report = service.calculateBalance(history);
      expect(report.undertrainedMuscles.contains('Back'), isTrue);
    });
  });

  group('RivalGapService', () {
    test('calculates correct gap and sessions', () {
      final service = RivalGapService();

      final leaderboard = [
        UserLeaderboardStats(
          userId: '1',
          username: 'Bob',
          weeklyVolume: 0,
          monthlyVolume: 50000,
        ),
        UserLeaderboardStats(
          userId: 'u1',
          username: 'Me',
          weeklyVolume: 0,
          monthlyVolume: 35000,
        ),
      ];

      final report = service.calculateGap('u1', leaderboard);

      expect(report, isNotNull);
      expect(report!.rivalUsername, 'Bob');
      expect(report.volumeGap, 15000); // 50000 - 35000
      expect(report.estimatedSessionsNeeded, 2); // 15000 / 10000 ceil
    });
  });
}
