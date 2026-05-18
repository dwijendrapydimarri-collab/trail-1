import 'package:app/models/routine.dart';

class WorkoutSession {
  final String id;
  final Routine routine;
  final DateTime startTime;
  final DateTime? endTime;

  WorkoutSession({
    required this.id,
    required this.routine,
    required this.startTime,
    this.endTime,
  });

  WorkoutSession copyWith({
    String? id,
    Routine? routine,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      routine: routine ?? this.routine,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'] as String,
      routine: Routine.fromJson(json['routine'] as Map<String, dynamic>),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routine': routine.toJson(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }
}
