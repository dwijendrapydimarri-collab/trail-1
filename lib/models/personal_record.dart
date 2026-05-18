class PersonalRecord {
  final String exerciseId;
  final double weight;
  final int reps;
  final double estimatedOneRepMax;
  final DateTime achievedAt;

  PersonalRecord({
    required this.exerciseId,
    required this.weight,
    required this.reps,
    required this.estimatedOneRepMax,
    required this.achievedAt,
  });

  factory PersonalRecord.fromJson(Map<String, dynamic> json) {
    return PersonalRecord(
      exerciseId: json['exerciseId'] as String,
      weight: (json['weight'] as num).toDouble(),
      reps: json['reps'] as int,
      estimatedOneRepMax: (json['estimatedOneRepMax'] as num).toDouble(),
      achievedAt: DateTime.parse(json['achievedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'weight': weight,
      'reps': reps,
      'estimatedOneRepMax': estimatedOneRepMax,
      'achievedAt': achievedAt.toIso8601String(),
    };
  }
}
