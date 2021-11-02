import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world_time/snake/snake_player.dart';
import 'package:world_time/utils/common.dart';

class Snake extends StatefulWidget {
  @override
  _SnakeState createState() => _SnakeState();
}

class _SnakeState extends State<Snake> {
  final int pixels = 20;
  late SnakePlayer sp;
  Timer? _timer;

  List<Widget> makeGrid(){
    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;
    int minSize = (screenW < screenH ? screenW : screenH).floor()-20;
    double cellSize = minSize / pixels;

    List<List<Widget>> grid = List<List<Widget>>.generate(pixels, (y) {
      return List<Widget>.generate(pixels, (x) {
        Color cellColor;
        Widget child = Text('');

        if ((sp.x == x && sp.y == y)) { // snake head position
          cellColor = Colors.amber;
          child = Text('\u{1F440}');
        }
        else if(sp.tail.any((pos) => pos.x == x && pos.y == y)){ // snake tail path
          cellColor = Colors.amber;
        }
        else if (sp.snakeFood.x == x && sp.snakeFood.y == y) // snake food position
          cellColor = Colors.deepPurpleAccent;
        else
          cellColor = Colors.transparent;

        return Container(
          width: cellSize, height: cellSize,
          child: child,
          decoration: BoxDecoration(border: Border.all(color: Colors.black), color: cellColor),
        );
      }).toList();
    }).toList();

    return grid.map((row) => Row(children: row)).toList();
  }

  void startSnake(){
    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() => sp.move());
    });
  }

  void gameOver(){
    _timer?.cancel();
    print('game over');
    showSnackBar(context: context, text: 'You Lose! \u{1F47F}');
  }

  void winGame(){
    _timer?.cancel();
    print('win game!');
    showSnackBar(context: context, text: 'You Won! \u{1F47C}');
  }

  @override
  void initState() {
    super.initState();
    sp = SnakePlayer(gridCount: pixels, gameOver: gameOver, winGame: winGame);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      startSnake();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Snake Game'), centerTitle: true),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('score: ${sp.length - 1}', style: TextStyle(fontSize: 25),),
                TextButton.icon(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, '/snake');
                    },
                    icon: Icon(Icons.replay),
                    label: Text('Restart',
                      style: TextStyle(fontSize: 25),)
                ),
              ],
            ),
            ...makeGrid(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: (){
                      sp.setDirection(-1, 0);
                    },
                    iconSize: 30,
                    icon: Icon(Icons.arrow_back_ios)),
                Column(
                  children: [
                    IconButton(
                        onPressed: (){
                          sp.setDirection(0, -1);
                        },
                        iconSize: 50,
                        icon: Icon(Icons.keyboard_arrow_up)),
                    IconButton(
                        onPressed: (){
                          sp.setDirection(0, 1);
                        },
                        iconSize: 50,
                        icon: Icon(Icons.keyboard_arrow_down))
                  ],
                ),
                IconButton(
                    onPressed: (){
                      sp.setDirection(1, 0);
                    },
                    iconSize: 30,
                    icon: Icon(Icons.arrow_forward_ios))
              ],
            )
        ]
        ),
      ),
    );
  }
}

