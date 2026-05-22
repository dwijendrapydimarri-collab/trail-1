import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

// Dummy user class for demo purposes
class LeaderboardUser {
  final String id;
  final String name;
  final int level;
  final double volume;

  LeaderboardUser(this.id, this.name, this.level, this.volume);
}

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Generate dummy rivals for UI demo
    final rivals = [
      LeaderboardUser('1', 'ChadThundercock', 42, 12500),
      LeaderboardUser('2', 'GymBro99', 38, 11200),
      LeaderboardUser('user', 'You', 15, 9500),
      LeaderboardUser('4', 'IronMaiden', 20, 8000),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard'), centerTitle: true),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  const Text(
                    '🏆 RIVAL ALERT 🏆',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You are 1,700kg of volume away from overtaking GymBro99!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Routine cloned!')),
                      );
                    },
                    child: const Text('CLONE THEIR ROUTINE'),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final rival = rivals[index];
              final isMe = rival.id == 'user';
              return _LeaderboardRow(rival: rival, rank: index + 1, isMe: isMe);
            }, childCount: rivals.length),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatefulWidget {
  final LeaderboardUser rival;
  final int rank;
  final bool isMe;

  const _LeaderboardRow({
    required this.rival,
    required this.rank,
    required this.isMe,
  });

  @override
  State<_LeaderboardRow> createState() => _LeaderboardRowState();
}

class _LeaderboardRowState extends State<_LeaderboardRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _kudosSent = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendKudos() async {
    if (_kudosSent) return;

    try {
      bool? hasVibrator = await HapticFeedback.heavyImpact()
          .then((_) => true)
          .catchError((_) => false);
      // We just call it and catch errors if simulator lacks it.
    } catch (e) {
      // Ignore vibration error on simulators
    }

    setState(() => _kudosSent = true);
    _controller.forward(from: 0.0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kudos sent to ${widget.rival.name}! (Syncing...)'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: widget.isMe
          ? Colors.teal.withOpacity(0.2)
          : const Color(0xFF1E1E1E),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: widget.rank == 1
              ? Colors.amber
              : (widget.rank == 2 ? Colors.grey[400] : Colors.brown),
          child: Text(
            '#${widget.rank}',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          widget.rival.name,
          style: TextStyle(
            fontWeight: widget.isMe ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text('Lvl ${widget.rival.level} • ${widget.rival.volume}kg'),
        trailing: widget.isMe
            ? null
            : IconButton(
                icon: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_controller.value * 0.5),
                      child: Icon(
                        _kudosSent
                            ? Icons.local_fire_department
                            : Icons.favorite_border,
                        color: _kudosSent ? Colors.orange : Colors.grey,
                      ),
                    );
                  },
                ),
                onPressed: _sendKudos,
              ),
      ),
    );
  }
}
