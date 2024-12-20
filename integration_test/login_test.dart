import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/presentation/screens/home/home_screen.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty2/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Login integration test', (WidgetTester tester) async {
    await app.main();

    await tester.pumpAndSettle();

    final loginButton = find.byKey(const Key('login_button'));

    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);

    await tester.pumpAndSettle();

    final emailField = find.byKey(const Key('email_field'));
    final passwordField = find.byKey(const Key('password_field'));
    final submitButton = find.byKey(const Key('submit_button'));

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(submitButton, findsOneWidget);

    await tester.enterText(emailField, 'Helbert.doe@example.com');
    await tester.enterText(passwordField, 'password123');

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
