import 'package:flutter/material.dart';

class ClockTime extends StatefulWidget {
  final String location;
  final String time;
  final Color textColor;

  const ClockTime({required this.location, required this.time, required this.textColor});

  @override
  _ClockTimeState createState() => _ClockTimeState();
}

class _ClockTimeState extends State<ClockTime> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.location,
          style: TextStyle(
              fontSize: 50.0,
              color: widget.textColor
          ),
        ),
        Text(
          widget.time,
          style: TextStyle(fontSize: 80.0, color: widget.textColor),
        )
      ],
    );
  }
}
