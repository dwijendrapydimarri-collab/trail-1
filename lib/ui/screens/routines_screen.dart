import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/ui/screens/routine_builder_screen.dart';
import 'package:app/providers/workout_providers.dart';
import 'package:app/providers/active_workout_provider.dart';

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hardcoded user ID for demo purposes
    const userId = 'user_123';
    final routinesAsync = ref.watch(routinesProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('My Routines')),
      body: routinesAsync.when(
        data: (routines) {
          if (routines.isEmpty) {
            return const Center(
              child: Text(
                'No routines found.\nTap + to create one!',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: routines.length,
            itemBuilder: (context, index) {
              final routine = routines[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    routine.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${routine.exercises.length} exercises'),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.green),
                    onPressed: () {
                      ref
                          .read(activeWorkoutProvider.notifier)
                          .startWorkout(routine);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Started ${routine.name}')),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RoutineBuilderScreen(initialRoutine: routine),
                      ),
                    ).then((_) => ref.refresh(routinesProvider(userId)));
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RoutineBuilderScreen(),
            ),
          ).then((_) => ref.refresh(routinesProvider(userId)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
