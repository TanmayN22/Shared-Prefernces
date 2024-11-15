import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  bool isdark = false;

  Future saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("theme", value);
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isdark = prefs.getBool("theme") ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isdark ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Theme'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: ElevatedButton(
            onPressed: () {
              setState(() {
                isdark = !isdark;
              });
              saveTheme(isdark);
            },
            child: const Icon(
              Icons.change_circle_outlined,
            )),
      ),
    );
  }
}
