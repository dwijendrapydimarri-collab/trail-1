import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/exercise_providers.dart';
import 'package:app/models/exercise.dart';
import 'package:app/ui/theme/app_theme.dart';

class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  final bool isSelectionMode;

  const ExerciseLibraryScreen({super.key, this.isSelectionMode = false});

  @override
  ConsumerState<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  String _searchQuery = '';
  String? _selectedMuscleGroup;

  @override
  Widget build(BuildContext context) {
    final exercisesAsyncValue = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Library'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppTheme.surfaceColor,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildFilterChip('All', null),
                const SizedBox(width: 8),
                _buildFilterChip('Chest', 'Chest'),
                const SizedBox(width: 8),
                _buildFilterChip('Back', 'Back'),
                const SizedBox(width: 8),
                _buildFilterChip('Legs', 'Legs'),
                const SizedBox(width: 8),
                _buildFilterChip('Shoulders', 'Shoulders'),
                const SizedBox(width: 8),
                _buildFilterChip('Arms', 'Arms'),
                const SizedBox(width: 8),
                _buildFilterChip('Core', 'Core'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: exercisesAsyncValue.when(
              data: (exercises) {
                final filteredExercises = exercises.where((e) {
                  final matchesSearch = e.name.toLowerCase().contains(_searchQuery);
                  final matchesMuscle = _selectedMuscleGroup == null || e.muscleGroup == _selectedMuscleGroup;
                  return matchesSearch && matchesMuscle;
                }).toList();

                if (filteredExercises.isEmpty) {
                  return const Center(child: Text('No exercises found.'));
                }

                return ListView.builder(
                  itemCount: filteredExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = filteredExercises[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${exercise.muscleGroup} • ${exercise.equipment}'),
                        trailing: widget.isSelectionMode
                            ? IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: AppTheme.accentColor),
                                onPressed: () {
                                  Navigator.of(context).pop(exercise);
                                },
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? muscleGroup) {
    final isSelected = _selectedMuscleGroup == muscleGroup;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedMuscleGroup = selected ? muscleGroup : null;
        });
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.3),
    );
  }
}
