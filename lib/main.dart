import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Task {
  String title;
  bool isDone;

  Task({
    required this.title,
    this.isDone = false,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Первое Flutter приложение',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();

  final List<Task> _tasks = [
    Task(title: 'Разобраться с Flutter'),
    Task(title: 'Сделать первое приложение'),
    Task(title: 'Запустить на телефоне'),
  ];

  void _addTask() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      _tasks.add(Task(title: text));
      _controller.clear();
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  int get _completedCount {
    return _tasks.where((task) => task.isDone).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои задачи'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Выполнено: $_completedCount из ${_tasks.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Новая задача',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Добавить'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'Задач пока нет',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];

                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: task.isDone,
                              onChanged: (_) => _toggleTask(index),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteTask(index),
                            ),
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