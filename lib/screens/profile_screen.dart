import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/components/profile_screen/settings_button.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Column(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/profile.png'),
                addVerticalSpace(20),
                Text(
                  'Omar Hisham',
                  style: textTheme.labelMedium!.copyWith(fontSize: 30),
                ),
                Text('omar@gmail.com', style: textTheme.labelSmall),
              ],
            ),
          ),
          addVerticalSpace(50),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsButton(
                    onpressed: () {},
                    icon: CupertinoIcons.gift,
                    label: 'My Pledged Gifts',
                  ),
                  SettingsButton(
                    onpressed: () {},
                    icon: Icons.admin_panel_settings,
                    label: 'Profile Management',
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
