import 'package:flutter/material.dart';
import 'package:hedieaty2/screens/event_screen.dart';
import 'package:hedieaty2/screens/home_screen.dart';
import 'package:hedieaty2/screens/profile_screen.dart';
import 'package:hedieaty2/theme/theme_constants.dart';
import 'package:hedieaty2/theme/theme_manager.dart';

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
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hedieaty',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeManager.themeMode,
        home: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            appBar: AppBar(
              title: const Text(
                'Hedieaty',
                style: TextStyle(fontSize: 30),
              ),
              actions: [
                Switch(
                  value: _themeManager.themeMode == ThemeMode.dark,
                  onChanged: (newValue) {
                    _themeManager.toggleTheme(newValue);
                  },
                )
              ],
            ),
            body: const EventScreen()),
      ),
    );
  }
}
