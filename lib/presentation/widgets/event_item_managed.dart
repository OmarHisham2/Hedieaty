import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';
import 'package:hedieaty2/presentation/widgets/myCircle.dart';
import 'package:ionicons/ionicons.dart';

const COLOR_BOX_BACKGROUND_LIGHT = Color(0xffe73a39);
const COLOR_BOX_BACKGROUND_DARK = Color.fromARGB(255, 163, 58, 58);

class EventItemManaged extends StatefulWidget {
  final Event event;
  EventItemManaged(
      {required this.event,
      super.key,
      required this.onDelete,
      required this.onEdit});
  VoidCallback onDelete;
  VoidCallback onEdit;
  @override
  State<EventItemManaged> createState() => _EventItemManagedState();
}

class _EventItemManagedState extends State<EventItemManaged> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    TextTheme textTheme = Theme.of(context).textTheme;

    IconData eventIcon;

    String getStatus() {
      DateTime today = DateTime.now();
      DateTime eventDate = widget.event.date;

      if (eventDate.isBefore(today)) {
        return 'Past';
      } else if (eventDate.year == today.year &&
          eventDate.month == today.month &&
          eventDate.day == today.day) {
        return 'Current';
      } else {
        return 'Upcoming';
      }
    }

    IconData determineIcon() {
      if (widget.event.category == Category.birthday) {
        return Icons.cake;
      } else if (widget.event.category == Category.party) {
        return Icons.celebration;
      } else if (widget.event.category == Category.babyshower) {
        return Icons.bedroom_baby;
      } else {
        return Icons.celebration;
      }
    }

    @override
    void initState() {
      determineIcon();
      super.initState();
    }

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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.event.name,
                  style: textTheme.labelMedium?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Center(
                  child: Row(
                    children: [
                      MyCircle(
                        color: widget.event.isPublished
                            ? Colors.green
                            : Colors.white,
                      ),
                      addHorizontalSpace(5),
                      const SizedBox(
                        height: 10,
                        child: VerticalDivider(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.event.status.name,
                        style:
                            textTheme.labelSmall?.copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
            addVerticalSpace(10),
            const Spacer(),
            Center(
                child: Icon(
              determineIcon(),
              size: 50,
              color: Colors.white.withOpacity(0.3),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 50,
                  child: FittedBox(
                    child: ElevatedButton(
                      onPressed: widget.onEdit,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black12),
                      child: const Text('Edit'),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: FittedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black12),
                      onPressed: widget.onDelete,
                      child: const Text('Delete'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
