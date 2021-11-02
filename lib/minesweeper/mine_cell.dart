import 'package:flutter/material.dart';

class MineCell extends StatelessWidget {
  final double cellSize;
  final CellData data;
  final Function reveal;

  const MineCell({required this.cellSize, required this.data, required this.reveal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellSize,
      height: cellSize,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black)
      ),
      child: data.revealed ?
      (data.hasMine?
      Icon(Icons.ac_unit):
      Container(
        color: Colors.grey[400],
        child: Center(
            child: Text(
              '${data.neighborMine > 0 ? data.neighborMine : ''}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
        ),
      )
      )
          : data.marked?
      InkWell(
        onTap: () => reveal(data.x, data.y),
        onLongPress: () => reveal(data.x, data.y, true),
        child: Icon(Icons.flag),
      )
          :TextButton(
        child: Text(''),
        onPressed: (){
          reveal(data.x, data.y);
        },
        onLongPress: (){
          reveal(data.x, data.y, true);
        },
      ),
    );
  }
}


class CellData{
  late int x;
  late int y;
  bool hasMine = false;
  bool revealed = false;
  int neighborMine = 0;
  bool marked = false;

  CellData({required this.x, required this.y});
}
