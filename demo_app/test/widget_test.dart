// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:demo_app/main.dart';

void main() {
  testWidgets('Home loads and navigates to Audio Player',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Home content
    expect(find.text('Student App'), findsOneWidget);
    expect(find.text('Calculator'), findsOneWidget);
    expect(find.text('CGPA System'), findsOneWidget);
    expect(find.text('Audio Player'), findsOneWidget);

    // Navigate to Audio Player
    await tester.tap(find.text('Audio Player'));
    await tester.pumpAndSettle();
    expect(find.text('Audio Player'), findsWidgets);

    // Basic UI elements on the Audio Player screen
    expect(find.byType(Slider), findsOneWidget);
    expect(find.byIcon(Icons.play_circle_filled), findsOneWidget);
  });
}
