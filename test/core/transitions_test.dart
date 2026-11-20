import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoPageTransitionsBuilder;
import 'package:demo_project/core/theme/app_theme.dart';
import 'package:demo_project/core/widgets/widgets.dart';
import 'package:demo_project/features/auth/presentation/welcome_screen.dart';
import 'package:demo_project/features/medicines/presentation/inventory_screen.dart';
import 'package:demo_project/features/medicines/presentation/medicine_detail_screen.dart';
import 'package:demo_project/core/navigation/app_transitions.dart';
import 'package:demo_project/features/medicines/presentation/medicine_form_screen.dart';
import 'package:demo_project/features/shell/not_found_screen.dart';
import 'package:demo_project/features/onboarding/presentation/onboarding_screen.dart';
import 'package:demo_project/features/shell/home_shell.dart';
import 'package:demo_project/features/today/presentation/today_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';

/// Combined opacity of every FadeTransition above [type].
double opacityOf(Type type) => find
    .ancestor(
      of: find.byType(type, skipOffstage: false),
      matching: find.byType(FadeTransition),
    )
    .evaluate()
    .map((e) => (e.widget as FadeTransition).opacity.value)
    .fold(1, (a, b) => a * b);

/// Combined scale of every ScaleTransition above [type].
double scaleOf(Type type) => find
    .ancestor(
      of: find.byType(type, skipOffstage: false),
      matching: find.byType(ScaleTransition),
    )
    .evaluate()
    .map((e) => (e.widget as ScaleTransition).scale.value)
    .fold(1, (a, b) => a * b);

/// Transition progress of the route showing [type].
double routeProgress(Type type) =>
    ModalRoute.of(find.byType(type, skipOffstage: false).evaluate().first)!
        .animation!
        .value;

/// Pumps [duration] in 16 ms frames, like a 60 Hz device. (Single large
/// pumps count as slow frames, which transitions deliberately clamp.)
Future<void> pumpFrames(WidgetTester tester, Duration duration) async {
  const frame = Duration(milliseconds: 16);
  for (var t = Duration.zero; t < duration; t += frame) {
    await tester.pump(frame);
  }
}

/// Simulates the transition's first frame taking 500 ms, as when a screen
/// is built for the first time (much slower in debug builds).
Future<void> slowFirstFrame(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  group('a slow first frame does not skip the transition', () {
    testWidgets('splash → walkthrough → welcome → home', (tester) async {
      await pumpApp(
        tester,
        signedIn: false,
        size: const Size(400, 860),
        settle: false,
      );
      // Run the splash at 60 Hz until the walkthrough route is created...
      final walkthrough = find.byType(OnboardingScreen, skipOffstage: false);
      for (var i = 0; i < 200 && walkthrough.evaluate().isEmpty; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      // ...then make its first frame slow.
      await tester.pump(const Duration(milliseconds: 500));
      expect(routeProgress(OnboardingScreen), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('onboarding-skip')));
      await slowFirstFrame(tester);
      expect(routeProgress(WelcomeScreen), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('continue-guest')));
      await slowFirstFrame(tester);
      expect(routeProgress(HomeShell), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      expect(routeProgress(HomeShell), 1);
    });

    testWidgets('opening and closing Add medicine', (tester) async {
      await pumpApp(tester);
      await tapAndSettle(tester, find.byKey(const ValueKey('nav-inventory')));
      await tester.tap(find.byKey(const ValueKey('add-medicine')));
      await slowFirstFrame(tester);
      expect(routeProgress(MedicineFormScreen), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();

      final form = ModalRoute.of(
        tester.element(find.byType(MedicineFormScreen)),
      )!;
      await tester.ensureVisible(find.byKey(const ValueKey('cancel-medicine')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('cancel-medicine')));
      await slowFirstFrame(tester);
      // Still animating out rather than vanishing.
      expect(form.animation!.value, inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      expect(find.byType(MedicineFormScreen), findsNothing);
    });
  });

  testWidgets('every screen uses the same transition as Add medicine', (
    tester,
  ) async {
    await pumpApp(tester, signedIn: false, size: const Size(400, 860));

    /// Captured while each route is live (popped routes lose their navigator).
    final routes =
        <
          String,
          ({Type type, Duration forward, Duration reverse, bool fullscreen})
        >{};

    /// Runs [navigate], checks that [screen] animates in (mid-transition
    /// after three frames), and records its route.
    Future<void> openAndCheck(
      String name,
      Type screen,
      Future<void> Function() navigate,
    ) async {
      await navigate();
      await tester.pump();
      await pumpFrames(tester, const Duration(milliseconds: 48));
      final route = ModalRoute.of(
        find.byType(screen, skipOffstage: false).evaluate().first,
      )!;
      expect(route.animation!.value, inExclusiveRange(0, 1), reason: name);
      expect(route, isA<AppPageRoute<Object?>>(), reason: name);
      routes[name] = (
        type: route.runtimeType,
        forward: route.transitionDuration,
        reverse: route.reverseTransitionDuration,
        fullscreen: (route as PageRoute).fullscreenDialog,
      );
      await tester.pumpAndSettle(frame60Hz);
    }

    Future<void> tap(String key) async {
      final finder = find.byKey(ValueKey(key));
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle(frame60Hz);
      await tester.tap(finder);
    }

    // Tapping the splash moves on immediately (same transition as its timer).
    await openAndCheck(
      'walkthrough',
      OnboardingScreen,
      () => tester.tap(find.byType(BrandLogo)),
    );
    await openAndCheck('welcome', WelcomeScreen, () => tap('onboarding-skip'));
    // Sign in (simulated Google) so every member screen can be opened.
    await openAndCheck('home', HomeShell, () async {
      await tap('social-google');
      await tester.pumpAndSettle(frame60Hz);
      await tester.tap(find.text('Continue to demo'));
    });
    await tester.tap(find.byKey(const ValueKey('nav-inventory')));
    await tester.pumpAndSettle(frame60Hz);
    await openAndCheck(
      'add medicine',
      AddMedicineScreen,
      () => tap('add-medicine'),
    );
    await tap('cancel-medicine');
    await tester.pumpAndSettle(frame60Hz);
    await openAndCheck(
      'detail',
      MedicineDetailScreen,
      () => tap('medicine-sample-brevora'),
    );
    await openAndCheck('edit medicine', EditMedicineScreen, () async {
      final editButton = find.text('Edit medicine');
      await tester.ensureVisible(editButton);
      await tester.pumpAndSettle(frame60Hz);
      await tester.tap(editButton);
    });
    await tap('cancel-medicine');
    await tester.pumpAndSettle(frame60Hz);
    await tester.tap(find.byKey(const ValueKey('nav-profile')));
    await tester.pumpAndSettle(frame60Hz);
    await openAndCheck('licenses', LicensePage, () => tap('row-licenses'));
    await tester.pageBack();
    await tester.pumpAndSettle(frame60Hz);
    await openAndCheck(
      'not found',
      NotFoundScreen,
      () => routerOf(tester).navigatePath('/no/such/page'),
    );

    final reference = routes['add medicine']!;
    for (final MapEntry(key: name, value: route) in routes.entries) {
      expect(route.forward, reference.forward, reason: name);
      expect(route.reverse, reference.reverse, reason: name);
    }
    // Only Add medicine is a full-screen dialog (unchanged UI/behavior).
    expect(reference.fullscreen, isTrue);
    expect(routes.entries.where((e) => e.value.fullscreen).map((e) => e.key), [
      'add medicine',
    ]);
  });

  testWidgets('switching tabs is a quick cross-fade; old tab stays alive', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey('nav-inventory')));
    await tester.pump();
    await pumpFrames(tester, const Duration(milliseconds: 32));
    // The new tab is already appearing (no delayed phase), the old one is
    // fading out, and nothing is scaled.
    expect(opacityOf(InventoryScreen), greaterThanOrEqualTo(0.5));
    expect(opacityOf(TodayScreen), inExclusiveRange(0, 1));
    expect(scaleOf(InventoryScreen), 1);
    // Done within ~150 ms.
    await pumpFrames(tester, const Duration(milliseconds: 128));
    expect(opacityOf(InventoryScreen), 1);
    expect(find.byType(TodayScreen), findsNothing);
    // Old tab is offstage but still mounted (state preserved).
    expect(find.byType(TodayScreen, skipOffstage: false), findsOneWidget);
  });

  testWidgets('a slow frame finishes a tab switch on time (no stretching)', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const ValueKey('nav-inventory')));
    await slowFirstFrame(tester); // one 500 ms frame
    // Unlike screen pushes, tab switches are not frame-clamped: they must
    // feel instant, so the switch is already complete.
    expect(opacityOf(InventoryScreen), 1);
    expect(find.byType(TodayScreen), findsNothing);
  });

  testWidgets('drill-down uses an animated push', (tester) async {
    await pumpApp(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-inventory')));
    await tester.tap(find.byKey(const ValueKey('medicine-sample-brevora')));
    await tester.pump();
    await pumpFrames(tester, const Duration(milliseconds: 100));
    final route = ModalRoute.of(
      tester.element(find.byType(MedicineDetailScreen, skipOffstage: false)),
    )!;
    expect(route.animation!.value, inExclusiveRange(0, 1));
    await tester.pumpAndSettle();
    expect(route.animation!.value, 1);
  });

  testWidgets('reduced motion: tabs dissolve briefly without scaling', (
    tester,
  ) async {
    await pumpApp(tester, reduceMotion: true);
    await tester.tap(find.byKey(const ValueKey('nav-inventory')));
    await tester.pump();
    await pumpFrames(tester, const Duration(milliseconds: 64));
    expect(opacityOf(InventoryScreen), inExclusiveRange(0, 1));
    expect(scaleOf(InventoryScreen), 1);
    await pumpFrames(tester, const Duration(milliseconds: 112)); // > 150 ms
    expect(opacityOf(InventoryScreen), 1);
  });

  test('push transitions are explicit per platform', () {
    final builders = AppTheme.light.pageTransitionsTheme.builders;
    expect(
      builders[TargetPlatform.android],
      isA<PredictiveBackPageTransitionsBuilder>(),
    );
    expect(
      builders[TargetPlatform.iOS],
      isA<CupertinoPageTransitionsBuilder>(),
    );
  });
}
