import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/ui/theme/app_theme.dart';
import 'package:app/providers/workout_providers.dart';
import 'package:app/models/workout_session.dart';
import 'package:app/models/personal_record.dart';
import 'package:app/providers/exercise_providers.dart';

class ChartsScreen extends ConsumerStatefulWidget {
  const ChartsScreen({super.key});

  @override
  ConsumerState<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends ConsumerState<ChartsScreen> {
  String _selectedMuscleGroup = 'Chest';

  @override
  Widget build(BuildContext context) {
    const userId = 'user_123';
    final historyAsync = ref.watch(workoutHistoryProvider(userId));
    final prsAsync = ref.watch(personalRecordsProvider(userId));
    final exercisesAsync = ref.watch(exercisesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Strength Progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estimated 1RM Progression',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Chest'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Back'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Legs'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Shoulders'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          const weeks = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6'];
                          if (value.toInt() >= 0 &&
                              value.toInt() < weeks.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                weeks[value.toInt()],
                                style: const TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}kg',
                            style: const TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildPrSpots(
                        prsAsync,
                        exercisesAsync,
                        _selectedMuscleGroup,
                      ),
                      isCurved: true,
                      color: AppTheme.accentColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.accentColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Weekly Volume Heatmap',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 50000,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun',
                          ];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              days[value.toInt()],
                              style: const TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildHeatmapGroups(historyAsync),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedMuscleGroup == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedMuscleGroup = label;
          });
        }
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.3),
    );
  }

  List<FlSpot> _buildPrSpots(
    AsyncValue<List<PersonalRecord>> prsAsync,
    AsyncValue<List<dynamic>> exercisesAsync,
    String muscleGroup,
  ) {
    final prs = prsAsync.valueOrNull ?? [];
    final exercises = exercisesAsync.valueOrNull ?? [];

    final muscleGroupExerciseIds = exercises
        .where((e) => e.muscleGroup == muscleGroup)
        .map((e) => e.id)
        .toSet();

    final filteredPrs = prs
        .where((pr) => muscleGroupExerciseIds.contains(pr.exerciseId))
        .toList();

    filteredPrs.sort((a, b) => a.achievedAt.compareTo(b.achievedAt));

    if (filteredPrs.isEmpty) {
      return const []; // No data available yet. Shows empty instead of fake.
    }

    final recentPrs = filteredPrs.length > 6
        ? filteredPrs.sublist(filteredPrs.length - 6)
        : filteredPrs;

    List<FlSpot> spots = [];
    for (int i = 0; i < recentPrs.length; i++) {
      spots.add(FlSpot(i.toDouble(), recentPrs[i].estimatedOneRepMax));
    }

    return spots;
  }

  List<BarChartGroupData> _buildHeatmapGroups(
    AsyncValue<List<WorkoutSession>> historyAsync,
  ) {
    final sessions = historyAsync.valueOrNull ?? [];

    if (sessions.isEmpty) {
      return []; // Return empty graph rather than mock if no history.
    }

    Map<int, double> volumeByDay = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};

    for (final session in sessions) {
      final dayOfWeek = session.startTime.weekday;
      double volume = 0;
      for (final ex in session.routine.exercises) {
        for (final set in ex.sets) {
          if (set.isCompleted) volume += (set.weight * set.reps);
        }
      }
      volumeByDay[dayOfWeek] = (volumeByDay[dayOfWeek] ?? 0) + volume;
    }

    return List.generate(7, (index) {
      final volume = volumeByDay[index + 1] ?? 0;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: volume,
            color: AppTheme.primaryColor,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
