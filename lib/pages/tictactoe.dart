import 'dart:math';

import 'package:flutter/material.dart';
import 'package:world_time/tictactoe/grid_cell.dart';
import 'package:world_time/utils/common.dart';

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  final double _symbolSize = 80;

  late List<List<GridCell>> _grid;
  late String currentPlayer;

  String? gameText;

  @override
  void initState() {
    super.initState();
    var rand = Random();
    currentPlayer = rand.nextBool() ? 'X' : 'O';
    _grid = List<List<GridCell>>.generate(3,
            (x) => List<GridCell>.generate(3,
                (y) => GridCell(
                build: () => TextButton(
                    child: Text(''),
                    onPressed: () {
                      setState(() {
                        currentPlayer == 'X'
                            ? _grid[x][y].setX()
                            : _grid[x][y].setO();

                        String? winner = checkWinner();
                        if(winner == 'tie'){
                          gameText = "It's a tie";
                        }
                        else if (winner == null) {
                          // next player
                          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
                        }
                        else{
                          //show winner
                          gameText = '$winner Win!';
                        }
                      });
                    })
            )
        )
    );
  }

  String? checkWinner() {
    for (int i = 0; i < _grid.length; i++) {
      // horizontal
      if (equals(_grid[i][0].value, _grid[i][1].value, _grid[i][2].value, true)) {
        _grid[i][0].setRed();
        _grid[i][1].setRed();
        _grid[i][2].setRed();
        return _grid[i][0].value;
      }
      else if (equals(
          _grid[0][i].value, _grid[1][i].value, _grid[2][i].value, true)) {
        _grid[0][i].setRed();
        _grid[1][i].setRed();
        _grid[2][i].setRed();
        return _grid[0][i].value;
      }
    }

    // diagonal
    if (equals(_grid[0][0].value, _grid[1][1].value, _grid[2][2].value, true)) {
      _grid[0][0].setRed();
      _grid[1][1].setRed();
      _grid[2][2].setRed();
      return _grid[0][0].value;
    }
    else if (equals(
        _grid[2][0].value, _grid[1][1].value, _grid[0][2].value, true)) {
      _grid[2][0].setRed();
      _grid[1][1].setRed();
      _grid[0][2].setRed();
      return _grid[2][0].value;
    }
    else if (_grid.every((row) => row.every((cell) => cell.value != null))) {
      return 'tie';
    }
    else {
      return null;
    }
  }

  List<Widget> makeGrid() {
    List<Widget> list = [];
    for (int i = 0; i < _grid.length; i++) {
      List<Widget> row = [];
      for (int j = 0; j < _grid[i].length; j++) {
        row.add(Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: j == 1 // if middle cell, draw left & right border
                      ? Border.symmetric(
                      vertical: BorderSide(color: Colors.black, width: 3))
                      : null),
              child: _grid[i][j].widget,
            )));
        // row.add(Expanded(child: _grid[i][j]));
      }

      list.add(Container(
        height: 100,
        decoration: BoxDecoration(
            border: i == 1 // if middle row, draw top & bottom border
                ? Border.symmetric(
                horizontal: BorderSide(color: Colors.black, width: 3))
                : null),
        child:
        Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: row),
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic Tac Toe'), centerTitle: true),
      body: Container(
        margin: EdgeInsets.all(30),
        // padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...makeGrid(),
              SizedBox(height: 30),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'Current Player: ', style: TextStyle(fontSize: 30)),
                WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      currentPlayer == 'X' ? Icons.close : Icons.circle_outlined,
                      size: _symbolSize,
                    ))
              ])),
              Center(
                child: Text(
                  gameText != null ? '- - - $gameText - - -' : '',
                  style: TextStyle(fontSize: 35),
                ),
              ),
              SizedBox(height: 20),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/tictactoe');
                  },
                  icon: Icon(Icons.replay),
                  label: Text(
                    'Restart',
                    style: TextStyle(fontSize: 25),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}


