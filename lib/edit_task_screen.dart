import 'package:flutter/material.dart';
import 'task_repository.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController title;
  late TextEditingController deadline;
  late TextEditingController priority;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.task.title);
    deadline = TextEditingController(text: widget.task.deadline);
    priority = TextEditingController(text: widget.task.priority);
  }

  void save() {
    setState(() {
      widget.task.title = title.text;
      widget.task.deadline = deadline.text;
      widget.task.priority = priority.text;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edytuj task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: title),
            TextField(controller: deadline),
            TextField(controller: priority),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: save, child: const Text("Zapisz")),
          ],
        ),
      ),
    );
  }
}