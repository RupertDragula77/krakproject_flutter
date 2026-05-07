import 'package:flutter/material.dart';
import 'task_repository.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController deadlineController;
  late TextEditingController priorityController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.task.title);
    deadlineController = TextEditingController(text: widget.task.deadline);
    priorityController = TextEditingController(text: widget.task.priority);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edytuj task")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(controller: titleController),
            TextField(controller: deadlineController),
            TextField(controller: priorityController),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.task.title = titleController.text;
                  widget.task.deadline = deadlineController.text;
                  widget.task.priority = priorityController.text;
                });

                Navigator.pop(context);
              },
              child: const Text("Zapisz"),
            )
          ],
        ),
      ),
    );
  }
}