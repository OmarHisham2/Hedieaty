import 'package:flutter/material.dart';
// Boxes

const COLOR_BOX_BACKGROUND_LIGHT = Color(0xff9f9d9a);
const COLOR_BOX_BACKGROUND_DARK = Color.fromARGB(255, 0, 0, 0);

class GoodCard extends StatelessWidget {
  const GoodCard({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      height: 150,
      width: 300,
      decoration: BoxDecoration(
        color: isDark ? COLOR_BOX_BACKGROUND_DARK : COLOR_BOX_BACKGROUND_LIGHT,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Events', style: textTheme.labelLarge),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Color.fromARGB(255, 53, 52, 50),
                )
              ],
            ),
            const Spacer(),
            Text(textAlign: TextAlign.start, '2', style: textTheme.labelMedium)
          ],
        ),
      ),
    );
  }
}
