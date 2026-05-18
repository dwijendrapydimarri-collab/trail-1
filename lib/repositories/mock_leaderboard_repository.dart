import 'package:app/models/user_leaderboard_stats.dart';
import 'package:app/repositories/leaderboard_repository.dart';

class MockLeaderboardRepository implements LeaderboardRepository {
  final List<UserLeaderboardStats> _stats = [
    UserLeaderboardStats(userId: '1', username: 'AlexLift', weeklyVolume: 42500, monthlyVolume: 170000),
    UserLeaderboardStats(userId: '2', username: 'SarahSquats', weeklyVolume: 38200, monthlyVolume: 152000),
    UserLeaderboardStats(userId: '3', username: 'MikeIron', weeklyVolume: 35000, monthlyVolume: 140000),
    UserLeaderboardStats(userId: 'user_123', username: 'You', weeklyVolume: 32000, monthlyVolume: 128000),
    UserLeaderboardStats(userId: '4', username: 'GymBro99', weeklyVolume: 28000, monthlyVolume: 112000),
  ];

  @override
  Stream<List<UserLeaderboardStats>> getWeeklyLeaderboard() {
    return Stream.value(_stats..sort((a, b) => b.weeklyVolume.compareTo(a.weeklyVolume)));
  }

  @override
  Stream<List<UserLeaderboardStats>> getMonthlyLeaderboard() {
    return Stream.value(_stats..sort((a, b) => b.monthlyVolume.compareTo(a.monthlyVolume)));
  }

  @override
  Future<void> updateUserVolume(String userId, double addedVolume) async {
    final index = _stats.indexWhere((s) => s.userId == userId);
    if (index != -1) {
      final current = _stats[index];
      _stats[index] = UserLeaderboardStats(
        userId: current.userId,
        username: current.username,
        weeklyVolume: current.weeklyVolume + addedVolume,
        monthlyVolume: current.monthlyVolume + addedVolume,
      );
    }
  }
}
