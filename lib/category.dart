import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> Tasks = [];
  final TextEditingController taskcontroller = TextEditingController();

  void _addTasks(String Tasks) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          PopupMenuButton(
              onSelected: (String category) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TaskScreen(category: category)));
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
                    )
                  ]),
        ],
      ),
      body: const Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the add button
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskScreen extends StatefulWidget {
  final String category;
  const TaskScreen({super.key, required this.category});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
    );
  }
}
