import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:app/models/workout_session.dart';
import 'package:app/models/set_log.dart';
import 'package:app/providers/workout_providers.dart';
import 'package:app/providers/user_progress_provider.dart';
import 'package:app/models/advanced/event_sourcing.dart';
import 'package:app/ui/screens/recap_screen.dart';
import 'package:app/ui/widgets/plate_calculator_sheet.dart';

class LoggerScreen extends ConsumerStatefulWidget {
  const LoggerScreen({super.key});

  @override
  ConsumerState<LoggerScreen> createState() => _LoggerScreenState();
}

class _LoggerScreenState extends ConsumerState<LoggerScreen> {
  final _uuid = const Uuid();
  final String sessionId = 'current_session';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = ref.read(activeSessionProvider(sessionId));
      if (session == null) {
        ref
            .read(activeSessionProvider(sessionId).notifier)
            .dispatch(
              WorkoutStartedEvent(
                id: _uuid.v4(),
                sessionId: sessionId,
                timestamp: DateTime.now(),
                payload: {
                  'routineId': 'custom',
                  'routineName': 'Custom Workout',
                },
              ),
            );
      }
    });
  }

  void _finishWorkout(WorkoutSession session) {
    ref
        .read(activeSessionProvider(sessionId).notifier)
        .dispatch(
          WorkoutFinishedEvent(
            id: _uuid.v4(),
            sessionId: sessionId,
            timestamp: DateTime.now(),
            payload: {
              'xpEarned': session.sets.where((s) => s.isCompleted).length * 10,
            },
          ),
        );

    final finalSession = ref.read(activeSessionProvider(sessionId));

    ref.invalidate(userProgressProvider);
    ref.invalidate(workoutHistoryProvider);
    ref.invalidate(personalRecordsProvider);

    if (finalSession != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RecapScreen(session: finalSession, newPrs: const []),
        ),
      );
    }
  }

  void _openPlateCalculator(SetLog set, bool isBarbell) async {
    final result = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          PlateCalculatorSheet(initialWeight: set.weight, isBarbell: isBarbell),
    );

    if (result != null) {
      ref
          .read(activeSessionProvider(sessionId).notifier)
          .dispatch(
            SetUpdatedEvent(
              id: _uuid.v4(),
              sessionId: sessionId,
              timestamp: DateTime.now(),
              payload: {'setId': set.id, 'weight': result},
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(activeSessionProvider(sessionId));

    if (session == null) {
      return const Scaffold(body: Center(child: Text('No active workout')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Logging: ${session.routineName}'),
        actions: [
          TextButton(
            onPressed: () => _finishWorkout(session),
            child: const Text(
              'FINISH',
              style: TextStyle(
                color: Colors.tealAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: session.sets.length,
        itemBuilder: (context, index) {
          final set = session.sets[index];
          final isBarbell =
              set.exerciseId.toLowerCase().contains('barbell') ||
              set.exerciseId.toLowerCase().contains('bench') ||
              set.exerciseId.toLowerCase().contains('squat');

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(child: Text('Exercise: ${set.exerciseId}')),
                  SizedBox(
                    width: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: ValueKey('weight_${set.id}_${set.weight}'),
                            initialValue: set.weight.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'kg'),
                            onChanged: (val) {
                              ref
                                  .read(
                                    activeSessionProvider(sessionId).notifier,
                                  )
                                  .dispatch(
                                    SetUpdatedEvent(
                                      id: _uuid.v4(),
                                      sessionId: sessionId,
                                      timestamp: DateTime.now(),
                                      payload: {
                                        'setId': set.id,
                                        'weight':
                                            double.tryParse(val) ?? set.weight,
                                      },
                                    ),
                                  );
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.calculate,
                            size: 20,
                            color: Colors.tealAccent,
                          ),
                          onPressed: () => _openPlateCalculator(set, isBarbell),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      key: ValueKey('reps_${set.id}_${set.reps}'),
                      initialValue: set.reps.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'reps'),
                      onChanged: (val) {
                        ref
                            .read(activeSessionProvider(sessionId).notifier)
                            .dispatch(
                              SetUpdatedEvent(
                                id: _uuid.v4(),
                                sessionId: sessionId,
                                timestamp: DateTime.now(),
                                payload: {
                                  'setId': set.id,
                                  'reps': int.tryParse(val) ?? set.reps,
                                },
                              ),
                            );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Checkbox(
                    value: set.isCompleted,
                    activeColor: Colors.tealAccent,
                    checkColor: Colors.black,
                    onChanged: (val) {
                      ref
                          .read(activeSessionProvider(sessionId).notifier)
                          .dispatch(
                            SetUpdatedEvent(
                              id: _uuid.v4(),
                              sessionId: sessionId,
                              timestamp: DateTime.now(),
                              payload: {
                                'setId': set.id,
                                'isCompleted': val ?? false,
                              },
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref
              .read(activeSessionProvider(sessionId).notifier)
              .dispatch(
                SetLoggedEvent(
                  id: _uuid.v4(),
                  sessionId: sessionId,
                  timestamp: DateTime.now(),
                  payload: {
                    'setId': _uuid.v4(),
                    'exerciseId': 'New Exercise',
                    'weight': 0.0,
                    'reps': 0,
                  },
                ),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
