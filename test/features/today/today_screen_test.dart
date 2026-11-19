import 'package:demo_project/core/widgets/widgets.dart';
import 'package:demo_project/features/medicines/presentation/medicines_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  String headline(WidgetTester tester) => tester
      .widget<Text>(find.byKey(const ValueKey('progress-headline')))
      .data!;

  Finder dayCell(String key) => find.byKey(ValueKey('day-$key'));
  Finder taken(String id) => find.byKey(ValueKey('dose-taken-$id'));
  Finder status(String id) => find.byKey(ValueKey('status-$id'));

  testWidgets('greets the demo user and shows today', (tester) async {
    await pumpApp(tester);
    expect(find.text('Good morning, Jordan'), findsOneWidget);
    expect(find.text('Today · Thursday, November 19'), findsOneWidget);
    expect(find.text("Today's plan"), findsOneWidget);
    expect(headline(tester), '0 of 4 scheduled doses logged as taken — 0%');
    // Earlier today and not logged vs later today.
    expect(
      find.descendant(
        of: status('sample-brevora|2026-11-19|08:00'),
        matching: find.text('Not logged'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: status('sample-ceralin|2026-11-19|13:00'),
        matching: find.text('Upcoming'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('selecting a date updates the label and that day\'s plan', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapAndSettle(tester, dayCell('2026-11-16'));
    expect(find.text('Monday, November 16'), findsOneWidget);
    expect(find.text('Plan for Nov 16'), findsOneWidget);
    expect(find.text('Dulvexa'), findsOneWidget);
    expect(headline(tester), '0 of 5 scheduled doses logged as taken — 0%');

    // "Today" jumps back.
    await tapAndSettle(tester, find.byKey(const ValueKey('jump-today')));
    expect(find.text('Today · Thursday, November 19'), findsOneWidget);
    expect(find.text('Dulvexa'), findsNothing);
  });

  testWidgets('1 of 5 taken shows 20%, and Undo corrects it', (tester) async {
    await pumpApp(tester);
    await tapAndSettle(tester, dayCell('2026-11-16'));
    const id = 'sample-brevora|2026-11-16|08:00';
    await tapAndSettle(tester, taken(id));

    expect(headline(tester), '1 of 5 scheduled doses logged as taken — 20%');
    expect(find.text('20%'), findsOneWidget);
    expect(
      find.descendant(of: status(id), matching: find.text('Taken')),
      findsOneWidget,
    );
    expect(find.textContaining('logged as taken.'), findsOneWidget);

    // Undo from the top snackbar.
    await tester.tap(
      find.descendant(
        of: find.byType(Dismissible),
        matching: find.text('Undo'),
      ),
    );
    await tester.pumpAndSettle();
    expect(headline(tester), '0 of 5 scheduled doses logged as taken — 0%');
    expect(taken(id), findsOneWidget);
  });

  testWidgets('skip counts as logged but not taken; in-card Undo resets', (
    tester,
  ) async {
    await pumpApp(tester);
    const id = 'sample-brevora|2026-11-19|08:00';
    await tapAndSettle(tester, find.byKey(const ValueKey('dose-skip-$id')));
    TopSnackbar.dismiss();
    await tester.pumpAndSettle();

    expect(headline(tester), '0 of 4 scheduled doses logged as taken — 0%');
    expect(find.text('1 skipped · 3 not logged yet'), findsOneWidget);
    expect(
      find.descendant(of: status(id), matching: find.text('Skipped')),
      findsOneWidget,
    );

    await tapAndSettle(tester, find.byKey(const ValueKey('dose-undo-$id')));
    expect(find.text('4 not logged yet'), findsOneWidget);
  });

  testWidgets('logs are kept per date', (tester) async {
    await pumpApp(tester);
    await tapAndSettle(tester, taken('sample-brevora|2026-11-19|08:00'));
    expect(headline(tester), '1 of 4 scheduled doses logged as taken — 25%');
    // The top snackbar overlays the date strip until dismissed.
    TopSnackbar.dismiss();
    await tester.pumpAndSettle();
    await tapAndSettle(tester, dayCell('2026-11-18'));
    expect(headline(tester), '0 of 4 scheduled doses logged as taken — 0%');
    await tapAndSettle(tester, dayCell('2026-11-19'));
    expect(headline(tester), '1 of 4 scheduled doses logged as taken — 25%');
  });

  testWidgets('future dates cannot be logged yet', (tester) async {
    await pumpApp(tester);
    await tapAndSettle(tester, dayCell('2026-11-20'));
    expect(find.text('You can log this dose on the day.'), findsNWidgets(4));
    expect(find.text('Taken'), findsNothing);
    expect(find.text('Scheduled'), findsNWidgets(4));
  });

  testWidgets('no scheduled doses shows an empty state and no percentage', (
    tester,
  ) async {
    await pumpApp(
      tester,
      extraOverrides: [medicinesProvider.overrideWith(EmptyMedicines.new)],
    );
    expect(headline(tester), 'No doses scheduled for this day');
    expect(find.text('Nothing scheduled'), findsOneWidget);
    expect(find.text('–'), findsOneWidget);
    expect(find.textContaining('%'), findsNothing);
  });

  testWidgets('date cells expose date, today and selected state', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpApp(tester);
    expect(
      tester.getSemantics(dayCell('2026-11-19')),
      isSemantics(
        label: 'Thursday, November 19, today',
        isSelected: true,
        isButton: true,
      ),
    );
    expect(
      tester.getSemantics(dayCell('2026-11-18')),
      isSemantics(label: 'Wednesday, November 18', isSelected: false),
    );
    semantics.dispose();
  });
}
