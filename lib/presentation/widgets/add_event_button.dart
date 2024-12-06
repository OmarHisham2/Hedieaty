import 'package:flutter/material.dart';


const COLOR_BOX_BACKGROUND_LIGHT = Color(0xffe63c3a);
const COLOR_BOX_BACKGROUND_DARK = Color.fromARGB(255, 206, 72, 72);

class AddEventButton extends StatelessWidget {
  final String text;

  const AddEventButton({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: 250,
      height: 150,
      decoration: BoxDecoration(
        color: isDark ? COLOR_BOX_BACKGROUND_DARK : COLOR_BOX_BACKGROUND_LIGHT,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  text,
                  style: textTheme.labelLarge
                      ?.copyWith(color: Colors.white, fontSize: 23),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Color.fromARGB(255, 255, 255, 255),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
