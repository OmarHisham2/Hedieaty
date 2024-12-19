import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/presentation/screens/home/home_screen.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty2/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Registration integration test', (WidgetTester tester) async {
    // Launch the app
    await app.main();

    // Wait for the initial screen (e.g., the welcome screen) to settle
    await tester.pumpAndSettle();

    // Find the "Register" button on the welcome screen
    final registerButton = find.byKey(const Key('register_button'));

    // Verify that the "Register" button is present and tap it to navigate to the registration screen
    expect(registerButton, findsOneWidget);
    await tester.tap(registerButton);

    // Wait for the registration screen to load
    await tester.pumpAndSettle();

    // Find the form fields by their keys
    final nameField = find.byKey(const Key('name_field'));
    final emailField = find.byKey(const Key('email_field'));
    final passwordField = find.byKey(const Key('password_field'));
    final phoneField = find.byKey(const Key('phone_field'));
    final submitButton = find.byKey(const Key('register_button_2'));

    // Verify that the registration form fields and button are present
    expect(nameField, findsOneWidget);
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(phoneField, findsOneWidget);
    expect(submitButton, findsOneWidget);

    // Enter valid test data
    await tester.enterText(nameField, 'John Doe');
    await tester.enterText(emailField, 'john.doe@exaaaeeample.com');
    await tester.enterText(passwordField, 'password123');
    await tester.enterText(phoneField, '12345678290');

    // Tap the register button to submit the registration form
    await tester.tap(submitButton);

    // Wait for the app to process the registration and navigate to the HomeScreen
    await tester.pumpAndSettle();

    // Wait for the app to process the registration and navigate to the HomeScreen
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(seconds: 1));
      if (find.byType(HomeScreen).evaluate().isNotEmpty) break;
    }

// Verify that the HomeScreen is displayed
    final homeScreen = find.byType(HomeScreen);
    expect(homeScreen, findsOneWidget);

// Verify that the user's display name appears on the HomeScreen
    final displayNameText = find.text('John Doe');
    expect(displayNameText, findsOneWidget);
  });
}
