import 'package:app/models/user_leaderboard_stats.dart';
import 'package:app/models/advanced/intelligence_models.dart';

class RivalGapService {
  RivalGapReport? calculateGap(
    String currentUserId,
    List<UserLeaderboardStats> currentLeaderboard,
  ) {
    if (currentLeaderboard.isEmpty) return null;

    final sorted = List<UserLeaderboardStats>.from(currentLeaderboard)
      ..sort((a, b) => b.monthlyVolume.compareTo(a.monthlyVolume));

    final currentIndex = sorted.indexWhere((s) => s.userId == currentUserId);

    // User is #1 or not found
    if (currentIndex <= 0) return null;

    final currentUser = sorted[currentIndex];
    final rival = sorted[currentIndex - 1];

    final gap = rival.monthlyVolume - currentUser.monthlyVolume;

    // Naive estimation for motivation: average session volume roughly ~10,000kg
    int sessionsNeeded = (gap / 10000).ceil();
    if (sessionsNeeded < 1) sessionsNeeded = 1;

    int setsNeeded = (gap / 500).ceil(); // ~500kg per set

    return RivalGapReport(
      rivalUsername: rival.username,
      volumeGap: gap,
      estimatedSetsNeeded: setsNeeded,
      estimatedSessionsNeeded: sessionsNeeded,
    );
  }
}
