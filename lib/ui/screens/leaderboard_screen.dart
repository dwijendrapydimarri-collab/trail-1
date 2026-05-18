import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/leaderboard_providers.dart';
import 'package:app/models/user_leaderboard_stats.dart';
import 'package:app/ui/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentColor,
          labelColor: AppTheme.accentColor,
          unselectedLabelColor: AppTheme.textSecondaryColor,
          tabs: const [
            Tab(text: 'Weekly Volume'),
            Tab(text: 'Monthly Volume'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboardList(ref.watch(weeklyLeaderboardProvider), true),
          _buildLeaderboardList(ref.watch(monthlyLeaderboardProvider), false),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(
    AsyncValue<List<UserLeaderboardStats>> asyncStats,
    bool isWeekly,
  ) {
    return asyncStats.when(
      data: (stats) {
        if (stats.isEmpty) {
          return const Center(child: Text('No data yet'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            final rank = index + 1;
            final volume = isWeekly ? stat.weeklyVolume : stat.monthlyVolume;
            // In a real app we'd compare stat.userId with current user's ID
            final isCurrentUser = stat.username == 'You';

            return _buildLeaderboardCard(stat, rank, volume, isCurrentUser);
          },
        );
      },
      loading: () => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: 5,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: AppTheme.surfaceColor,
          highlightColor: AppTheme.surfaceColor.withOpacity(0.5),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(height: 80),
          ),
        ),
      ),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildLeaderboardCard(
    UserLeaderboardStats stat,
    int rank,
    double volume,
    bool isCurrentUser,
  ) {
    final rankColor = _getRankColor(rank);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: isCurrentUser
            ? LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.4),
                  AppTheme.accentColor.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isCurrentUser ? null : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: isCurrentUser
            ? Border.all(color: AppTheme.accentColor, width: 1.5)
            : null,
        boxShadow: isCurrentUser
            ? [
                BoxShadow(
                  color: AppTheme.accentColor.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ]
            : [],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: rankColor ?? AppTheme.backgroundColor,
          child: Text(
            '#$rank',
            style: TextStyle(
              color: rankColor != null ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Text(
              stat.username,
              style: TextStyle(
                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
            if (isCurrentUser)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'YOU',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(volume / 1000).toStringAsFixed(1)}k kg',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.accentColor,
              ),
            ),
            const Text(
              'Lifted',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return null;
    }
  }
}
