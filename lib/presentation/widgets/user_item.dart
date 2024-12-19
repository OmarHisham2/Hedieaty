import 'package:flutter/material.dart';
import 'package:hedieaty2/data/models/user.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';

class UserItem extends StatelessWidget {
  const UserItem({required this.name, required this.phone, super.key});

  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
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
              children: [Text(name), Text(phone)],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      )),
    );
  }
}
