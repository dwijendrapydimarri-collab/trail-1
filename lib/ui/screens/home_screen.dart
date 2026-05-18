import 'package:flutter/material.dart';
import 'package:app/ui/screens/routines_screen.dart';
import 'package:app/ui/screens/logger_screen.dart';
import 'package:app/ui/screens/charts_screen.dart';
import 'package:app/ui/screens/leaderboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
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
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Routines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Logger',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Charts'),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Rankings',
          ),
        ],
      ),
    );
  }
}
