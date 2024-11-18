import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _counter = 0;
  int _highScore = 0;

  Future saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("highscore", _highScore);
  }

  Future loadhighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt("highscore") ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    loadhighScore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(230, 10, 0, 322),
            child: Text(
              'Highest Score: $_highScore',
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
          Text(
            '$_counter',
            style: const TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 276),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _counter++;
                    if (_counter > _highScore) {
                      _highScore = _counter;
                      saveHighScore();
                    }
                  });
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(
                width: 40,
              )
            ],
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
