import 'package:flutter/material.dart';

import '../utils/en_bn_number_convert.dart';
import 'counter_circle.dart';

class CounterArea extends StatelessWidget {
  final VoidCallback incrementCounter;
  final int counter;
  final int targetCounter;
  final bool completed;
  const CounterArea({
    super.key,
    required this.incrementCounter,
    required this.counter,
    required this.targetCounter,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: incrementCounter,
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CounterCircle(counter: counter, targetCounter: targetCounter),
                const SizedBox(height: 20),
                Text(
                  'ট্যাপ করে তাসবিহ শুরু করুন',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                Text(
                  enToBnNumber('$counter/$targetCounter'),
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    !completed ? '' : 'তারগেট অনুযায়ী তাসবিহ গণনা শেষ।',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
