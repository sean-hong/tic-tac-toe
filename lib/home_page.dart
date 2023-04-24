import 'dart:math' show Random;

import 'package:flutter/material.dart';

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

  static String _player = '', _computer = '', _winnerMessage = '';

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

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < _displaySymbols.length; i++) {
        _displaySymbols[i] = '';
      }

      _winnerMessage = '';
      _filledBoxes = 0;
      _isGameOver = false;
    });
  }

  void _showResult() {
    showDialog(
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
            _winnerMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 50,
              color: Colors.black,
              backgroundColor: Colors.yellow,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearBoard();
                Navigator.of(context).pop();
              },
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
      _winnerMessage = 'X won';
      _showResult();
    } else if (winningMoves.contains('OOO')) {
      _isGameOver = true;
      _winnerMessage = 'O won';
      _showResult();
    } else if (_filledBoxes == 9) {
      _isGameOver = true;
      _winnerMessage = 'Draw';
      _showResult();
    } else {
      return;
    }
  }

  void _enteredSymbol(int index) {
    setState(() {
      if (_displaySymbols[index] == '') {
        if (!_isGameOver) {
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
        } else {
          _showResult();
        }
      } else {
        if (_isGameOver) _showResult();
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
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + kToolbarHeight)),
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
    );
  }
}
