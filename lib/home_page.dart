import 'dart:math' show Random;

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final List<String> _displaySymbols = List.filled(9, '');

  static bool _isGameOver = false;

  static String _player = '', _computer = '', _winnerMessage = '';

  void _selectPlayer() {
    final List<String> options = ['X', 'O'];

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
                    _player = options.first;
                    _computer = options.last;
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    options.first,
                    style: const TextStyle(fontSize: 75),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _player = options.last;
                    _computer = options.first;
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    options.last,
                    style: const TextStyle(fontSize: 75),
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
      _displaySymbols.fillRange(0, _displaySymbols.length, '');
      _player = _winnerMessage = '';
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
          content: SelectableText(
            _winnerMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 50),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearBoard();
                Navigator.of(context).pop();
                _selectPlayer();
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

  bool _isGameStillPlayable() => _displaySymbols.any((element) => element == '');

  void _checkWin() {
    final Map<String, String> winningMoves = {
      'row1': '${_displaySymbols[0]}${_displaySymbols[1]}${_displaySymbols[2]}',
      'row2': '${_displaySymbols[3]}${_displaySymbols[4]}${_displaySymbols[5]}',
      'row3': '${_displaySymbols[6]}${_displaySymbols[7]}${_displaySymbols[8]}',
      'col1': '${_displaySymbols[0]}${_displaySymbols[3]}${_displaySymbols[6]}',
      'col2': '${_displaySymbols[1]}${_displaySymbols[4]}${_displaySymbols[7]}',
      'col3': '${_displaySymbols[2]}${_displaySymbols[5]}${_displaySymbols[8]}',
      'diag1': '${_displaySymbols[0]}${_displaySymbols[4]}${_displaySymbols[8]}',
      'diag2': '${_displaySymbols[2]}${_displaySymbols[4]}${_displaySymbols[6]}',
    };

    // XXX or OOO
    final String playerWon = _player * 3, computerWon = _computer * 3;

    if (winningMoves.containsValue(playerWon)) {
      _isGameOver = true;
      _winnerMessage = '- you won -';
      _showResult();
    } else if (winningMoves.containsValue(computerWon)) {
      _isGameOver = true;
      _winnerMessage = '- you lost -';
      _showResult();
    } else if (!_isGameStillPlayable()) {
      _isGameOver = true;
      _winnerMessage = '- draw -';
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

          _checkWin();

          /*
          computer's turn
          */
          while (!_isGameOver) {
            int randomBox = Random().nextInt(_displaySymbols.length);

            if (!_isGameStillPlayable()) break;

            if (_displaySymbols[randomBox] == '') {
              _displaySymbols[randomBox] = _computer;
              _checkWin();
              break;
            }
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
        title: InkWell(
          onTap: () => {
            _clearBoard(),
            _selectPlayer(),
          },
          child: Text(widget.title),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (p0, p1) {
          return GridView.builder(
            itemCount: 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: p1.maxWidth / p1.maxHeight,
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
                        color: _displaySymbols[index] == _player
                            ? Colors.red
                            : Colors.green,
                        fontSize: 75,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
