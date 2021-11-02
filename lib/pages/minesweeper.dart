import 'dart:math';

import 'package:flutter/material.dart';
import '../minesweeper/play_timer.dart';
import '../minesweeper/mine_cell.dart';

class MineSweeper extends StatefulWidget {
  @override
  _MineSweeperState createState() => _MineSweeperState();
}

class _MineSweeperState extends State<MineSweeper> {
  final int rows = 10;
  final int cols = 10;

  late List<List<CellData>> _grid;
  late bool _isGameOver = false;
  late bool _isFinished = false;

  PlayTimer? pt;

  @override
  void initState() {
    super.initState();
    makeGrid();
  }

  @override
  void dispose() {
    super.dispose();
    pt?.dispose();
  }

  void makeGrid(){
    var rand = Random();
    _grid = List<List<CellData>>.generate(rows, (dx) =>
        List.generate(cols, (dy) {
          var cd = CellData(x: dx, y: dy);
          cd.hasMine = rand.nextInt(100) < 10;
          return cd;
        })
    );

    _grid.forEach((row) =>
        row.forEach((cd) =>
            countNeighborMine(cd)));
  }

  List<Widget> makeGridUI(){
    //makeGrid();

    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;
    int minSize = (screenW < screenH ? screenW : screenH).floor()-20;
    double cellSize = minSize / cols;
    return _grid.map((row) => Row(
      children: row.map((cellData) =>
          MineCell(cellSize: cellSize.floorToDouble(), data: cellData, reveal: reveal)).toList(),
    )).toList();
  }




  void countNeighborMine(CellData cd){
    if(cd.hasMine) return;

    int totalMine = 0;
    for(int i = -1; i <= 1; i++){
      for(int j = -1; j <= 1; j++){
        int ix = i + cd.x;
        int jy = j + cd.y;
        if((i == 0 && j == 0) || // current cell
            (ix < 0 || ix >= cols || jy < 0 || jy >= rows)) // edge cell
          continue;

        totalMine += _grid[ix][jy].hasMine ? 1 : 0;
      }
    }

    cd.neighborMine = totalMine;
  }

  void reveal(int x, int y, [bool marking=false]){
    if(pt == null){
      pt = PlayTimer(
          interval: Duration(seconds: 1),
          checkTimerStop: () => _isFinished || _isGameOver,
          onInterval: () => setState((){})
      );
    }

    setState(() {
      if(marking){
        _grid[x][y].marked = !_grid[x][y].marked;
      }
      else if(!_grid[x][y].marked){ // if marked cannot reveal
        if(_grid[x][y].hasMine){
          _isGameOver = true;
          // show all mine cell if game over
          _grid.forEach((row) => row.forEach((cd) => cd.revealed = cd.revealed ? cd.revealed : cd.hasMine));
        }
        else{
          _grid[x][y].revealed = true;
          if(_grid[x][y].neighborMine == 0)
            revealNeighbor(x, y);

          // check is there any cell (not mine && has not revealed)
          bool isAllCellReveal = !_grid.any((row)=>row.any((cd)=>!cd.hasMine&&!cd.revealed));
          if(isAllCellReveal){ // if all cell (exclude mine) revealed, win game
            _isFinished = true;
            // mark all mine cell
            _grid.forEach((row) => row.forEach((cd) => cd.marked = cd.hasMine));
          }
        }
      }
    });
  }

  void revealNeighbor(int x, int y){
    for(int i = -1; i <= 1; i++){
      for(int j = -1; j <= 1; j++){
        int ix = i + x;
        int jy = j + y;

        if((i == 0 && j == 0) || // current cell
            (ix < 0 || ix >= cols || jy < 0 || jy >= rows) || // edge cell
            _grid[ix][jy].revealed) // revealed
          continue;

        var neighbor = _grid[ix][jy];
        neighbor.revealed = true;

        if(neighbor.neighborMine == 0){
           revealNeighbor(ix, jy);
        }
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mine Sweeper'), centerTitle: true,),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(pt?.formatTimer() ?? '00 : 00',
                    style: TextStyle(fontSize: 25),
                  ),
                  TextButton.icon(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, '/minesweeper');
                      },
                      icon: Icon(Icons.replay),
                      label: Text('Restart',
                        style: TextStyle(fontSize: 25),)
                  ),
                ],
              ),

              ...makeGridUI(),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Text(_isFinished ? 'You Won! \u{1F47C}' : _isGameOver ? 'You Lose! \u{1F47F}' : '',
                  style: TextStyle(fontSize: 30),
                ),
              )
            ],
          )
      )
    );
  }
}



