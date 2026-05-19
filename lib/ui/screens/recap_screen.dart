import 'package:flutter/material.dart';
import 'package:app/models/workout_recap.dart';
import 'package:app/ui/theme/app_theme.dart';
import 'package:confetti/confetti.dart';

class RecapScreen extends StatefulWidget {
  final WorkoutRecap recap;

  const RecapScreen({super.key, required this.recap});

  @override
  State<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends State<RecapScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    if (widget.recap.newPrs.isNotEmpty || widget.recap.streakDays > 0) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.recap.session;
    final duration = session.endTime != null
        ? session.endTime!.difference(session.startTime)
        : const Duration(minutes: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Complete'),
        automaticallyImplyLeading: false, // Force them to use the done button
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Great job!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    session.routine.name,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),

                // Hero Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatBubble(
                      Icons.timer,
                      '${duration.inMinutes}m',
                      'Time',
                    ),
                    _buildStatBubble(
                      Icons.fitness_center,
                      '${(session.totalVolume / 1000).toStringAsFixed(1)}k',
                      'Volume (kg)',
                    ),
                    _buildStatBubble(
                      Icons.star,
                      '+${session.xpEarned}',
                      'XP Earned',
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Streak
                if (widget.recap.streakDays > 0)
                  _buildSectionCard(
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                    title: 'Current Streak',
                    content: '${widget.recap.streakDays} Days',
                  ),

                const SizedBox(height: 16),

                // PRs
                if (widget.recap.newPrs.isNotEmpty) _buildPrSection(),

                const SizedBox(height: 16),

                // Next Goal
                _buildSectionCard(
                  icon: Icons.lightbulb,
                  color: Colors.blueAccent,
                  title: 'Coach\'s Next Move',
                  content: widget.recap.nextSuggestedGoal,
                ),

                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Return Home'),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppTheme.primaryColor,
                AppTheme.accentColor,
                Colors.white,
                Colors.yellow,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBubble(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 36, color: AppTheme.accentColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color color,
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Personal Records',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...widget.recap.newPrs.map((pr) {
              String prText = '';
              if (pr.prType == 'MaxWeight')
                prText = 'Heaviest Lift: ${pr.value}kg';
              else if (pr.prType == '1RM')
                prText = 'New Est. 1RM: ${pr.value.toStringAsFixed(1)}kg';
              else if (pr.prType == 'MaxVolume')
                prText = 'Volume PR: ${pr.value}kg';

              // We don't have the exercise name in the PR directly, so we just show the type for now.
              // A real app would join this with the exercise library.
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: AppTheme.accentColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(prText, style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
