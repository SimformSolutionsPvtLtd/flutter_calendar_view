// Basic smoke test for the calendar_view example app.
//
// Verifies the app boots and renders its root widget without throwing.

import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots and renders without error', (
    WidgetTester tester,
  ) async {
    // Use a phone-sized surface so the responsive layout renders the mobile
    // home page (the wide/web layout overflows the default 800x600 surface).
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());
    await tester.pump();

    // Verify the app's root and a MaterialApp are present.
    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
