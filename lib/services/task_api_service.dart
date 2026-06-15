import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../main.dart'; // Task

class TaskApiService {
  static const String baseUrl = "https://dummyjson.com";

  static Future<List<Task>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/todos"));
      if (response.statusCode != 200) {
        throw Exception("Błąd HTTP ${response.statusCode}");
      }
      final data = jsonDecode(response.body);
      final List todos = data["todos"];
      final random = Random();
      final priorities = ["niski", "średni", "wysoki"];

      final tasks = todos.map((todo) {
        return Task(
          id: todo["id"],
          title: todo["todo"],
          deadline: "brak",
          done: todo["completed"],
          priority: priorities[random.nextInt(priorities.length)],
        );
      }).toList();
      return tasks;
    } catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Błąd podczas pobierania zadań z API',
      );
      rethrow;
    }
  }
}