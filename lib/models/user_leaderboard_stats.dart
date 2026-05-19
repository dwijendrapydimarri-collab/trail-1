class UserLeaderboardStats {
  final String userId;
  final String username;
  final double weeklyVolume;
  final double monthlyVolume;
  final int currentStreak;
  final int prCount;

  UserLeaderboardStats({
    required this.userId,
    required this.username,
    required this.weeklyVolume,
    required this.monthlyVolume,
    this.currentStreak = 0,
    this.prCount = 0,
  });

  factory UserLeaderboardStats.fromJson(Map<String, dynamic> json) {
    return UserLeaderboardStats(
      userId: json['userId'] as String,
      username: json['username'] as String,
      weeklyVolume: (json['weeklyVolume'] as num).toDouble(),
      monthlyVolume: (json['monthlyVolume'] as num).toDouble(),
      currentStreak: json['currentStreak'] as int? ?? 0,
      prCount: json['prCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'weeklyVolume': weeklyVolume,
      'monthlyVolume': monthlyVolume,
      'currentStreak': currentStreak,
      'prCount': prCount,
    };
  }
}
