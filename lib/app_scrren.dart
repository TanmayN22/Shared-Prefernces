import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  String? _savedData;

  Future saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    setState(() {
      _savedData = value;
    });
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final saveData = prefs.getString("name");
    setState(() {
      _savedData = saveData;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Name"),
      ),
      body: Center(
        child: Text(_savedData ?? 'No Data Saved'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveData("name", 'Tanmay');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
