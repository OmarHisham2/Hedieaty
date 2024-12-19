import 'package:flutter/material.dart';

class MyCircle extends StatelessWidget {
  final Color color;

  const MyCircle({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 10.0,
        width: 10.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: const SizedBox(),
      ),
    );
  }
}
