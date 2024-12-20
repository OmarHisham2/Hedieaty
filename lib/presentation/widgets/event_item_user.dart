import 'package:flutter/material.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/presentation/widgets/myCircle.dart';

const COLOR_BOX_BACKGROUND_LIGHT = Color(0xffe73a39);
const COLOR_BOX_BACKGROUND_DARK = Color.fromARGB(255, 163, 58, 58);

class EventItemUser extends StatelessWidget {
  final Event event;
  const EventItemUser({
    required this.event,
    super.key,
    required,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      height: 210,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
      decoration: BoxDecoration(
        color: isDark ? COLOR_BOX_BACKGROUND_DARK : COLOR_BOX_BACKGROUND_LIGHT,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Container(
        margin: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  event.category == Category.birthday
                      ? 'assets/images/birthday.png'
                      : 'assets/images/party.png',
                  color: Colors.white,
                  width: 45,
                ),
                const Spacer(),
                const MyCircle(
                  color: Colors.green,
                ),
                addHorizontalSpace(5),
                const SizedBox(
                  height: 10,
                  child: VerticalDivider(
                    color: Colors.white,
                  ),
                ),
                Text(
                  event.status.name,
                  style: textTheme.labelSmall?.copyWith(color: Colors.white),
                )
              ],
            ),
            addVerticalSpace(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    event.name,
                    style: textTheme.labelMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                addVerticalSpace(10),
                Text(
                  'Location: ${event.location}',
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.end,
                          'See Details',
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      addHorizontalSpace(5),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        opticalSize: 5,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
