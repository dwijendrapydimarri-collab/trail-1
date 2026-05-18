import 'package:app/models/exercise.dart';
import 'package:app/models/set_log.dart';

class RoutineExercise {
  final Exercise exercise;
  final List<SetLog> sets;

  RoutineExercise({
    required this.exercise,
    required this.sets,
  });

  RoutineExercise copyWith({
    Exercise? exercise,
    List<SetLog>? sets,
  }) {
    return RoutineExercise(
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets,
    );
  }

  factory RoutineExercise.fromJson(Map<String, dynamic> json) {
    return RoutineExercise(
      exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
      sets: (json['sets'] as List<dynamic>)
          .map((e) => SetLog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise': exercise.toJson(),
      'sets': sets.map((e) => e.toJson()).toList(),
    };
  }
}

class Routine {
  final String id;
  final String name;
  final List<RoutineExercise> exercises;

  Routine({
    required this.id,
    required this.name,
    required this.exercises,
  });

  Routine copyWith({
    String? id,
    String? name,
    List<RoutineExercise>? exercises,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
    );
  }

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] as String,
      name: json['name'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => RoutineExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}
