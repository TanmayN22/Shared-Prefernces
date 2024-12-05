import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, String>> tasks = [];
  final TextEditingController taskController = TextEditingController();
  String selectedCategory = 'Easy';

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when the app starts
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTasks = tasks.map((task) => jsonEncode(task)).toList();
    await prefs.setStringList('tasks', encodedTasks);
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks');
    if (savedTasks != null) {
      setState(() {
        tasks = savedTasks.map((task) => jsonDecode(task) as Map<String, String>).toList();
      });
    }
  }

  void _addTask(String task, String category) {
    setState(() {
      tasks.add({'task': task, 'category': category});
      taskController.clear();
      selectedCategory = 'Easy';
    });
    _saveTasks(); // Save tasks after adding a new task
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks(); // Save tasks after deletion
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  hintText: 'Enter task name',
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(),
                ),
                items: ['Easy', 'Medium', 'Hard']
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  _addTask(taskController.text, selectedCategory);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          PopupMenuButton(
            onSelected: (String category) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskScreen(
                    category: category,
                    tasks: tasks.where((task) => task['category'] == category).toList(),
                  ),
                ),
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Easy',
                child: Text('Easy'),
              ),
              const PopupMenuItem(
                value: 'Medium',
                child: Text('Medium'),
              ),
              const PopupMenuItem(
                value: 'Hard',
                child: Text('Hard'),
              ),
            ],
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text('No tasks yet! Click the + button to add one.'),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]['task']!),
                  subtitle: Text('Category: ${tasks[index]['category']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTask(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskScreen extends StatefulWidget {
  final String category;
  final List<Map<String, String>> tasks;

  const TaskScreen({super.key, required this.category, required this.tasks});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Map<String, String>> tasks = []; // Initialize tasks

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load saved tasks when screen initializes
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    // Convert tasks to a list of JSON strings
    final encodedTasks = widget.tasks.map((task) => jsonEncode(task)).toList();
    await prefs.setStringList(widget.category, encodedTasks);
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList(widget.category);

    if (savedTasks != null) {
      setState(() {
        // Decode JSON strings back into maps
        tasks = savedTasks.map((task) => jsonDecode(task) as Map<String, String>).toList();
      });
    } else {
      setState(() {
        tasks = widget.tasks; // Default to tasks passed from CategoryScreen
      });
    }
  }

  void _deleteTask(int index) async {
    setState(() {
      tasks.removeAt(index);
    });
    await _saveTasks(); // Save updated tasks after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Tasks'),
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text('No tasks in this category.'),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]['task']!),
                  subtitle: Text('Category: ${tasks[index]['category']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTask(index),
                  ),
                );
              },
            ),
    );
  }
}
