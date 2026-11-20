import 'package:demo_project/core/widgets/widgets.dart';
import 'package:demo_project/features/medicines/presentation/inventory_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';

void main() {
  final bar = find.byType(AppTabBar);
  Finder tab(String name) => find.byKey(ValueKey('nav-$name'));

  /// The sliding capsule behind the selected tab.
  final capsule = find.descendant(
    of: find.descendant(of: bar, matching: find.byType(AnimatedAlign)),
    matching: find.byType(FractionallySizedBox),
  );

  /// Top of the glass pill (the clipped area).
  double barTop(WidgetTester tester) => tester
      .getTopLeft(find.descendant(of: bar, matching: find.byType(ClipRRect)))
      .dy;

  testWidgets('floats with margins, above the iOS home indicator', (
    tester,
  ) async {
    tester.view
      ..padding = const FakeViewPadding(bottom: 34)
      ..viewPadding = const FakeViewPadding(bottom: 34);
    await pumpApp(tester, size: const Size(390, 844));
    final pill = tester.getRect(
      find.descendant(of: bar, matching: find.byType(ClipRRect)),
    );
    expect(pill.left, greaterThan(0)); // detached from the edges
    expect(pill.right, lessThan(390));
    expect(pill.bottom, lessThanOrEqualTo(844 - 34)); // above home indicator
  });

  testWidgets('caps its width on wide screens', (tester) async {
    await pumpApp(tester, size: const Size(1024, 768));
    final pill = tester.getRect(
      find.descendant(of: bar, matching: find.byType(ClipRRect)),
    );
    expect(pill.width, lessThanOrEqualTo(440));
    expect(pill.center.dx, closeTo(512, 1));
  });

  testWidgets('labels always visible; selected tab is filled and marked', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpApp(tester);
    for (final label in ['Today', 'Inventory', 'Profile']) {
      expect(
        find.descendant(of: bar, matching: find.text(label)),
        findsOneWidget,
      );
    }
    expect(
      find.descendant(of: bar, matching: find.byIcon(Icons.today_rounded)),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: bar,
        matching: find.byIcon(Icons.inventory_2_outlined),
      ),
      findsOneWidget,
    );
    expect(
      tester.getSemantics(tab('today')),
      isSemantics(
        label: 'Today',
        hint: 'Tab 1 of 3',
        isSelected: true,
        isButton: true,
        hasTapAction: true,
      ),
    );
    expect(
      tester.getSemantics(tab('profile')),
      isSemantics(label: 'Profile', hint: 'Tab 3 of 3', isSelected: false),
    );

    await tapAndSettle(tester, tab('inventory'));
    expect(
      find.descendant(
        of: bar,
        matching: find.byIcon(Icons.inventory_2_rounded),
      ),
      findsOneWidget,
    );
    expect(
      tester.getSemantics(tab('inventory')),
      isSemantics(isSelected: true),
    );
    expect(tester.getSemantics(tab('today')), isSemantics(isSelected: false));
    semantics.dispose();
  });

  testWidgets('the capsule slides to the selected tab', (tester) async {
    await pumpApp(tester);
    double capsuleX() => tester.getCenter(capsule).dx;
    expect(capsuleX(), closeTo(tester.getCenter(tab('today')).dx, 1));

    await tester.tap(tab('profile'));
    await tester.pump();
    // easeOutBack passes its midpoint early; sample near the start.
    await tester.pump(const Duration(milliseconds: 40));
    final mid = capsuleX();
    expect(mid, greaterThan(tester.getCenter(tab('today')).dx + 10));
    expect(mid, lessThan(tester.getCenter(tab('profile')).dx - 10));

    await tester.pumpAndSettle(frame60Hz);
    expect(capsuleX(), closeTo(tester.getCenter(tab('profile')).dx, 1));
  });

  testWidgets('feedback is immediate: icon, tab and capsule on frame one', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(tab('inventory'));
    await tester.pump(); // a single frame
    expect(
      find.descendant(
        of: bar,
        matching: find.byIcon(Icons.inventory_2_rounded),
      ),
      findsOneWidget,
    );
    expect(find.byType(InventoryScreen), findsOneWidget);
    final capsuleMoved = tester.getCenter(capsule).dx;
    await tester.pump(frame60Hz);
    expect(tester.getCenter(capsule).dx, greaterThan(capsuleMoved));
  });

  testWidgets('the capsule lands within ~150 ms and never overshoots', (
    tester,
  ) async {
    await pumpApp(tester);
    final target = tester.getCenter(tab('profile')).dx;
    await tester.tap(tab('profile'));
    await tester.pump();
    for (var t = 0; t < 160; t += 16) {
      await tester.pump(frame60Hz);
      expect(tester.getCenter(capsule).dx, lessThanOrEqualTo(target + 0.5));
    }
    expect(tester.getCenter(capsule).dx, closeTo(target, 0.5));
  });

  testWidgets('reduced motion: the capsule moves without animating', (
    tester,
  ) async {
    await pumpApp(tester, reduceMotion: true);
    await tester.tap(tab('profile'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    expect(
      tester.getCenter(capsule).dx,
      closeTo(tester.getCenter(tab('profile')).dx, 1),
    );
  });

  testWidgets('RTL: tabs mirror and the capsule follows the selected tab', (
    tester,
  ) async {
    await pumpApp(tester, textDirection: TextDirection.rtl);
    // Today (first tab) is now on the right.
    expect(
      tester.getCenter(tab('today')).dx,
      greaterThan(tester.getCenter(tab('profile')).dx),
    );
    expect(
      tester.getCenter(capsule).dx,
      closeTo(tester.getCenter(tab('today')).dx, 1),
    );
  });

  testWidgets('200% text: labels stay readable without overflow', (
    tester,
  ) async {
    await pumpApp(tester, size: const Size(320, 640), textScale: 2);
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(of: bar, matching: find.text('Inventory')),
      findsOneWidget,
    );
  });

  group('content is never hidden behind the bar', () {
    testWidgets('Today: the last dose card scrolls clear of the bar', (
      tester,
    ) async {
      await pumpApp(tester, size: const Size(390, 700));
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -3000));
      await tester.pumpAndSettle(frame60Hz);
      final lastCard = find.byKey(
        const ValueKey('dose-sample-omnivy|2026-11-19|21:30'),
      );
      expect(
        tester.getRect(lastCard).bottom,
        lessThanOrEqualTo(barTop(tester)),
      );
      // Its buttons can actually be tapped (not covered by the bar).
      expect(
        find
            .byKey(const ValueKey('dose-taken-sample-omnivy|2026-11-19|21:30'))
            .hitTestable(),
        findsOneWidget,
      );
    });

    testWidgets('Today (guest): the empty state clears the bar', (
      tester,
    ) async {
      await pumpApp(tester, size: const Size(390, 600), guest: true);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -3000));
      await tester.pumpAndSettle(frame60Hz);
      final add = find.widgetWithText(OutlinedButton, 'Add medicine');
      expect(tester.getRect(add).bottom, lessThanOrEqualTo(barTop(tester)));
    });

    testWidgets('Inventory: FAB and last card sit above the bar', (
      tester,
    ) async {
      await pumpApp(tester, size: const Size(390, 700));
      await tapAndSettle(tester, tab('inventory'));
      final fab = find.byKey(const ValueKey('add-medicine'));
      expect(
        tester.getRect(find.byType(FloatingActionButton)).bottom,
        lessThanOrEqualTo(barTop(tester)),
      );
      await tester.drag(find.byType(ListView), const Offset(0, -3000));
      await tester.pumpAndSettle(frame60Hz);
      final lastCard = find.byKey(const ValueKey('medicine-sample-novaxil'));
      // The last card ends above both the FAB and the bar.
      expect(
        tester.getRect(lastCard).bottom,
        lessThanOrEqualTo(tester.getRect(fab).top),
      );
    });

    testWidgets('Profile: the version line scrolls clear of the bar', (
      tester,
    ) async {
      await pumpApp(tester, size: const Size(390, 700));
      await tapAndSettle(tester, tab('profile'));
      await tester.drag(find.byType(ListView), const Offset(0, -3000));
      await tester.pumpAndSettle(frame60Hz);
      expect(
        tester.getRect(find.byKey(const ValueKey('app-version'))).bottom,
        lessThanOrEqualTo(barTop(tester)),
      );
    });
  });
}
