import 'package:flutter/material.dart';
import 'package:app/models/routine.dart';
import 'package:app/models/exercise.dart';
import 'package:app/models/set_log.dart';
import 'package:app/ui/screens/exercise_library_screen.dart';
import 'package:app/ui/theme/app_theme.dart';
import 'package:uuid/uuid.dart';

class RoutineBuilderScreen extends StatefulWidget {
  final Routine? initialRoutine;

  const RoutineBuilderScreen({super.key, this.initialRoutine});

  @override
  State<RoutineBuilderScreen> createState() => _RoutineBuilderScreenState();
}

class _RoutineBuilderScreenState extends State<RoutineBuilderScreen> {
  final _nameController = TextEditingController();
  List<RoutineExercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialRoutine != null) {
      _nameController.text = widget.initialRoutine!.name;
      _exercises = List.from(widget.initialRoutine!.exercises);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addExercise(Exercise exercise) {
    setState(() {
      _exercises.add(RoutineExercise(
        exercise: exercise,
        sets: [SetLog(id: const Uuid().v4(), weight: 0, reps: 0)],
      ));
    });
  }

  void _addSetToExercise(int exerciseIndex) {
    setState(() {
      final currentSets = _exercises[exerciseIndex].sets;
      double lastWeight = 0;
      int lastReps = 0;
      if (currentSets.isNotEmpty) {
        lastWeight = currentSets.last.weight;
        lastReps = currentSets.last.reps;
      }

      _exercises[exerciseIndex] = _exercises[exerciseIndex].copyWith(
        sets: [...currentSets, SetLog(id: const Uuid().v4(), weight: lastWeight, reps: lastReps)],
      );
    });
  }

  void _removeSetFromExercise(int exerciseIndex, int setIndex) {
    setState(() {
      final currentSets = List<SetLog>.from(_exercises[exerciseIndex].sets);
      currentSets.removeAt(setIndex);
      _exercises[exerciseIndex] = _exercises[exerciseIndex].copyWith(sets: currentSets);
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  void _saveRoutine() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a routine name')));
      return;
    }
    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one exercise')));
      return;
    }

    final routine = Routine(
      id: widget.initialRoutine?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      exercises: _exercises,
    );

    Navigator.of(context).pop(routine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialRoutine == null ? 'Create Routine' : 'Edit Routine'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveRoutine,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Routine Name',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: _exercises.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = _exercises.removeAt(oldIndex);
                  _exercises.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final routineExercise = _exercises[index];
                return Card(
                  key: ValueKey(routineExercise.exercise.id + index.toString()),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              routineExercise.exercise.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _removeExercise(index),
                                ),
                                const Icon(Icons.drag_handle),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...routineExercise.sets.asMap().entries.map((entry) {
                          final setIndex = entry.key;
                          final setLog = entry.value;
                          return Row(
                            children: [
                              Text('Set ${setIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  initialValue: setLog.weight > 0 ? setLog.weight.toString() : '',
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(hintText: 'kg', isDense: true),
                                  onChanged: (val) {
                                    final sets = List<SetLog>.from(_exercises[index].sets);
                                    sets[setIndex] = sets[setIndex].copyWith(weight: double.tryParse(val) ?? 0);
                                    _exercises[index] = _exercises[index].copyWith(sets: sets);
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  initialValue: setLog.reps > 0 ? setLog.reps.toString() : '',
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(hintText: 'reps', isDense: true),
                                  onChanged: (val) {
                                    final sets = List<SetLog>.from(_exercises[index].sets);
                                    sets[setIndex] = sets[setIndex].copyWith(reps: int.tryParse(val) ?? 0);
                                    _exercises[index] = _exercises[index].copyWith(sets: sets);
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => _removeSetFromExercise(index, setIndex),
                              ),
                            ],
                          );
                        }),
                        TextButton.icon(
                          onPressed: () => _addSetToExercise(index),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Set'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                final Exercise? selectedExercise = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ExerciseLibraryScreen(isSelectionMode: true),
                  ),
                );
                if (selectedExercise != null) {
                  _addExercise(selectedExercise);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Exercise'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
