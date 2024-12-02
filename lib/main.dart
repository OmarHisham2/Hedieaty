import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/screens/Intro/login.dart';
import 'package:hedieaty2/screens/Intro/sign_up.dart';
import 'package:hedieaty2/screens/Intro/sign_up2.dart';
import 'package:hedieaty2/screens/Intro/welcome_screen.dart';
import 'package:hedieaty2/screens/add_new_gift.dart';
import 'package:hedieaty2/screens/home_screen.dart';
import 'package:hedieaty2/screens/my_event_list_screen.dart';
import 'package:hedieaty2/screens/profile_screen.dart';
import 'package:hedieaty2/theme/theme_constants.dart';
import 'package:hedieaty2/theme/theme_manager.dart';

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
          '/welcome': (context) => WelcomeScreen(),
          '/signup': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/myevents': (context) => const MyEventList(),
          '/addgift': (context) => AddNewGift()
        },
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
/*
GiftItem(
            giftDetails: Gift(
                name: 'iPhone 16',
                description: 'This is the new iphone',
                price: 640.20,
                associatedEvent: Event([], DateTime.now(),
                    name: 'Omar Birthday',
                    category: Category.birthday,
                    status: Status.Current),
                imageUrl:
                    'https://www.cellularsales.com/wp-content/uploads/2024/09/iPhone_16_Teal.png',
                giftCategory: GiftCategory.electronics)*/