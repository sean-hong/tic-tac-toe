import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _player;
  late String _computer;

  void _setPlayer(String symbol) => _player = symbol;
  void _setComputer(String symbol) => _computer = symbol;

  void _selectPlayer() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select Player',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 35),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    _setPlayer('X');
                    _setComputer('O');
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'X',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _setPlayer('O');
                    _setComputer('X');
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'O',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ],
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'test',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectPlayer,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
