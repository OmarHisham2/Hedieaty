import 'package:flutter/material.dart';
import 'dart:ui';

class FrostedGlassBox extends StatelessWidget {
  const FrostedGlassBox(
      {super.key,
      required this.theWidth,
      required this.theHeight,
      required this.theChild});

  final theWidth;
  final theHeight;
  final theChild;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: theWidth,
        height: 200.0,
        color: Colors.transparent,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isDark
                          ? Colors.white.withOpacity(0.15)
                          : const Color.fromARGB(255, 203, 188, 163)
                              .withOpacity(0.2),
                      isDark
                          ? Colors.white.withOpacity(0.05)
                          : const Color.fromARGB(255, 181, 173, 157)
                              .withOpacity(0.8),
                    ]),
              ),
            ),
            Center(child: theChild),
          ],
        ),
      ),
    );
  }
}
