import 'package:flutter/material.dart';
import 'task_repository.dart';
import 'task_card.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "wszystkie";

  @override
  Widget build(BuildContext context) {

    List<Task> filteredTasks = TaskRepository.tasks;

    if (selectedFilter == "wykonane") {
      filteredTasks = TaskRepository.tasks.where((t) => t.done).toList();
    } else if (selectedFilter == "do zrobienia") {
      filteredTasks = TaskRepository.tasks.where((t) => !t.done).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("KrakFlow"),

        actions: [
          IconButton(
            icon: const Icon(Icons.delete),

            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Potwierdzenie"),
                  content: const Text("Usunąć wszystkie zadania?"),

                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Anuluj"),
                    ),

                    TextButton(
                      onPressed: () {
                        setState(() {
                          TaskRepository.tasks.clear();
                        });

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Usunięto wszystkie zadania"),
                          ),
                        );
                      },
                      child: const Text("Usuń"),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Row(
              children: [

                TextButton(
                  onPressed: () {
                    setState(() => selectedFilter = "wszystkie");
                  },
                  child: Text(
                    "Wszystkie",
                    style: TextStyle(
                      color: selectedFilter == "wszystkie"
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    setState(() => selectedFilter = "do zrobienia");
                  },
                  child: Text(
                    "Do zrobienia",
                    style: TextStyle(
                      color: selectedFilter == "do zrobienia"
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    setState(() => selectedFilter = "wykonane");
                  },
                  child: Text(
                    "Wykonane",
                    style: TextStyle(
                      color: selectedFilter == "wykonane"
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,

                itemBuilder: (context, index) {
                  final task = filteredTasks[index];

                  return Dismissible(
                    key: ValueKey(task.title),
                    direction: DismissDirection.endToStart,

                    onDismissed: (_) {
                      setState(() {
                        TaskRepository.tasks.remove(task);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Usunięto ${task.title}")),
                      );
                    },

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

                      onChanged: (value) {
                        setState(() {
                          task.done = value!;
                        });
                      },

                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditTaskScreen(task: task),
                          ),
                        );

                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}