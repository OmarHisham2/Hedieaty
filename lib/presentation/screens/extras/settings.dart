import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hedieaty2/presentation/screens/extras/settingStuff/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool notificationsEnabled = ref.watch(notificationsProvider);
    final bool isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              ref.read(themeProvider.notifier).state = value;
            },
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: notificationsEnabled,
            onChanged: (value) {
              ref.read(notificationsProvider.notifier).state = value;
            },
          ),
        ],
      ),
    );
  }
}
