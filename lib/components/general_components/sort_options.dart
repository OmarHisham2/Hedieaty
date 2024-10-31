import 'package:flutter/material.dart';

class SortOption extends StatelessWidget {
  final String text;
  const SortOption({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(text),
    );
  }
}
