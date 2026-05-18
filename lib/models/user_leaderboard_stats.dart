class UserLeaderboardStats {
  final String userId;
  final String username;
  final double weeklyVolume;
  final double monthlyVolume;

  UserLeaderboardStats({
    required this.userId,
    required this.username,
    required this.weeklyVolume,
    required this.monthlyVolume,
  });

  factory UserLeaderboardStats.fromJson(Map<String, dynamic> json) {
    return UserLeaderboardStats(
      userId: json['userId'] as String,
      username: json['username'] as String,
      weeklyVolume: (json['weeklyVolume'] as num).toDouble(),
      monthlyVolume: (json['monthlyVolume'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'weeklyVolume': weeklyVolume,
      'monthlyVolume': monthlyVolume,
    };
  }
}
