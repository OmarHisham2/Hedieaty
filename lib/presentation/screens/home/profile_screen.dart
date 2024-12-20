import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/presentation/screens/extras/manage_events.dart';
import 'package:hedieaty2/presentation/screens/extras/my_pledged_gifts_screen.dart';
import 'package:hedieaty2/presentation/screens/extras/settings.dart';
import 'package:hedieaty2/services/auth/auth.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
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
                    Auth().currentUser!.displayName.toString(),
                    style: textTheme.labelMedium!.copyWith(fontSize: 30),
                  ),
                  Text(Auth().currentUser!.email.toString(),
                      style: textTheme.labelSmall),
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
                    TextButton(
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (builder) => const MyPledgedGiftsScreen(),
                          ),
                        )
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.gift),
                            addHorizontalSpace(20),
                            const Text('My Pledged Gifts'),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (builder) => ManageEventsScreen(
                                userId: Auth().currentUser!.uid),
                          ),
                        )
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          children: [
                            const Icon(Icons.event),
                            addHorizontalSpace(20),
                            const Text('Manage Events'),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (builder) => const SettingsScreen(),
                          ),
                        )
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          children: [
                            const Icon(Icons.settings),
                            addHorizontalSpace(20),
                            const Text('App Settings'),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
