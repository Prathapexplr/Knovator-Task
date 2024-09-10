import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int duration;

  const TimerWidget({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Text('$duration s', style: const TextStyle(fontSize: 16));
  }
}
