import 'package:flutter/material.dart';

class IconNextToTitleButton extends StatelessWidget {
  const IconNextToTitleButton({
    super.key,
    required this.isDark,
    required this.icon,
  });

  final bool isDark;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isDark
          ? const Color.fromARGB(255, 206, 72, 72)
          : const Color(0xffe63c3a),
      child: IconButton(
        onPressed: null,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
