import 'package:flutter/material.dart';

class GridCell {
  static final double _symbolSize = 80;
  late Offset position;
  late Widget widget;
  String? value;

  GridCell({required Function build}) {
    this.widget = build();
  }

  void _updateWidget({Color? color}) {
    this.widget = Icon(
      this.value == 'X' ? Icons.close : Icons.circle_outlined,
      size: _symbolSize,
      color: color,
    );
  }

  void setX() {
    this.value = 'X';
    _updateWidget();
  }

  void setO() {
    this.value = 'O';
    _updateWidget();
  }

  void setRed(){
    _updateWidget(color: Colors.red);
  }
}