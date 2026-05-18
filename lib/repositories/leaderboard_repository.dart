import 'package:app/models/user_leaderboard_stats.dart';

abstract class LeaderboardRepository {
  Stream<List<UserLeaderboardStats>> getWeeklyLeaderboard();
  Stream<List<UserLeaderboardStats>> getMonthlyLeaderboard();
  Future<void> updateUserVolume(String userId, double addedVolume);
}
