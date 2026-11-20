import 'package:demo_project/core/widgets/widgets.dart';
import 'package:demo_project/core/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

/// Any field decorated with an inline error. The form must never show one.
final inlineErrors = find.byWidgetPredicate(
  (w) => w is InputDecorator && w.decoration.errorText != null,
);

void main() {
  Future<void> openInventory(WidgetTester tester) async {
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-inventory')));
  }

  Future<void> openAddForm(WidgetTester tester) async {
    await openInventory(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('add-medicine')));
    expect(find.text('Add medicine'), findsWidgets);
  }

  Future<void> dismissSnack(WidgetTester tester) async {
    TopSnackbar.dismiss();
    await tester.pumpAndSettle();
  }

  Future<void> addTimeAtPickerDefault(WidgetTester tester) async {
    await tapAndSettle(tester, find.byKey(const ValueKey('add-time')));
    await tapAndSettle(tester, find.text('OK'));
  }

  testWidgets('lists sample medicines with stock and an Add action', (
    tester,
  ) async {
    await pumpApp(tester);
    await openInventory(tester);
    for (final name in ['Brevora', 'Ceralin', 'Omnivy', 'Dulvexa', 'Novaxil']) {
      expect(find.text(name), findsOneWidget);
    }
    expect(find.text('42 tablets in stock'), findsOneWidget);
    expect(find.text('150 mL in stock'), findsOneWidget);
    expect(find.text('5 medicines'), findsOneWidget);
    expect(find.textContaining('session only'), findsOneWidget);
  });

  testWidgets('add: validates, then saves and shows on the list and plan', (
    tester,
  ) async {
    await pumpApp(tester);
    await openAddForm(tester);

    // Each save reports the first problem in a snackbar, in screen order.
    Future<void> saveExpecting(String message) async {
      await tapAndSettle(tester, find.byKey(const ValueKey('save-medicine')));
      expect(find.text(message), findsOneWidget);
      expect(inlineErrors, findsNothing);
      await dismissSnack(tester);
    }

    await saveExpecting('Please enter a medicine name.');
    await tester.enterText(find.byKey(const ValueKey('field-name')), 'Lumora');
    await tapAndSettle(tester, find.byKey(const ValueKey('type-liquid')));
    await saveExpecting('Please add at least one schedule time.');
    await addTimeAtPickerDefault(tester);
    expect(find.byKey(const ValueKey('time-10:00')), findsOneWidget);
    await saveExpecting('Please enter the quantity in stock.');
    await tester.enterText(find.byKey(const ValueKey('field-quantity')), '200');
    await tester.pumpAndSettle();
    // Unit follows the type until the user picks one.
    expect(find.text('mL'), findsWidgets);

    await tapAndSettle(tester, find.byKey(const ValueKey('save-medicine')));
    expect(find.text('Lumora added for this session.'), findsOneWidget);
    expect(find.text('Lumora'), findsOneWidget);
    expect(find.text('200 mL in stock'), findsOneWidget);
    expect(find.text('6 medicines'), findsOneWidget);

    // New daily medicine appears on today's plan.
    await dismissSnack(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-today')));
    expect(find.text('Lumora'), findsOneWidget);
    expect(find.textContaining('0 of 5 scheduled doses'), findsOneWidget);
  });

  testWidgets('weekly and monthly frequencies ask for their day', (
    tester,
  ) async {
    await pumpApp(tester);
    await openAddForm(tester);
    expect(find.text('Day of the week'), findsNothing);
    await tapAndSettle(tester, find.byKey(const ValueKey('frequency-weekly')));
    expect(find.text('Day of the week'), findsOneWidget);
    await tapAndSettle(tester, find.byKey(const ValueKey('frequency-monthly')));
    expect(find.text('Day of the week'), findsNothing);
    expect(find.text('Day of the month'), findsOneWidget);
  });

  testWidgets('edit: changes are saved and shown on the detail screen', (
    tester,
  ) async {
    await pumpApp(tester);
    await openInventory(tester);
    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('medicine-sample-ceralin')),
    );
    expect(find.text('18 capsules'), findsOneWidget);
    expect(find.text('Daily · Every day'), findsOneWidget);

    await tapAndSettle(tester, find.text('Edit medicine'));
    expect(find.text('Edit medicine'), findsWidgets);
    await tester.enterText(find.byKey(const ValueKey('field-quantity')), '30');
    await tapAndSettle(tester, find.byKey(const ValueKey('save-medicine')));

    expect(find.text('Ceralin updated for this session.'), findsOneWidget);
    expect(find.text('30 capsules'), findsOneWidget);
  });

  testWidgets('cancel with changes asks before discarding', (tester) async {
    await pumpApp(tester);
    await openAddForm(tester);
    await tester.enterText(find.byKey(const ValueKey('field-name')), 'Draft');
    await tester.pumpAndSettle();

    await tapAndSettle(tester, find.byKey(const ValueKey('cancel-medicine')));
    expect(find.text('Discard changes?'), findsOneWidget);
    await tapAndSettle(tester, find.text('Keep editing'));
    expect(find.text('Draft'), findsOneWidget);

    // System back also asks.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.text('Discard'));
    expect(find.text('Draft'), findsNothing);
    expect(find.text('5 medicines'), findsOneWidget);
  });

  testWidgets('cancel without changes closes immediately', (tester) async {
    await pumpApp(tester);
    await openAddForm(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('cancel-medicine')));
    expect(find.text('Discard changes?'), findsNothing);
    expect(find.text('5 medicines'), findsOneWidget);
  });

  testWidgets('photo: pick shows a preview and can be removed', (tester) async {
    final picker = FakeMediaPicker();
    await pumpApp(tester, picker: picker);
    await openAddForm(tester);

    await tapAndSettle(tester, find.byKey(const ValueKey('pick-photo')));
    expect(picker.calls, 1);
    expect(find.byKey(const ValueKey('remove-photo')), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);

    await tapAndSettle(tester, find.byKey(const ValueKey('remove-photo')));
    expect(find.text('Choose photo'), findsOneWidget);
  });

  testWidgets('photo: cancelling the picker changes nothing', (tester) async {
    await pumpApp(tester, picker: FakeMediaPicker(const MediaPickCancelled()));
    await openAddForm(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('pick-photo')));
    expect(find.text('Choose photo'), findsOneWidget);
    expect(find.byType(Dismissible), findsNothing); // no snackbar
  });

  testWidgets('photo: a picker failure is reported in the top snackbar', (
    tester,
  ) async {
    await pumpApp(
      tester,
      picker: FakeMediaPicker(
        const MediaPickFailed(MediaPickFailure.accessDenied),
      ),
    );
    await openAddForm(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('pick-photo')));
    expect(
      find.text('Photo access is turned off for this app.'),
      findsOneWidget,
    );
    expect(find.text('Choose photo'), findsOneWidget);
  });
}
