import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/user_progress_provider.dart';
import 'package:app/providers/workout_providers.dart';
import 'package:app/providers/user_progress_provider.dart';
import 'package:app/ui/screens/routines_screen.dart';
import 'package:app/ui/screens/leaderboard_screen.dart';
import 'package:app/ui/screens/charts_screen.dart';
import 'package:app/ui/screens/logger_screen.dart';
import 'package:app/ui/screens/advanced/quest_dashboard_screen.dart';
import 'package:app/ui/screens/advanced/profile_config_modal.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

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
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Today'),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Routines',
          ),
          NavigationDestination(
            icon: Icon(Icons.play_circle_fill),
            label: 'Active',
          ),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Charts'),
          NavigationDestination(
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

  void _openProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ProfileConfigurationModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final progressAsync = ref.watch(userProgressProvider('user'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liftoff Command Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.tealAccent),
            onPressed: () => _openProfile(context),
          ),
          IconButton(
            icon: const Icon(Icons.store),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuestDashboardScreen()),
              );
            },
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          return progressAsync.when(
            data: (progress) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // User Status Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.tealAccent,
                            child: Text(
                              user.username.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.username,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Level ${progress.level}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  Text(
                                    '${progress.currentStreak} Day',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.egg,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  Text(
                                    '${progress.eggs}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'LiftIQ™ Readiness',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Card(
                    color: Colors.deepPurple.withOpacity(0.2),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Optimal Load',
                                style: TextStyle(
                                  color: Colors.tealAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.check_circle,
                                color: Colors.tealAccent,
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'ACWR is 1.15. You are perfectly primed to crush your routine today without overtraining.',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(
                      'QUICK START EMPTY WORKOUT',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      // Handled via Routines tab in full app
                    },
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
