import '../main.dart';

class TaskRepository {
  static List<Task> tasks = [];
}

class Task {
  int id;
  String title;
  String deadline;
  bool done;
  String priority;

  Task({
    required this.id,
    required this.title,
    required this.deadline,
    this.done = false,
    required this.priority,
  });
}