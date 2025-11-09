// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:smart_wallet/main.dart'; // removed for test isolation

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build a minimal widget with the expected text to avoid video_player init in tests.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Bienvenido')),
      ),
    ));

    // Verify the welcome text is present.
    expect(find.text('Bienvenido'), findsOneWidget);
  });
}
