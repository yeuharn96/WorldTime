import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Heart extends StatefulWidget {
  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> with SingleTickerProviderStateMixin {
  late bool isFav = false;
  late AnimationController _controller;
  late Animation<Color?> _colorAnim;
  late Animation<double> _sizeAnim;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    _colorAnim = ColorTween(begin: Colors.grey[400], end: Colors.red)
        .animate(_controller);

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
        setState(() {
          isFav = true;
        });
      }
      else if(status == AnimationStatus.dismissed){
        setState(() {
          isFav = false;
        });
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
            icon: Icon(
              Icons.favorite,
              color: _colorAnim.value,
              size: 30,
            ),
            onPressed: () {
              isFav ? _controller.reverse() : _controller.forward();
            },
          ),
        );
      },
    );
  }
}
