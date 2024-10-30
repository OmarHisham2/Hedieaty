import 'package:flutter/material.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';
import 'package:icons_plus/icons_plus.dart';
// Boxes

const COLOR_BOX_BACKGROUND_LIGHT = Color(0xffe73a39);
const COLOR_BOX_BACKGROUND_DARK = Color.fromARGB(255, 0, 0, 0);

class EventItem extends StatelessWidget {
  const EventItem({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
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
                Image.asset(
                  'assets/images/birthday.png',
                  color: Colors.white,
                  width: 45,
                ),
                const Spacer(),
                Image.asset(
                  'assets/images/eventStatus.png',
                  width: 15,
                  height: 10,
                ),
                addHorizontalSpace(5),
                Text(
                  'Active',
                  style: textTheme.labelSmall?.copyWith(color: Colors.white),
                )
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emad\'s Birthday Party!',
                  style: textTheme.labelMedium?.copyWith(color: Colors.white),
                ),
                addVerticalSpace(5),
                Text(
                  'Unpledged Gifts: 5',
                  style: textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? Colors.grey
                          : const Color.fromARGB(113, 255, 255, 255)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
