import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/ui/screens/routines_screen.dart';
import 'package:app/ui/screens/logger_screen.dart';
import 'package:app/ui/screens/charts_screen.dart';
import 'package:app/ui/screens/leaderboard_screen.dart';
import 'package:app/providers/user_progress_provider.dart';
import 'package:app/providers/workout_providers.dart';
import 'package:app/providers/leaderboard_providers.dart';
import 'package:app/providers/service_providers.dart';
import 'package:app/ui/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TodayScreen(),
    const RoutinesScreen(),
    const LoggerScreen(),
    const ChartsScreen(),
    const LeaderboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Today'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Routines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Logger',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Rankings',
          ),
        ],
      ),
    );
  }
}

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userId = 'user_123';
    final progressAsync = ref.watch(userProgressProvider(userId));
    final historyAsync = ref.watch(workoutHistoryProvider(userId));
    final leaderboardAsync = ref.watch(weeklyLeaderboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Training Command Center')),
      body: progressAsync.when(
        data: (progress) {
          return historyAsync.when(
            data: (history) {
              final loadReport = ref
                  .read(trainingLoadServiceProvider)
                  .calculateLoad(history);
              final balanceReport = ref
                  .read(muscleBalanceServiceProvider)
                  .calculateBalance(history);

              final leaderboard = leaderboardAsync.valueOrNull ?? [];
              final rivalGap = ref
                  .read(rivalGapServiceProvider)
                  .calculateGap(userId, leaderboard);
              final mission = ref
                  .read(missionGeneratorServiceProvider)
                  .generateMission(balanceReport, rivalGap);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(
                          'Streak',
                          '${progress.currentStreak} 🔥',
                          Colors.orange,
                        ),
                        _buildStatCard(
                          'Level',
                          '${progress.level} ⭐',
                          Colors.yellow,
                        ),
                        _buildStatCard(
                          'Division',
                          progress.division,
                          AppTheme.accentColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Readiness Score
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              'Readiness Score',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${loadReport.readinessScore.toInt()}',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: loadReport.readinessScore > 50
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(
                              loadReport.status,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // LiftIQ Mission
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.smart_toy,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Today\'s LiftIQ Mission',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              mission.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mission.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // In a real flow, this would navigate to the routines tab or auto-start a generated routine
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Navigating to routine...'),
                                  ),
                                );
                              },
                              child: const Text('Accept Mission'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error loading history: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading progress: $e')),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
