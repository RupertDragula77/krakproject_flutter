import 'package:flutter/material.dart';
import 'services/task_api_service.dart';

void main() {
  runApp(const MyApp());
}

/// MODEL
class Task {
  String title;
  String deadline;
  bool done;
  String priority;

  Task({
    required this.title,
    required this.deadline,
    required this.done,
    required this.priority,
  });
}

/// APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

/// HOME
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: const Text("KrakFlow"),
      ),
      body: FutureBuilder<List<Task>>(
        future: tasksFuture,
        builder: (context, snapshot) {

          // LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ERROR
          if (snapshot.hasError) {
            return Center(
              child: Text("Błąd: ${snapshot.error}"),
            );
          }

          // DATA
          final tasks = snapshot.data ?? [];

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {

              final task = tasks[index];

              return Card(
                child: ListTile(
                  leading: Icon(
                    task.done
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(task.title),
                  subtitle: Text(task.priority),
                ),
              );
            },
          );
        },
      ),
    );
  }
}