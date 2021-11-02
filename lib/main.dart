import 'package:flutter/material.dart';
import 'package:world_time/pages/choose_location.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/tictactoe.dart';
import 'pages/snake.dart';
import 'pages/minesweeper.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => Home(),
      '/location': (context) => ChooseLocation(),
      '/minesweeper': (context) => MineSweeper(),
      '/snake': (context) => Snake(),
      '/tictactoe': (context) => TicTacToe()
    },
  ));
}

