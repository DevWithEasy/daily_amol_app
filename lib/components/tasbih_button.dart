import 'package:flutter/material.dart';

import '../service/AppColors.dart';

class TasbihButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const TasbihButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0.1,
      ),
      child: Icon(icon, color: AppColors.primary),
    );
  }
}
