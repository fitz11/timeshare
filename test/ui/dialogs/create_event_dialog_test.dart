// Copyright (c) 2025 David Fitzsimmons
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeshare/ui/features/calendar/dialogs/create_event_dialog.dart';

import '../../mocks/mock_providers.dart';

void main() {
  group('CreateEventDialog', () {
    testWidgets('shows dialog with calendar name in title', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(
            body: CreateEventDialog(
              calendarId: 'test-calendar-id',
              calendarName: 'My Calendar',
            ),
          ),
        ),
      );

      await tester.pumpWidget(scope);

      expect(find.text('Add Event to My Calendar'), findsOneWidget);
    });

    testWidgets('has event name text field', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(
            body: CreateEventDialog(
              calendarId: 'test-calendar-id',
              calendarName: 'My Calendar',
            ),
          ),
        ),
      );

      await tester.pumpWidget(scope);

      expect(find.text('Event Name'), findsOneWidget);
      expect(find.byType(TextField), findsWidgets);
    });

    testWidgets('has date picker field', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(
            body: CreateEventDialog(
              calendarId: 'test-calendar-id',
              calendarName: 'My Calendar',
            ),
          ),
        ),
      );

      await tester.pumpWidget(scope);

      expect(find.text('Date'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('has color chips for selection', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(
            body: CreateEventDialog(
              calendarId: 'test-calendar-id',
              calendarName: 'My Calendar',
            ),
          ),
        ),
      );

      await tester.pumpWidget(scope);

      expect(find.text('Color'), findsOneWidget);
      expect(find.text('Black'), findsOneWidget);
      expect(find.text('Red'), findsOneWidget);
      expect(find.text('Blue'), findsOneWidget);
      expect(find.text('Green'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsNWidgets(4));
    });

    testWidgets('has shape checkbox', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(
            body: CreateEventDialog(
              calendarId: 'test-calendar-id',
              calendarName: 'My Calendar',
            ),
          ),
        ),
      );

      await tester.pumpWidget(scope);

      expect(find.text('Square shape'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsOneWidget);
    });

    testWidgets('Add Event button is disabled when event name is empty',
        (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(
            body: CreateEventDialog(
              calendarId: 'test-calendar-id',
              calendarName: 'My Calendar',
            ),
          ),
        ),
      );

      await tester.pumpWidget(scope);

      // Find the FilledButton with 'Add Event' text
      final addButton = find.widgetWithText(FilledButton, 'Add Event');
      expect(addButton, findsOneWidget);

      // The button should be disabled (onPressed is null)
      final button = tester.widget<FilledButton>(addButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('Add Event button is enabled when event name is entered',
        (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(
            body: CreateEventDialog(
              calendarId: 'test-calendar-id',
              calendarName: 'My Calendar',
            ),
          ),
        ),
      );

      await tester.pumpWidget(scope);

      // Enter text in the event name field
      await tester.enterText(
        find.widgetWithText(TextField, 'Event Name'),
        'Test Event',
      );
      await tester.pump();

      // Find the FilledButton with 'Add Event' text
      final addButton = find.widgetWithText(FilledButton, 'Add Event');
      expect(addButton, findsOneWidget);

      // The button should now be enabled
      final button = tester.widget<FilledButton>(addButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Cancel button closes dialog', (tester) async {
      final scope = await createTestProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const CreateEventDialog(
                      calendarId: 'test-calendar-id',
                      calendarName: 'My Calendar',
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(scope);

      // Open the dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Add Event to My Calendar'), findsOneWidget);

      // Tap cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Add Event to My Calendar'), findsNothing);
    });

    testWidgets('Close button closes dialog', (tester) async {
      final scope = await createTestProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const CreateEventDialog(
                      calendarId: 'test-calendar-id',
                      calendarName: 'My Calendar',
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(scope);

      // Open the dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Add Event to My Calendar'), findsOneWidget);

      // Tap close icon
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Add Event to My Calendar'), findsNothing);
    });

    testWidgets('color selection updates when chip is tapped', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(
            body: CreateEventDialog(
              calendarId: 'test-calendar-id',
              calendarName: 'My Calendar',
            ),
          ),
        ),
      );

      await tester.pumpWidget(scope);

      // Black should be selected by default
      final blackChip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Black'),
      );
      expect(blackChip.selected, true);

      // Tap the Red chip
      await tester.tap(find.text('Red'));
      await tester.pump();

      // Red should now be selected
      final redChip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Red'),
      );
      expect(redChip.selected, true);

      // Black should no longer be selected
      final blackChipAfter = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Black'),
      );
      expect(blackChipAfter.selected, false);
    });

    testWidgets('checkbox can be toggled', (tester) async {
      final scope = await createTestProviderScope(
        child: const MaterialApp(
          home: Scaffold(
            body: CreateEventDialog(
              calendarId: 'test-calendar-id',
              calendarName: 'My Calendar',
            ),
          ),
        ),
      );

      await tester.pumpWidget(scope);

      // Checkbox should be unchecked initially
      final checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(checkbox.value, false);

      // Tap the checkbox
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pump();

      // Checkbox should now be checked
      final checkboxAfter = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(checkboxAfter.value, true);
    });
  });
}
