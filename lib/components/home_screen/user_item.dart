import 'package:flutter/material.dart';
import 'package:hedieaty2/data_models/user.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

class UserItem extends StatelessWidget {
  const UserItem({required this.userData, super.key});

  final User userData;

  int getNumberOfEvents() {
    return userData.createdEvents.length;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Image.asset(
            'assets/images/profile.png',
            width: 50,
          ),
          addHorizontalSpace(20),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userData.name),
              Text('Upcoming Events: ${userData.createdEvents.length}')
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios)
        ],
      ),
    ));
  }
}
