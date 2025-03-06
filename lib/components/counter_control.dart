import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/tasbih_provider.dart';
import 'tasbih_button.dart';

class CounterControl extends StatelessWidget {
  final String mode;
  final VoidCallback decreaseCounter;
  final VoidCallback resetCounter;
  final Function(String) modeChange;
  const CounterControl({super.key, required this.mode,required this.decreaseCounter,required this.resetCounter, required this.modeChange});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TasbihProvider>(context);
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TasbihButton(
            onPressed: () {
              provider.changeLanguage();
            },
            icon: Icons.translate,
          ),
          const SizedBox(width: 8),
          TasbihButton(onPressed: decreaseCounter, icon: Icons.remove),
          const SizedBox(width: 8),
          TasbihButton(onPressed: resetCounter, icon: Icons.refresh),
          const SizedBox(width: 8),
          TasbihButton(
            onPressed: () {
              if (mode == 'volume_off') {
               modeChange('volume_up');
              } else if (mode == 'vibration') {
                modeChange('volume_off');
              } else {
                modeChange('vibration');
              }
            },
            icon:
                mode == 'volume_off'
                    ? Icons.volume_off
                    : mode == 'vibration'
                    ? Icons.vibration
                    : Icons.volume_up,
          ),
        ],
      ),
    );
  }
}
