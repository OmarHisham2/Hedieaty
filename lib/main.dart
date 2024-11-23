import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/components/events_screen/event_item.dart';
import 'package:hedieaty2/components/general_components/sort_options.dart';
import 'package:hedieaty2/components/home_screen/add_event_button.dart';
import 'package:hedieaty2/components/home_screen/user_item.dart';
import 'package:hedieaty2/components/my_events_screen/create_event_button.dart';
import 'package:hedieaty2/components/profile_screen/settings_button.dart';
import 'package:hedieaty2/data_models/event.dart';
import 'package:hedieaty2/screens/event_list_screen.dart';
import 'package:hedieaty2/screens/home_screen.dart';
import 'package:hedieaty2/screens/my_event_list_screen.dart';
import 'package:hedieaty2/screens/profile_screen.dart';
import 'package:hedieaty2/theme/theme_constants.dart';
import 'package:hedieaty2/theme/theme_manager.dart';
import 'package:hedieaty2/utils/helper_widgets.dart';

void main() {
  runApp(const MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();

    @override
    void dispose() {
      _themeManager.removeListener(themeListener);
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    TextTheme textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hedieaty',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/myevents': (context) => const MyEventList(),
        },
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Hedieaty',
                style: TextStyle(fontSize: 30),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person,
                  ),
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(context).iconTheme.color),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(context).iconTheme.color),
                ),
                Switch(
                  value: _themeManager.themeMode == ThemeMode.dark,
                  onChanged: (newValue) {
                    setState(() {
                      _themeManager.toggleTheme(newValue);
                    });
                  },
                )
              ],
            ),
            body: const HomeScreen()),
      ),
    );
  }
}
