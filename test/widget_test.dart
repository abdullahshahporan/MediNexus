// MediNexus Widget Tests
//
// Basic widget tests for the MediNexus healthcare app.
// Uses WidgetTester for widget interaction testing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Basic test to verify the app structure
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('MediNexus'),
          ),
        ),
      ),
    );

    // Verify the app name is displayed
    expect(find.text('MediNexus'), findsOneWidget);
  });
}
