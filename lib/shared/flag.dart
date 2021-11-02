import 'package:flutter/material.dart';

class Flag extends StatefulWidget {
  final String flag;

  const Flag({required this.flag});

  @override
  _FlagState createState() => _FlagState();
}

class _FlagState extends State<Flag> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnim;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    _sizeAnim = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
              tween: Tween<double>(begin: 1, end: 1.5),
              weight: 50
          ),
          TweenSequenceItem<double>(
              tween: Tween<double>(begin: 1.5, end: 1),
              weight: 50
          )
        ]
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _){
        return Transform.scale(
          scale: _sizeAnim.value,
          child: IconButton(
            iconSize: 50,
            icon: Image.network(
              'https://flagcdn.com/w160/${widget.flag}.png',
              height: 30,
              width: 50,
            ),
            onPressed: (){
              _controller.forward();
            },
          ),
        );
      },
    );
  }
}
