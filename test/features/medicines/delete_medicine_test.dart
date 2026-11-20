import 'package:demo_project/core/widgets/widgets.dart';
import 'package:demo_project/features/medicines/presentation/medicine_detail_screen.dart';
import 'package:demo_project/features/medicines/presentation/medicine_form_screen.dart';
import 'package:demo_project/features/medicines/presentation/medicines_controller.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  Finder card(String id) => find.byKey(ValueKey('medicine-$id'));
  final confirmDelete = find.widgetWithText(TextButton, 'Delete');

  Future<void> openInventory(WidgetTester tester) =>
      tapAndSettle(tester, find.byKey(const ValueKey('nav-inventory')));

  Future<void> swipeOpen(WidgetTester tester, String id) async {
    await tester.ensureVisible(card(id));
    await tester.drag(card(id), const Offset(-300, 0));
    await tester.pumpAndSettle(frame60Hz);
  }

  Future<void> dismissSnack(WidgetTester tester) async {
    TopSnackbar.dismiss();
    await tester.pumpAndSettle(frame60Hz);
  }

  group('MedicinesController', () {
    test('delete returns the position; restore puts it back there', () {
      final c = testContainer();
      final inventory = c.read(medicinesProvider.notifier);
      final ceralin = c.read(medicinesProvider)[1];
      expect(inventory.delete(ceralin.id), 1);
      expect(
        c.read(medicinesProvider).map((m) => m.id),
        isNot(contains(ceralin.id)),
      );
      inventory.restore(ceralin, 1);
      expect(c.read(medicinesProvider)[1].id, ceralin.id);
      inventory.restore(ceralin, 1); // no duplicate
      expect(c.read(medicinesProvider), hasLength(5));
      expect(inventory.delete('missing'), -1);
    });
  });

  testWidgets('detail: delete asks first, returns to the list, offers Undo', (
    tester,
  ) async {
    await pumpApp(tester);
    await openInventory(tester);
    await tapAndSettle(tester, card('sample-brevora'));

    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('delete-medicine-button')),
    );
    expect(find.text('Delete Brevora?'), findsOneWidget);
    await tapAndSettle(tester, find.text('Cancel'));
    expect(find.byType(MedicineDetailScreen), findsOneWidget);

    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('delete-medicine-button')),
    );
    await tester.tap(confirmDelete);
    // While the detail animates out it keeps showing the medicine.
    for (var i = 0; i < 10; i++) {
      await tester.pump(frame60Hz);
      expect(find.text('Medicine not found'), findsNothing);
    }
    await tester.pumpAndSettle(frame60Hz);

    expect(find.byType(MedicineDetailScreen), findsNothing);
    expect(card('sample-brevora'), findsNothing);
    expect(find.text('4 medicines'), findsOneWidget);
    expect(find.text('Brevora deleted.'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(Dismissible),
        matching: find.text('Undo'),
      ),
    );
    await tester.pumpAndSettle(frame60Hz);
    expect(card('sample-brevora'), findsOneWidget);
    expect(find.text('5 medicines'), findsOneWidget);
  });

  testWidgets('detail: the Delete medicine button uses the same flow', (
    tester,
  ) async {
    await pumpApp(tester);
    await openInventory(tester);
    await tapAndSettle(tester, card('sample-ceralin'));
    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('delete-medicine-button')),
    );
    expect(find.text('Delete Ceralin?'), findsOneWidget);
    await tapAndSettle(tester, confirmDelete);
    expect(card('sample-ceralin'), findsNothing);
  });

  testWidgets('swipe left reveals Edit and Delete', (tester) async {
    await pumpApp(tester);
    await openInventory(tester);
    expect(
      find.byKey(const ValueKey('swipe-edit-sample-omnivy')),
      findsNothing,
    );

    await swipeOpen(tester, 'sample-omnivy');
    expect(
      find.byKey(const ValueKey('swipe-edit-sample-omnivy')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('swipe-delete-sample-omnivy')),
      findsOneWidget,
    );

    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('swipe-edit-sample-omnivy')),
    );
    expect(find.byType(EditMedicineScreen), findsOneWidget);
    expect(find.text('Omnivy'), findsWidgets);
    await tapAndSettle(tester, find.byKey(const ValueKey('cancel-medicine')));

    await swipeOpen(tester, 'sample-omnivy');
    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('swipe-delete-sample-omnivy')),
    );
    expect(find.text('Delete Omnivy?'), findsOneWidget);
    await tapAndSettle(tester, confirmDelete);
    expect(card('sample-omnivy'), findsNothing);
    expect(find.text('Omnivy deleted.'), findsOneWidget);
  });

  testWidgets('only one card stays open at a time', (tester) async {
    await pumpApp(tester);
    await openInventory(tester);
    await swipeOpen(tester, 'sample-brevora');
    await swipeOpen(tester, 'sample-ceralin');
    expect(
      find.byKey(const ValueKey('swipe-edit-sample-brevora')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('swipe-edit-sample-ceralin')),
      findsOneWidget,
    );
  });

  testWidgets('deleting every medicine shows the empty state', (tester) async {
    await pumpApp(tester);
    await openInventory(tester);
    for (final id in [
      'sample-brevora',
      'sample-ceralin',
      'sample-omnivy',
      'sample-dulvexa',
      'sample-novaxil',
    ]) {
      await swipeOpen(tester, id);
      await tapAndSettle(tester, find.byKey(ValueKey('swipe-delete-$id')));
      await tapAndSettle(tester, confirmDelete);
      await dismissSnack(tester);
    }
    expect(find.text('No medicines yet'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byKey(const ValueKey('add-medicine')), findsOneWidget);

    await tapAndSettle(tester, find.byKey(const ValueKey('nav-today')));
    expect(find.text('Nothing scheduled'), findsOneWidget);
    expect(find.text('No doses scheduled for this day'), findsOneWidget);
  });

  testWidgets('delete updates the plan; Undo restores it with its logs', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('dose-taken-sample-brevora|2026-11-19|08:00')),
    );
    await dismissSnack(tester);
    expect(find.textContaining('1 of 4'), findsOneWidget);

    await openInventory(tester);
    await swipeOpen(tester, 'sample-brevora');
    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('swipe-delete-sample-brevora')),
    );
    await tapAndSettle(tester, confirmDelete);
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-today')));
    expect(find.textContaining('0 of 2'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(Dismissible),
        matching: find.text('Undo'),
      ),
    );
    await tester.pumpAndSettle(frame60Hz);
    expect(find.textContaining('1 of 4'), findsOneWidget);
  });

  testWidgets('screen readers get Edit and Delete as custom actions', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpApp(tester);
    await openInventory(tester);
    final data = tester.getSemantics(card('sample-brevora')).getSemanticsData();
    final labels = [
      for (final id in data.customSemanticsActionIds ?? <int>[])
        CustomSemanticsAction.getAction(id)!.label,
    ];
    expect(labels, containsAll(['Edit', 'Delete']));
    semantics.dispose();
  });
}
