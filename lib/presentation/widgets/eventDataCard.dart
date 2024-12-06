import 'package:flutter/material.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';

const COLOR_BOX_BACKGROUND_LIGHT = Color(0xffe63c3a);
const COLOR_BOX_BACKGROUND_DARK = Color.fromARGB(255, 163, 58, 58);

class EventDataCard extends StatelessWidget {
  const EventDataCard(
      {super.key,
      required this.title,
      required this.number,
      required this.lastUpdated,
      required this.icon});

  final String title;
  final String number;
  final String lastUpdated;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: isDark ? COLOR_BOX_BACKGROUND_DARK : COLOR_BOX_BACKGROUND_LIGHT,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Container(
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                    ),
                    addHorizontalSpace(10),
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            addVerticalSpace(25),
            Row(
              children: [
                Text(
                  number,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 35, color: Colors.white),
                ),
                const Spacer(),
              ],
            ),
            addVerticalSpace(25),
            FittedBox(
              child: Text(
                'Last Updated: ' + lastUpdated,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
