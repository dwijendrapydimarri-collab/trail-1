import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/user_leaderboard_stats.dart';
import 'package:app/repositories/leaderboard_repository.dart';

class FirebaseLeaderboardRepository implements LeaderboardRepository {
  final FirebaseFirestore _firestore;

  FirebaseLeaderboardRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<UserLeaderboardStats>> getWeeklyLeaderboard() {
    return _firestore
        .collection('leaderboards')
        .orderBy('weeklyVolume', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => UserLeaderboardStats.fromJson(doc.data()))
              .toList();
        });
  }

  @override
  Stream<List<UserLeaderboardStats>> getMonthlyLeaderboard() {
    return _firestore
        .collection('leaderboards')
        .orderBy('monthlyVolume', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => UserLeaderboardStats.fromJson(doc.data()))
              .toList();
        });
  }

  @override
  Future<void> updateUserVolume(String userId, double addedVolume) async {
    final docRef = _firestore.collection('leaderboards').doc(userId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        transaction.set(docRef, {
          'userId': userId,
          'username': 'User_$userId', // Or fetch from profile
          'weeklyVolume': addedVolume,
          'monthlyVolume': addedVolume,
        });
        return;
      }
      final currentWeekly = snapshot.data()?['weeklyVolume'] ?? 0.0;
      final currentMonthly = snapshot.data()?['monthlyVolume'] ?? 0.0;
      transaction.update(docRef, {
        'weeklyVolume': currentWeekly + addedVolume,
        'monthlyVolume': currentMonthly + addedVolume,
      });
    });
  }
}
