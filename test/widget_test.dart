// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speakmobilemvp/features/profile/screens/profile_main_screen.dart';

// ignore: depend_on_referenced_packages

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const SpeakMobileApp() as Widget);

    // Verify that the HomeScreen is displayed
    expect(find.byType(HomeScreen), findsOneWidget);

    // Verify initial screen index is 0 (ConversationScreen)
    expect(find.byType(ConversationScreen), findsOneWidget);
    
    // Verify other screens are not visible initially
    expect(find.byType(ProfileScreen), findsNothing);
    expect(find.byType(SettingsScreen), findsNothing);
  });

  testWidgets('Navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const SpeakMobileApp() as Widget);

    // Find the BottomNavigationBar
    final bottomNavFinder = find.byType(BottomNavigationBar);
    expect(bottomNavFinder, findsOneWidget);

    // Tap the profile tab (index 1)
    await tester.tap(find.byIcon(Icons.person).first);
    await tester.pumpAndSettle();

    // Verify profile screen is now visible
    expect(find.byType(ProfileMainScreen), findsOneWidget);
    expect(find.byType(ConversationScreen), findsNothing);
  });
}

class SettingsScreen {
}

class ConversationScreen {
}

class HomeScreen {
}

class ProfileScreen {
}

class SpeakMobileApp {
  const SpeakMobileApp();
}
