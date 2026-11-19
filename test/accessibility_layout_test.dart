import 'package:demo_project/core/widgets/widgets.dart';
import 'package:demo_project/features/medicines/presentation/inventory_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/test_app.dart';

/// Layout and accessibility checks for every main screen.
///
/// Overflow throws during layout, so pumping each screen at each size is the
/// check. These run on the test host only; they are not device validation.
void main() {
  final screens = <String, Future<void> Function(WidgetTester)>{
    'Today': (t) async {},
    'Inventory': (t) =>
        tapAndSettle(t, find.byKey(const ValueKey('nav-inventory'))),
    'Profile': (t) =>
        tapAndSettle(t, find.byKey(const ValueKey('nav-profile'))),
    'Add medicine form': (t) async {
      await tapAndSettle(t, find.byKey(const ValueKey('nav-inventory')));
      await tapAndSettle(t, find.byKey(const ValueKey('add-medicine')));
    },
    'Medicine detail': (t) async {
      await tapAndSettle(t, find.byKey(const ValueKey('nav-inventory')));
      // At large text sizes the first card can start below the fold.
      final card = find.byKey(const ValueKey('medicine-sample-brevora'));
      await t.scrollUntilVisible(
        card,
        200,
        scrollable: find
            .descendant(
              of: find.byType(InventoryScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tapAndSettle(t, card);
    },
  };

  final layouts = <String, (Size, double)>{
    'small phone 320x568': (const Size(320, 568), 1),
    'iPhone-size 390x844': (const Size(390, 844), 1),
    'large phone 430x932': (const Size(430, 932), 1),
    'landscape 844x390': (const Size(844, 390), 1),
    '200% text on 360x780': (const Size(360, 780), 2),
  };

  for (final MapEntry(key: layout, value: (size, scale)) in layouts.entries) {
    for (final MapEntry(key: screen, value: open) in screens.entries) {
      testWidgets('$screen: no overflow on $layout', (tester) async {
        await pumpApp(tester, size: size, textScale: scale);
        await open(tester);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('Splash, onboarding and welcome: no overflow on $layout', (
      tester,
    ) async {
      await pumpApp(tester, signedIn: false, size: size, textScale: scale);
      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pumpAndSettle();
      for (var i = 0; i < 2; i++) {
        await tapAndSettle(
          tester,
          find.byKey(const ValueKey('onboarding-next')),
        );
      }
      await tapAndSettle(tester, find.byKey(const ValueKey('onboarding-next')));
      await tester.ensureVisible(find.byKey(const ValueKey('continue-guest')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final MapEntry(key: screen, value: open) in screens.entries) {
    testWidgets('$screen: lays out right-to-left without overflow', (
      tester,
    ) async {
      await pumpApp(
        tester,
        size: const Size(360, 780),
        textDirection: TextDirection.rtl,
      );
      await open(tester);
      expect(tester.takeException(), isNull);
      expect(
        Directionality.of(tester.element(find.byType(Scaffold).last)),
        TextDirection.rtl,
      );
    });
  }

  testWidgets('form stays usable with the keyboard open', (tester) async {
    await pumpApp(tester, size: const Size(360, 740));
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-inventory')));
    await tapAndSettle(tester, find.byKey(const ValueKey('add-medicine')));
    // Simulate a 300px keyboard.
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.showKeyboard(find.byKey(const ValueKey('field-quantity')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.byKey(const ValueKey('save-medicine')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('save-medicine')).hitTestable(),
      findsOneWidget,
    );
  });

  // Light only: the app has no dark mode. Guest mode adds the inventory
  // banner and a different profile, so check those too.
  for (final guest in [false, true]) {
    final who = guest ? 'guest' : 'signed in';
    for (final MapEntry(key: screen, value: open) in screens.entries) {
      if (guest && screen == 'Add medicine form') continue; // not for guests
      testWidgets('$screen ($who): tap targets, labels and contrast', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        await pumpApp(tester, size: const Size(400, 900), guest: guest);
        await open(tester);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        semantics.dispose();
      });
    }
  }

  testWidgets('Welcome: accessibility guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpApp(tester, signedIn: false, size: const Size(400, 900));
    await tester.tap(find.byType(BrandLogo));
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.byKey(const ValueKey('onboarding-skip')));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    semantics.dispose();
  });

  testWidgets('reduced motion: app still reaches Home', (tester) async {
    await pumpApp(tester, signedIn: false, reduceMotion: true);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.byKey(const ValueKey('onboarding-skip')));
    await tapAndSettle(tester, find.byKey(const ValueKey('continue-guest')));
    expect(find.text('Good morning'), findsOneWidget);
  });
}
