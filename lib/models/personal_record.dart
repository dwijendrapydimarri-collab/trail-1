class PersonalRecord {
  final String exerciseId;
  final String prType; // e.g., '1RM', 'MaxWeight', 'MaxVolume'
  final double value; // Can be weight, 1RM, or volume depending on type
  final double weight;
  final int reps;
  final double estimatedOneRepMax;
  final DateTime achievedAt;

  PersonalRecord({
    required this.exerciseId,
    this.prType = '1RM',
    this.value = 0.0,
    required this.weight,
    required this.reps,
    required this.estimatedOneRepMax,
    required this.achievedAt,
  });

  factory PersonalRecord.fromJson(Map<String, dynamic> json) {
    return PersonalRecord(
      exerciseId: json['exerciseId'] as String,
      prType: json['prType'] as String? ?? '1RM',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num).toDouble(),
      reps: json['reps'] as int,
      estimatedOneRepMax: (json['estimatedOneRepMax'] as num).toDouble(),
      achievedAt: DateTime.parse(json['achievedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'prType': prType,
      'value': value,
      'weight': weight,
      'reps': reps,
      'estimatedOneRepMax': estimatedOneRepMax,
      'achievedAt': achievedAt.toIso8601String(),
    };
  }
}
