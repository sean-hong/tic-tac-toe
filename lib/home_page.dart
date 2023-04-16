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

  void _checkWin() {
    if (_filledBoxes == 9) {
      print('draw');
    }

    String row1 = '${_displaySymbols[0]}${_displaySymbols[1]}${_displaySymbols[2]}';
    String row2 = '${_displaySymbols[3]}${_displaySymbols[4]}${_displaySymbols[5]}';
    String row3 = '${_displaySymbols[6]}${_displaySymbols[7]}${_displaySymbols[8]}';

    String col1 = '${_displaySymbols[0]}${_displaySymbols[3]}${_displaySymbols[6]}';
    String col2 = '${_displaySymbols[1]}${_displaySymbols[4]}${_displaySymbols[7]}';
    String col3 = '${_displaySymbols[2]}${_displaySymbols[5]}${_displaySymbols[8]}';

    String diag1 = '${_displaySymbols[0]}${_displaySymbols[4]}${_displaySymbols[8]}';
    String diag2 = '${_displaySymbols[2]}${_displaySymbols[4]}${_displaySymbols[6]}';

    if (row1 == 'XXX' || row2 == 'XXX' || row3 == 'XXX' || col1 == 'XXX' || col2 == 'XXX' || col3 == 'XXX' || diag1 == 'XXX' || diag2 == 'XXX') {
      print('X won');
    }

    if (row1 == 'OOO' || row2 == 'OOO' || row3 == 'OOO' || col1 == 'OOO' || col2 == 'OOO' || col3 == 'OOO' || diag1 == 'OOO' || diag2 == 'OOO') {
      print('O won');
    }
  }

  void _enteredSymbol(int index) {
    setState(() {
      if (_displaySymbols[index] == '') {
        _displaySymbols[index] = _player;
        _filledBoxes++;

        /*
        computer's turn
        */
        bool foundEmptyBox = false;

        while (!foundEmptyBox) {
          int randomBox = Random().nextInt(_displaySymbols.length);

          if (_filledBoxes == 9) break;

          if (_displaySymbols[randomBox] == '') {
            foundEmptyBox = true;
            _displaySymbols[randomBox] = _computer;
            _filledBoxes++;
          }
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
