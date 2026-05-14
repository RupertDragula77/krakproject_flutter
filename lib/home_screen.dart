import 'package:flutter/material.dart';
import 'task_repository.dart';
import 'task_card.dart';
import 'edit_task_screen.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "wszystkie";

  List<Task> get filteredTasks {
    if (selectedFilter == "wykonane") {
      return TaskRepository.tasks.where((t) => t.done).toList();
    } else if (selectedFilter == "do zrobienia") {
      return TaskRepository.tasks.where((t) => !t.done).toList();
    }
    return TaskRepository.tasks;
  }

  void refresh() => setState(() {});

  void deleteTask(Task task) {
    TaskRepository.tasks.remove(task);
    setState(() {});
  }

  void deleteAll() {
    TaskRepository.tasks.clear();
    setState(() {});
  }

  void toggleDone(Task task, bool value) {
    task.done = value;
    setState(() {});
  }

  Future<void> openEdit(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KrakFlow"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteAll,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                filterBtn("wszystkie"),
                filterBtn("do zrobienia"),
                filterBtn("wykonane"),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];

                  return Dismissible(
                    key: ValueKey(task.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => deleteTask(task),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: TaskCard(
                      title: task.title,
                      subtitle:
                      "termin: ${task.deadline} | priorytet: ${task.priority}",
                      done: task.done,
                      onChanged: (v) => toggleDone(task, v!),
                      onTap: () => openEdit(task),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget filterBtn(String label) {
    return TextButton(
      onPressed: () => setState(() => selectedFilter = label),
      child: Text(
        label,
        style: TextStyle(
          color: selectedFilter == label ? Colors.blue : Colors.black,
        ),
      ),
    );
  }
}