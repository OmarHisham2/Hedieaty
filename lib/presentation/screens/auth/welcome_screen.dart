import 'package:flutter/material.dart';
import 'package:hedieaty2/core/utils/helper_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/animatedIcons/giftDark.gif'
                  : 'assets/animatedIcons/gift.gif',
              width: 250,
              height: 250,
            ),
          ),
          addVerticalSpace(50),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Row(
              children: [
                Hero(
                  tag: 'appLogo',
                  child: Image.asset(
                    'assets/images/appLogo.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                addHorizontalSpace(15),
                Text(
                  'Hedieaety',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 40, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          addVerticalSpace(30),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Make Every Occasion Special with Hedieaty',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 30),
                ),
                addVerticalSpace(10),
                Text(
                    "Create, manage, and share your wish lists effortlessly—whether for birthdays, weddings, holidays, or any special moment. Gift-giving made easy!",
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          addVerticalSpace(30),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              key: const ValueKey('login_button'),
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Text('Login'),
            ),
          ),
          addVerticalSpace(20),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              key: const ValueKey('register_button'),
              onPressed: () {
                Navigator.of(context).pushNamed('/signup');
              },
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  backgroundColor: const Color.fromARGB(203, 83, 81, 81)),
              child: const Text(
                'Register',
              ),
            ),
          )
        ],
      ),
    );
  }
}
