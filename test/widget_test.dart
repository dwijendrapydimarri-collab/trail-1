import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/main.dart';
import 'package:app/services/workout_stats_service.dart';
import 'package:app/services/personal_record_service.dart';
import 'package:app/services/progression_service.dart';
import 'package:app/models/workout_session.dart';
import 'package:app/models/routine.dart';
import 'package:app/models/exercise.dart';
import 'package:app/models/set_log.dart';
import 'package:app/models/personal_record.dart';
import 'package:app/models/user_progress.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: LiftoffApp()));
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  group('WorkoutStatsService', () {
    test('calculates correct volume and XP', () {
      final service = WorkoutStatsService();
      final session = WorkoutSession(
        id: '1',
        startTime: DateTime.now(),
        routine: Routine(
          id: 'r1',
          name: 'Test',
          exercises: [
            RoutineExercise(
              exercise: Exercise(
                id: 'e1',
                name: 'Bench',
                muscleGroup: 'Chest',
                equipment: 'Barbell',
                difficulty: 'Beginner',
              ),
              sets: [
                SetLog(id: 's1', weight: 100, reps: 10, isCompleted: true),
                SetLog(id: 's2', weight: 100, reps: 5, isCompleted: false),
              ],
            ),
          ],
        ),
      );

      final result = service.calculateSessionStats(session);

      expect(result.totalVolume, 1000.0);
      expect(result.totalSets, 1);
      // XP: 1 set * 10 + floor(1000 / 1000) = 11
      expect(result.xpEarned, 11);
    });
  });

  group('PersonalRecordService', () {
    test('detects heavier weight PR', () {
      final service = PersonalRecordService();
      final session = WorkoutSession(
        id: '1',
        startTime: DateTime.now(),
        routine: Routine(
          id: 'r1',
          name: 'Test',
          exercises: [
            RoutineExercise(
              exercise: Exercise(
                id: 'e1',
                name: 'Bench',
                muscleGroup: 'Chest',
                equipment: 'Barbell',
                difficulty: 'Beginner',
              ),
              sets: [SetLog(id: 's1', weight: 110, reps: 1, isCompleted: true)],
            ),
          ],
        ),
      );

      final history = [
        PersonalRecord(
          exerciseId: 'e1',
          prType: 'MaxWeight',
          value: 100,
          weight: 100,
          reps: 1,
          estimatedOneRepMax: 100,
          achievedAt: DateTime.now(),
        ),
      ];

      final prs = service.detectPRs(session, history);

      expect(
        prs.any((pr) => pr.prType == 'MaxWeight' && pr.value == 110),
        isTrue,
      );
    });
  });

  group('ProgressionService', () {
    test('increments streak if within 48 hours', () {
      final service = ProgressionService();
      final now = DateTime.now();

      final currentProgress = UserProgress(
        userId: 'u1',
        currentStreak: 5,
        lastWorkoutDate: now.subtract(const Duration(days: 1)),
      );

      final session = WorkoutSession(
        id: '1',
        startTime: now,
        endTime: now,
        routine: Routine(id: 'r1', name: 'Test', exercises: []),
        xpEarned: 100,
      );

      final result = service.calculateNewProgress(currentProgress, session, []);

      expect(result.currentStreak, 6);
      expect(result.totalXp, 100);
    });

    test('resets streak if missed days', () {
      final service = ProgressionService();
      final now = DateTime.now();

      final currentProgress = UserProgress(
        userId: 'u1',
        currentStreak: 5,
        lastWorkoutDate: now.subtract(const Duration(days: 4)),
      );

      final session = WorkoutSession(
        id: '1',
        startTime: now,
        endTime: now,
        routine: Routine(id: 'r1', name: 'Test', exercises: []),
      );

      final result = service.calculateNewProgress(currentProgress, session, []);

      expect(result.currentStreak, 1);
    });
  });
}
