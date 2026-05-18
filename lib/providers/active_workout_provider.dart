import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/workout_session.dart';
import 'package:app/models/routine.dart';
import 'package:app/models/set_log.dart';
import 'package:app/models/exercise.dart';
import 'package:uuid/uuid.dart';

class ActiveWorkoutState {
  final WorkoutSession? session;
  final int? restTimerSeconds;
  final bool isTimerActive;

  ActiveWorkoutState({
    this.session,
    this.restTimerSeconds,
    this.isTimerActive = false,
  });

  ActiveWorkoutState copyWith({
    WorkoutSession? session,
    int? restTimerSeconds,
    bool? isTimerActive,
    bool clearTimer = false,
  }) {
    return ActiveWorkoutState(
      session: session ?? this.session,
      restTimerSeconds: clearTimer
          ? null
          : (restTimerSeconds ?? this.restTimerSeconds),
      isTimerActive: isTimerActive ?? this.isTimerActive,
    );
  }
}

class ActiveWorkoutNotifier extends Notifier<ActiveWorkoutState> {
  Timer? _restTimer;

  @override
  ActiveWorkoutState build() {
    return ActiveWorkoutState();
  }

  void startWorkout(Routine routine) {
    state = ActiveWorkoutState(
      session: WorkoutSession(
        id: const Uuid().v4(),
        routine: routine.copyWith(
          // Ensure all routines start with uncompleted sets if they were copied from history
          exercises: routine.exercises
              .map(
                (re) => re.copyWith(
                  sets: re.sets
                      .map((s) => s.copyWith(isCompleted: false))
                      .toList(),
                ),
              )
              .toList(),
        ),
        startTime: DateTime.now(),
      ),
    );
  }

  void endWorkout() {
    _restTimer?.cancel();
    state = ActiveWorkoutState(); // clear session
  }

  void addSet(int exerciseIndex, double weight, int reps) {
    if (state.session == null) return;

    final currentSession = state.session!;
    final exercises = List<RoutineExercise>.from(
      currentSession.routine.exercises,
    );
    final sets = List<SetLog>.from(exercises[exerciseIndex].sets);

    sets.add(
      SetLog(
        id: const Uuid().v4(),
        weight: weight,
        reps: reps,
        isCompleted: false,
      ),
    );

    exercises[exerciseIndex] = exercises[exerciseIndex].copyWith(sets: sets);

    state = state.copyWith(
      session: currentSession.copyWith(
        routine: currentSession.routine.copyWith(exercises: exercises),
      ),
    );
  }

  void toggleSetComplete(int exerciseIndex, int setIndex) {
    if (state.session == null) return;

    final currentSession = state.session!;
    final exercises = List<RoutineExercise>.from(
      currentSession.routine.exercises,
    );
    final sets = List<SetLog>.from(exercises[exerciseIndex].sets);

    final targetSet = sets[setIndex];
    final newIsCompleted = !targetSet.isCompleted;

    sets[setIndex] = targetSet.copyWith(isCompleted: newIsCompleted);
    exercises[exerciseIndex] = exercises[exerciseIndex].copyWith(sets: sets);

    state = state.copyWith(
      session: currentSession.copyWith(
        routine: currentSession.routine.copyWith(exercises: exercises),
      ),
    );

    if (newIsCompleted) {
      _startRestTimer(90); // 90 seconds default
    }
  }

  void updateSet(int exerciseIndex, int setIndex, {double? weight, int? reps}) {
    if (state.session == null) return;

    final currentSession = state.session!;
    final exercises = List<RoutineExercise>.from(
      currentSession.routine.exercises,
    );
    final sets = List<SetLog>.from(exercises[exerciseIndex].sets);

    sets[setIndex] = sets[setIndex].copyWith(weight: weight, reps: reps);

    exercises[exerciseIndex] = exercises[exerciseIndex].copyWith(sets: sets);

    state = state.copyWith(
      session: currentSession.copyWith(
        routine: currentSession.routine.copyWith(exercises: exercises),
      ),
    );
  }

  void addExercise(Exercise exercise) {
    if (state.session == null) return;

    final currentSession = state.session!;
    final exercises = List<RoutineExercise>.from(
      currentSession.routine.exercises,
    );

    exercises.add(
      RoutineExercise(
        exercise: exercise,
        sets: [SetLog(id: const Uuid().v4(), weight: 0, reps: 0)],
      ),
    );

    state = state.copyWith(
      session: currentSession.copyWith(
        routine: currentSession.routine.copyWith(exercises: exercises),
      ),
    );
  }

  void _startRestTimer(int durationSeconds) {
    _restTimer?.cancel();
    state = state.copyWith(
      restTimerSeconds: durationSeconds,
      isTimerActive: true,
    );

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.restTimerSeconds == null || state.restTimerSeconds! <= 1) {
        timer.cancel();
        state = state.copyWith(clearTimer: true, isTimerActive: false);
      } else {
        state = state.copyWith(restTimerSeconds: state.restTimerSeconds! - 1);
      }
    });
  }

  void stopRestTimer() {
    _restTimer?.cancel();
    state = state.copyWith(clearTimer: true, isTimerActive: false);
  }

  void adjustRestTimer(int secondsToAdd) {
    if (state.restTimerSeconds != null) {
      final newTime = state.restTimerSeconds! + secondsToAdd;
      if (newTime > 0) {
        state = state.copyWith(restTimerSeconds: newTime);
      } else {
        stopRestTimer();
      }
    }
  }
}

final activeWorkoutProvider =
    NotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState>(() {
      return ActiveWorkoutNotifier();
    });
