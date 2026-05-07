import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// MODEL DANYCH
class Task {
  String title;
  String deadline;
  bool done;
  String priority;

  Task({
    required this.title,
    required this.deadline,
    this.done = false,
    required this.priority,
  });
}

/// REPOZYTORIUM ZADAŃ
class TaskRepository {
  static List<Task> tasks = [
    Task(
      title: "Projekt Flutter",
      deadline: "jutro",
      done: false,
      priority: "wysoki",
    ),
    Task(
      title: "Oddać raport",
      deadline: "dzisiaj",
      done: true,
      priority: "wysoki",
    ),
    Task(
      title: "Powtórzyć widgety",
      deadline: "w piątek",
      done: false,
      priority: "średni",
    ),
  ];
}

/// GŁÓWNA APLIKACJA
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

/// EKRAN GŁÓWNY
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
      filteredTasks = TaskRepository.tasks
          .where((task) => task.done)
          .toList();
    } else if (selectedFilter == "do zrobienia") {
      filteredTasks = TaskRepository.tasks
          .where((task) => !task.done)
          .toList();
    }

    int doneCount =
        TaskRepository.tasks.where((task) => task.done).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("KrakFlow"),

        actions: [
          IconButton(
            icon: const Icon(Icons.delete),

            onPressed: () {
              showDialog(
                context: context,

                builder: (context) {
                  return AlertDialog(
                    title: const Text("Potwierdzenie"),

                    content: const Text(
                      "Czy usunąć wszystkie zadania?",
                    ),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text("Anuluj"),
                      ),

                      TextButton(
                        onPressed: () {

                          setState(() {
                            TaskRepository.tasks.clear();
                          });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Usunięto wszystkie zadania",
                              ),
                            ),
                          );
                        },

                        child: const Text("Usuń"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              "Masz dziś ${TaskRepository.tasks.length} zadania ($doneCount wykonane)",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 16),

            const Text(
              "Dzisiejsze zadania",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            /// FILTRY
            Row(
              children: [

                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedFilter = "wszystkie";
                    });
                  },

                  child: Text(
                    "Wszystkie",

                    style: TextStyle(
                      color:
                      selectedFilter == "wszystkie"
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedFilter = "do zrobienia";
                    });
                  },

                  child: Text(
                    "Do zrobienia",

                    style: TextStyle(
                      color:
                      selectedFilter == "do zrobienia"
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedFilter = "wykonane";
                    });
                  },

                  child: Text(
                    "Wykonane",

                    style: TextStyle(
                      color:
                      selectedFilter == "wykonane"
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// LISTA ZADAŃ
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,

                itemBuilder: (context, index) {

                  final task = filteredTasks[index];

                  return Dismissible(

                    key: ValueKey(task.title),

                    direction: DismissDirection.endToStart,

                    onDismissed: (direction) {

                      setState(() {
                        TaskRepository.tasks.remove(task);
                      });

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            "Usunięto ${task.title}",
                          ),
                        ),
                      );
                    },

                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),

                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
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
                            builder: (context) =>
                                EditTaskScreen(task: task),
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

      /// DODAWANIE ZADANIA
      floatingActionButton: FloatingActionButton(

        onPressed: () async {

          final Task? newTask = await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => AddTaskScreen(),
            ),
          );

          if (newTask != null) {

            setState(() {
              TaskRepository.tasks.add(newTask);
            });
          }
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}

/// KARTA ZADANIA
class TaskCard extends StatelessWidget {

  final String title;
  final String subtitle;
  final bool done;

  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.done,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: Padding(
        padding: const EdgeInsets.all(8),

        child: ListTile(

          onTap: onTap,

          leading: Checkbox(
            value: done,
            onChanged: onChanged,
          ),

          title: Text(
            title,

            style: TextStyle(
              fontWeight: FontWeight.bold,

              decoration:
              done
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,

              color:
              done
                  ? Colors.grey
                  : Colors.black,
            ),
          ),

          subtitle: Text(
            subtitle,

            style: TextStyle(
              color:
              done
                  ? Colors.grey
                  : Colors.black,
            ),
          ),

          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

/// DODAWANIE TASKA
class AddTaskScreen extends StatelessWidget {

  AddTaskScreen({super.key});

  final TextEditingController titleController =
  TextEditingController();

  final TextEditingController deadlineController =
  TextEditingController();

  final TextEditingController priorityController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Nowe zadanie"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            TextField(
              controller: titleController,

              decoration: const InputDecoration(
                labelText: "Tytuł zadania",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: deadlineController,

              decoration: const InputDecoration(
                labelText: "Termin",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: priorityController,

              decoration: const InputDecoration(
                labelText: "Priorytet",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(

              onPressed: () {

                final newTask = Task(
                  title: titleController.text,
                  deadline: deadlineController.text,
                  done: false,
                  priority: priorityController.text,
                );

                Navigator.pop(context, newTask);
              },

              child: const Text("Zapisz"),
            ),
          ],
        ),
      ),
    );
  }
}

/// EDYCJA TASKA
class EditTaskScreen extends StatelessWidget {

  final Task task;

  EditTaskScreen({
    super.key,
    required this.task,
  });

  final TextEditingController titleController =
  TextEditingController();

  final TextEditingController deadlineController =
  TextEditingController();

  final TextEditingController priorityController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {

    titleController.text = task.title;
    deadlineController.text = task.deadline;
    priorityController.text = task.priority;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edytuj zadanie"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: titleController,

              decoration: const InputDecoration(
                labelText: "Tytuł",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: deadlineController,

              decoration: const InputDecoration(
                labelText: "Termin",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: priorityController,

              decoration: const InputDecoration(
                labelText: "Priorytet",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(

              onPressed: () {

                task.title = titleController.text;
                task.deadline = deadlineController.text;
                task.priority = priorityController.text;

                Navigator.pop(context);
              },

              child: const Text("Zapisz"),
            ),
          ],
        ),
      ),
    );
  }
}