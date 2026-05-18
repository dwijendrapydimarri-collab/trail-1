import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:app/models/exercise.dart';

class ExerciseService {
  Future<List<Exercise>> loadExercises() async {
    final String response = await rootBundle.loadString('assets/data/exercises.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Exercise.fromJson(json)).toList();
  }
}
