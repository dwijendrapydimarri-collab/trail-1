class Exercise {
  final String id;
  final String name;
  final String muscleGroup;
  final String equipment;
  final String difficulty;
  final String? imageUrl;
  final String movementPattern;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;

  Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    this.imageUrl,
    this.movementPattern = 'Other',
    this.primaryMuscles = const [],
    this.secondaryMuscles = const [],
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      muscleGroup: json['muscleGroup'] as String,
      equipment: json['equipment'] as String,
      difficulty: json['difficulty'] as String,
      imageUrl: json['imageUrl'] as String?,
      movementPattern: json['movementPattern'] as String? ?? 'Other',
      primaryMuscles:
          (json['primaryMuscles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      secondaryMuscles:
          (json['secondaryMuscles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'muscleGroup': muscleGroup,
      'equipment': equipment,
      'difficulty': difficulty,
      'imageUrl': imageUrl,
      'movementPattern': movementPattern,
      'primaryMuscles': primaryMuscles,
      'secondaryMuscles': secondaryMuscles,
    };
  }
}
