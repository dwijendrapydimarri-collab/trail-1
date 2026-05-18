class SetLog {
  final String id;
  final double weight;
  final int reps;
  final bool isCompleted;

  SetLog({
    required this.id,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
  });

  SetLog copyWith({String? id, double? weight, int? reps, bool? isCompleted}) {
    return SetLog(
      id: id ?? this.id,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory SetLog.fromJson(Map<String, dynamic> json) {
    return SetLog(
      id: json['id'] as String,
      weight: (json['weight'] as num).toDouble(),
      reps: json['reps'] as int,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': weight,
      'reps': reps,
      'isCompleted': isCompleted,
    };
  }
}
