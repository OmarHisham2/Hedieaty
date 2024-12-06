import 'package:flutter/material.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      "assets/images/eventList.png",
                      width: 150,
                    ),
                  ),
                  addVerticalSpace(15),
                  FittedBox(
                    child: Text(
                      'Omar\'s Event List',
                      style: textTheme.labelMedium!.copyWith(fontSize: 40),
                    ),
                  ),
                  Text('Total Events: 5', style: textTheme.labelSmall),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 50, 0, 0),
                    child: Text(
                      'Events',
                      style: textTheme.titleLarge!.copyWith(fontSize: 25),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
