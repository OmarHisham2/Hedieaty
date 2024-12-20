import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty2/presentation/screens/events/event_screen_normal.dart';
import 'package:hedieaty2/presentation/screens/events/event_screen_owner.dart';
import 'package:hedieaty2/presentation/screens/events/my_event_list_screen.dart';
import 'package:hedieaty2/presentation/screens/home/home_screen.dart';
import 'package:hedieaty2/presentation/screens/home/profile_screen.dart';
import 'package:hedieaty2/presentation/widgets/myCircle.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hedieaty2/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E integration test with event and gift management',
      (WidgetTester tester) async {
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

    final myEventsButton = find.byKey(const Key('my_events_button'));
    expect(myEventsButton, findsOneWidget);
    await tester.tap(myEventsButton);
    await tester.pumpAndSettle();

    final noEventsText = find.text('No Events Found!');
    expect(noEventsText, findsOneWidget);

    final addEventButton = find.byIcon(Icons.add);
    await tester.tap(addEventButton);
    await tester.pumpAndSettle();

    final eventName = find.byKey(const Key('event_title'));
    final eventCategoryDropdown =
        find.byKey(const Key('event_category_dropdown'));
    final eventLocation = find.byKey(const Key('event_location'));
    final eventDescription = find.byKey(const Key('event_description'));

    final saveEventButton = find.byKey(const Key('add_new_event_button'));

    await tester.enterText(eventName, 'Birthday Party');
    await tester.enterText(eventLocation, 'Hall F');
    await tester.enterText(eventDescription, 'This is an event.');

    await tester.tap(eventCategoryDropdown);
    await tester.pumpAndSettle();

    final birthdayCategory = find.text('Birthday').last;
    await tester.tap(birthdayCategory);
    await tester.pumpAndSettle();

    await tester.tap(saveEventButton);
    await tester.pumpAndSettle();

    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(seconds: 1));
      if (find.byType(MyEventList).evaluate().isNotEmpty) break;
    }

    await tester.tap(addEventButton);
    await tester.pumpAndSettle();

    await tester.enterText(eventName, 'Lucas\'s Party');
    await tester.enterText(eventLocation, 'Beachside');
    await tester.enterText(eventDescription, 'Everyone is welcome!');

    await tester.tap(eventCategoryDropdown);
    await tester.pumpAndSettle();

    final weddingCategory = find.text('Party').last;
    await tester.tap(weddingCategory);
    await tester.pumpAndSettle();

    await tester.tap(saveEventButton);
    await tester.pumpAndSettle();

    final birthdayEvent = find.text('Birthday Party');
    final weddingEvent = find.text('Lucas\'s Party');
    expect(birthdayEvent, findsOneWidget);
    expect(weddingEvent, findsOneWidget);

    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(seconds: 1));
      if (find.byType(MyEventList).evaluate().isNotEmpty) break;
    }

    final eventItem = find.text('Birthday Party').first;
    await tester.tap(eventItem);
    await tester.pumpAndSettle();

    final addGiftButton = find.byIcon(Icons.add);
    await tester.tap(addGiftButton);
    await tester.pumpAndSettle();

    final giftNameField = find.byKey(const Key('gift_name_field'));
    final giftPriceField = find.byKey(const Key('gift_price_field'));
    final giftSaveButton = find.byKey(const Key('gift_save_button'));

    await tester.enterText(giftNameField, 'The Leftovers Book');
    await tester.enterText(giftPriceField, '60');
    await tester.tap(giftSaveButton);
    await tester.pumpAndSettle();
  });
}
