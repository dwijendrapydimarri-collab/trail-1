
class EggTransaction {
  final String id;
  final int amount;
  final String reason;
  final DateTime timestamp;

  EggTransaction({
    required this.id,
    required this.amount,
    required this.reason,
    required this.timestamp,
  });
}

class EggLedgerService {
  final List<EggTransaction> _transactions = [];

  int get currentBalance {
    return _transactions.fold(0, (sum, tx) => sum + tx.amount);
  }

  void addTransaction(EggTransaction tx) {
    _transactions.add(tx);
  }

  List<EggTransaction> get history => List.unmodifiable(_transactions);
}

class LeaderboardSnapshot {
  final String id;
  final String timeframe; // weekly, monthly, all_time
  final Map<String, double> rankings; // userId -> volume/score
  final DateTime generatedAt;

  LeaderboardSnapshot({
    required this.id,
    required this.timeframe,
    required this.rankings,
    required this.generatedAt,
  });
}

class LeaderboardProjectionEngine {
  LeaderboardSnapshot generateSnapshot(String timeframe, Map<String, List<Map<String, dynamic>>> allSessions) {
    Map<String, double> rankings = {};

    allSessions.forEach((userId, sessions) {
      double totalVolume = 0;
      for (var session in sessions) {
        if (session['sets'] != null) {
          for (var set in session['sets']) {
            final double weight = (set['weight'] as num?)?.toDouble() ?? 0.0;
            final int reps = (set['reps'] as num?)?.toInt() ?? 0;
            totalVolume += weight * reps;
          }
        }
      }
      rankings[userId] = totalVolume;
    });

    return LeaderboardSnapshot(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timeframe: timeframe,
      rankings: rankings,
      generatedAt: DateTime.now(),
    );
  }
}
