import 'package:flutter/material.dart';
import 'task_repository.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  String priority = "średni";

  void save() {
    TaskRepository.tasks.add(
      Task(
        id: DateTime.now().millisecondsSinceEpoch,
        title: titleController.text,
        deadline: "brak",
        priority: priority,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dodaj task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: priority,
              items: const [
                DropdownMenuItem(value: "niski", child: Text("niski")),
                DropdownMenuItem(value: "średni", child: Text("średni")),
                DropdownMenuItem(value: "wysoki", child: Text("wysoki")),
              ],
              onChanged: (v) => setState(() => priority = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: save, child: const Text("Dodaj")),
          ],
        ),
      ),
    );
  }
}