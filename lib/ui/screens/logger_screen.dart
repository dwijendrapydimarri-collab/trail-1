import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/active_workout_provider.dart';
import 'package:app/ui/theme/app_theme.dart';
import 'package:vibration/vibration.dart';
import 'package:confetti/confetti.dart';
import 'package:app/models/routine.dart';
import 'package:app/models/set_log.dart';

class LoggerScreen extends ConsumerStatefulWidget {
  const LoggerScreen({super.key});

  @override
  ConsumerState<LoggerScreen> createState() => _LoggerScreenState();
}

class _LoggerScreenState extends ConsumerState<LoggerScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _triggerHapticAndConfetti() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50, amplitude: 128);
    }
  }

  void _checkAndTriggerPR(double weight, int reps, String exerciseName) async {
    // Simple mock logic for PR detection
    // In a real app, this would check against the PersonalRecord model history
    // For demo purposes, any set > 100kg or >= 10 reps is a PR
    if (weight > 100 || reps >= 10) {
      _confettiController.play();
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 100, 50, 100, 50, 200]);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 NEW PR on $exerciseName!'),
            backgroundColor: AppTheme.accentColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _finishWorkout() {
    ref.read(activeWorkoutProvider.notifier).endWorkout();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout saved!')));
  }

  @override
  Widget build(BuildContext context) {
    final activeState = ref.watch(activeWorkoutProvider);
    final session = activeState.session;

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout Logger')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No active workout', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // For testing, starting an empty routine if none is passed
                  ref.read(activeWorkoutProvider.notifier).startWorkout(
                    Routine(id: 'test_routine', name: 'Quick Workout', exercises: []),
                  );
                },
                child: const Text('Start Empty Workout'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(session.routine.name),
        actions: [
          TextButton(
            onPressed: _finishWorkout,
            child: const Text('Finish', style: TextStyle(color: AppTheme.accentColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: session.routine.exercises.length,
            itemBuilder: (context, exIndex) {
              final routineExercise = session.routine.exercises[exIndex];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        routineExercise.exercise.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentColor),
                      ),
                      const SizedBox(height: 8),
                      // Header
                      const Row(
                        children: [
                          SizedBox(width: 40, child: Text('Set', style: TextStyle(color: AppTheme.textSecondaryColor))),
                          Expanded(child: Text('kg', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondaryColor))),
                          Expanded(child: Text('Reps', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondaryColor))),
                          SizedBox(width: 48, child: Icon(Icons.check, color: AppTheme.textSecondaryColor)),
                        ],
                      ),
                      const Divider(),
                      ...routineExercise.sets.asMap().entries.map((entry) {
                        final setIndex = entry.key;
                        final setLog = entry.value;
                        return _buildSetRow(exIndex, setIndex, setLog);
                      }),
                      TextButton.icon(
                        onPressed: () {
                          double lastWeight = 0;
                          int lastReps = 0;
                          if (routineExercise.sets.isNotEmpty) {
                            lastWeight = routineExercise.sets.last.weight;
                            lastReps = routineExercise.sets.last.reps;
                          }
                          ref.read(activeWorkoutProvider.notifier).addSet(exIndex, lastWeight, lastReps);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Set'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          if (activeState.isTimerActive && activeState.restTimerSeconds != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => ref.read(activeWorkoutProvider.notifier).stopRestTimer(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Rest: ${activeState.restTimerSeconds}s',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.close, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [AppTheme.primaryColor, AppTheme.accentColor, Colors.white, Colors.yellow],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetRow(int exIndex, int setIndex, SetLog setLog) {
    return Dismissible(
      key: ValueKey('${setLog.id}_$setIndex'),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: AppTheme.accentColor.withOpacity(0.2),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.check, color: AppTheme.accentColor),
      ),
      onDismissed: (direction) {
        // We actually don't want to dismiss, we want to complete
      },
      confirmDismiss: (direction) async {
        if (!setLog.isCompleted) {
          _triggerHapticAndConfetti();
          _checkAndTriggerPR(setLog.weight, setLog.reps, session!.routine.exercises[exIndex].exercise.name);
        }
        ref.read(activeWorkoutProvider.notifier).toggleSetComplete(exIndex, setIndex);
        return false; // Prevent actual dismissal
      },
      child: Container(
        color: setLog.isCompleted ? AppTheme.accentColor.withOpacity(0.1) : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: setLog.isCompleted ? AppTheme.accentColor : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${setIndex + 1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: setLog.isCompleted ? AppTheme.backgroundColor : AppTheme.textPrimaryColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  initialValue: setLog.weight > 0 ? setLog.weight.toString() : '',
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '-',
                    isDense: true,
                    filled: true,
                    fillColor: AppTheme.surfaceColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                  onChanged: (val) {
                    ref.read(activeWorkoutProvider.notifier).updateSet(exIndex, setIndex, weight: double.tryParse(val));
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  initialValue: setLog.reps > 0 ? setLog.reps.toString() : '',
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '-',
                    isDense: true,
                    filled: true,
                    fillColor: AppTheme.surfaceColor,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                  onChanged: (val) {
                    ref.read(activeWorkoutProvider.notifier).updateSet(exIndex, setIndex, reps: int.tryParse(val));
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!setLog.isCompleted) {
                  _triggerHapticAndConfetti();
                  _checkAndTriggerPR(setLog.weight, setLog.reps, session!.routine.exercises[exIndex].exercise.name);
                }
                ref.read(activeWorkoutProvider.notifier).toggleSetComplete(exIndex, setIndex);
              },
              child: Container(
                width: 48,
                height: 36,
                decoration: BoxDecoration(
                  color: setLog.isCompleted ? AppTheme.accentColor : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.check,
                  color: setLog.isCompleted ? AppTheme.backgroundColor : AppTheme.textSecondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
