import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/repositories/leaderboard_repository.dart';
import 'package:app/repositories/mock_leaderboard_repository.dart';
import 'package:app/models/user_leaderboard_stats.dart';
// import 'package:app/repositories/firebase_leaderboard_repository.dart';

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  // Using Mock for initial demo/testing without Firebase setup
  // Switch to FirebaseLeaderboardRepository() when Firebase is ready
  return MockLeaderboardRepository();
});

final weeklyLeaderboardProvider = StreamProvider<List<UserLeaderboardStats>>((
  ref,
) {
  final repository = ref.watch(leaderboardRepositoryProvider);
  return repository.getWeeklyLeaderboard();
});

final monthlyLeaderboardProvider = StreamProvider<List<UserLeaderboardStats>>((
  ref,
) {
  final repository = ref.watch(leaderboardRepositoryProvider);
  return repository.getMonthlyLeaderboard();
});
