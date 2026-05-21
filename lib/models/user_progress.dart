class UserProgress {
  final String userId;
  final int totalXp;
  final int currentStreak;
  final DateTime? lastWorkoutDate;
  final int prCount;
  final int eggs;
  final int totalEggsEarned;

  UserProgress({
    required this.userId,
    this.totalXp = 0,
    this.currentStreak = 0,
    this.lastWorkoutDate,
    this.prCount = 0,
    this.eggs = 0,
    this.totalEggsEarned = 0,
  });

  int get level => (totalXp / 1000).floor() + 1;
  String get division {
    if (level >= 50) return 'Elite';
    if (level >= 40) return 'Platinum';
    if (level >= 30) return 'Gold';
    if (level >= 15) return 'Silver';
    return 'Bronze';
  }

  UserProgress copyWith({
    String? userId,
    int? totalXp,
    int? currentStreak,
    DateTime? lastWorkoutDate,
    int? prCount,
    int? eggs,
    int? totalEggsEarned,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      totalXp: totalXp ?? this.totalXp,
      currentStreak: currentStreak ?? this.currentStreak,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      prCount: prCount ?? this.prCount,
      eggs: eggs ?? this.eggs,
      totalEggsEarned: totalEggsEarned ?? this.totalEggsEarned,
    );
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'] as String,
      totalXp: json['totalXp'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      lastWorkoutDate: json['lastWorkoutDate'] != null
          ? DateTime.parse(json['lastWorkoutDate'])
          : null,
      prCount: json['prCount'] as int? ?? 0,
      eggs: json['eggs'] as int? ?? 0,
      totalEggsEarned: json['totalEggsEarned'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalXp': totalXp,
      'currentStreak': currentStreak,
      'lastWorkoutDate': lastWorkoutDate?.toIso8601String(),
      'prCount': prCount,
      'eggs': eggs,
      'totalEggsEarned': totalEggsEarned,
    };
  }
}
