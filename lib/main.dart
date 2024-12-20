import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hedieaty2/presentation/screens/auth/login.dart';
import 'package:hedieaty2/presentation/screens/auth/sign_up.dart';
import 'package:hedieaty2/presentation/screens/auth/welcome_screen.dart';
import 'package:hedieaty2/presentation/screens/extras/settingStuff/settings_provider.dart';
import 'package:hedieaty2/presentation/screens/home/home_screen.dart';
import 'package:hedieaty2/presentation/screens/events/my_event_list_screen.dart';
import 'package:hedieaty2/presentation/screens/home/profile_screen.dart';
import 'package:hedieaty2/core/constants/theme_constants.dart';
import 'package:hedieaty2/services/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService().initNotificaitons();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

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
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const WelcomeScreen(),
      ),
    );
  }
}
