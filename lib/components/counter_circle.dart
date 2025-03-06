import 'package:flutter/material.dart';

import '../utils/en_bn_number_convert.dart';

class CounterCircle extends StatelessWidget {
  final int counter;
  final int targetCounter;
  const CounterCircle({super.key, required this.counter, required this.targetCounter});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(Colors.grey.shade200),
          ),
        ),
        SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            value: counter / targetCounter.clamp(1, targetCounter),
            strokeWidth: 8,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation(Colors.teal),
          ),
        ),
        Text(
          enToBnNumber(counter.toString()),
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }
}
