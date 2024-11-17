import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<String> notes = [];

  void _addNotes() {
    setState(() {
      notes.add("Notes ${notes.length + 1}");
    });
  }

  Future saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("note", notes);
  }

  Future loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = prefs.getStringList('note') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(notes[index]),
                    onLongPress: () {
                      setState(() {
                        notes.removeAt(index);
                      });
                      saveNotes();
                    },
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
                onPressed: () {
                  _addNotes();
                  saveNotes();
                },
                child: const Icon(Icons.add)),
          ),
        ],
      ),
    );
  }
}
