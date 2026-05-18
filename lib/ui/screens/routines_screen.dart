import 'package:flutter/material.dart';
import 'package:app/ui/screens/routine_builder_screen.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Routines')),
      body: const Center(child: Text('Routines Placeholder')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RoutineBuilderScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
