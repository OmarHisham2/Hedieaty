import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/presentation/screens/home/home_screen.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty2/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Registration integration test', (WidgetTester tester) async {
    await app.main();

    await tester.pumpAndSettle();

    final registerButton = find.byKey(const Key('register_button'));

    expect(registerButton, findsOneWidget);
    await tester.tap(registerButton);

    await tester.pumpAndSettle();

    final nameField = find.byKey(const Key('name_field'));
    final emailField = find.byKey(const Key('email_field'));
    final passwordField = find.byKey(const Key('password_field'));
    final phoneField = find.byKey(const Key('phone_field'));
    final submitButton = find.byKey(const Key('register_button_2'));

    expect(nameField, findsOneWidget);
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(phoneField, findsOneWidget);
    expect(submitButton, findsOneWidget);

    await tester.enterText(nameField, 'Helbert');
    await tester.enterText(emailField, 'Helbert.doe@example.com');
    await tester.enterText(passwordField, 'password123');
    await tester.enterText(phoneField, '01000300111');

    await tester.tap(submitButton);

    await tester.pumpAndSettle();

    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(seconds: 1));
      if (find.byType(HomeScreen).evaluate().isNotEmpty) break;
    }

    final homeScreen = find.byType(HomeScreen);
    expect(homeScreen, findsOneWidget);

    final displayNameText = find.text('Helbert');
    expect(displayNameText, findsOneWidget);
  });
}
