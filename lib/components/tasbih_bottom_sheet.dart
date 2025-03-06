import 'package:flutter/material.dart';

class TasbihBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  const TasbihBottomSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView.builder(
        controller: scrollController,
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item ${index + 1}'),
          );
        },
      ),
    );
  }
}