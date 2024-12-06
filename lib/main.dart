import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/data/models/event.dart';
import 'package:hedieaty2/presentation/screens/auth/login.dart';
import 'package:hedieaty2/presentation/screens/auth/sign_up.dart';
import 'package:hedieaty2/presentation/screens/auth/welcome_screen.dart';
import 'package:hedieaty2/presentation/screens/events/event_screen.dart';
import 'package:hedieaty2/presentation/screens/gifts/add_new_gift.dart';
import 'package:hedieaty2/presentation/screens/home/home_screen.dart';
import 'package:hedieaty2/presentation/screens/events/my_event_list_screen.dart';
import 'package:hedieaty2/presentation/screens/home/profile_screen.dart';
import 'package:hedieaty2/core/constants/theme_constants.dart';
import 'package:hedieaty2/core/constants/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hedieaty',
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/signup': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/myevents': (context) => const MyEventList(),
        },
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: MyEventList(),
      ),
    );
  }
}
