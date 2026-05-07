import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_api_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() =>
      _TaskListScreenState();
}

class _TaskListScreenState
    extends State<TaskListScreen> {

  late Future<List<Task>> tasksFuture;

  @override
  void initState() {
    super.initState();

    tasksFuture = TaskApiService.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Taski z API"),
      ),
      body: FutureBuilder<List<Task>>(
        future: tasksFuture,
        builder: (context, snapshot) {

          // loader
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Błąd: ${snapshot.error}",
              ),
            );
          }

          // data
          final tasks = snapshot.data ?? [];

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {

              final task = tasks[index];

              return ListTile(
                title: Text(task.title),

                subtitle: Text(
                  "Priorytet: ${task.priority}",
                ),

                trailing: Icon(
                  task.done
                      ? Icons.check
                      : Icons.close,
                  color: task.done
                      ? Colors.green
                      : Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }
}