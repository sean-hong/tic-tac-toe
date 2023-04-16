import 'package:flutter/material.dart';
import 'dart:math' show Random;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final List<String> _displaySymbols = ['', '', '', '', '', '', '', '', ''];
  static int _filledBoxes = 0;

  static bool _isGameOver = false;

  static late String _player, _computer;

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
            style: TextStyle(fontSize: 75),
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
                    style: TextStyle(fontSize: 75),
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
                    style: TextStyle(fontSize: 75),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showResult(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Game Over',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 75,
              color: Colors.brown,
            ),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 50,
              color: Colors.black,
              backgroundColor: Colors.yellow,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => setState(() {}),
              child: const Text(
                'play again?',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  void _checkWin() {
    String row1 = '${_displaySymbols[0]}${_displaySymbols[1]}${_displaySymbols[2]}';
    String row2 = '${_displaySymbols[3]}${_displaySymbols[4]}${_displaySymbols[5]}';
    String row3 = '${_displaySymbols[6]}${_displaySymbols[7]}${_displaySymbols[8]}';

    String col1 = '${_displaySymbols[0]}${_displaySymbols[3]}${_displaySymbols[6]}';
    String col2 = '${_displaySymbols[1]}${_displaySymbols[4]}${_displaySymbols[7]}';
    String col3 = '${_displaySymbols[2]}${_displaySymbols[5]}${_displaySymbols[8]}';

    String diag1 = '${_displaySymbols[0]}${_displaySymbols[4]}${_displaySymbols[8]}';
    String diag2 = '${_displaySymbols[2]}${_displaySymbols[4]}${_displaySymbols[6]}';

    List<String> winningMoves = [row1, row2, row3, col1, col2, col3, diag1, diag2];

    if (winningMoves.contains('XXX')) {
      _isGameOver = true;
      showResult('X won');
    } else if (winningMoves.contains('OOO')) {
      _isGameOver = true;
      showResult('O won');
    } else if (_filledBoxes == 9) {
      _isGameOver = true;
      showResult('Draw');
    } else {
      print('box being filled');
    }
  }

  void _enteredSymbol(int index) {
    setState(() {
      if (_displaySymbols[index] == '') {
        _displaySymbols[index] = _player;
        _filledBoxes++;

        _checkWin();

        /*
        computer's turn
        */
        bool foundEmptyBox = false;

        while (!foundEmptyBox && !_isGameOver) {
          int randomBox = Random().nextInt(_displaySymbols.length);

          if (_filledBoxes == 9) break;

          if (_displaySymbols[randomBox] == '') {
            foundEmptyBox = true;
            _displaySymbols[randomBox] = _computer;
            _filledBoxes++;
          }

          _checkWin();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Future(_selectPlayer);
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
            Expanded(
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2.1,
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _enteredSymbol(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _displaySymbols[index],
                          style: TextStyle(
                            color: _displaySymbols[index] == 'X'
                                ? Colors.red
                                : Colors.green,
                            fontSize: 75,
                          ),
                        ),
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
