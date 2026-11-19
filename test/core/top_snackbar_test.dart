import 'package:demo_project/app/app.dart';
import 'package:demo_project/core/l10n/l10n.dart';
import 'package:demo_project/core/theme/app_theme.dart';
import 'package:demo_project/core/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late BuildContext hostContext;

  Future<void> pumpHost(
    WidgetTester tester, {
    bool reduceMotion = false,
  }) async {
    if (reduceMotion) {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
    }
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: App.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            hostContext = context;
            return const Scaffold(body: SizedBox.expand());
          },
        ),
      ),
    );
  }

  testWidgets('slides in at the top of the screen', (tester) async {
    await pumpHost(tester);
    TopSnackbar.show(hostContext, message: 'Saved');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Mid-animation it is still above its resting place.
    final midTop = tester.getTopLeft(find.text('Saved')).dy;
    await tester.pumpAndSettle();
    final restTop = tester.getTopLeft(find.text('Saved')).dy;
    expect(midTop, lessThan(restTop));
    expect(restTop, lessThan(100));
  });

  testWidgets('close button dismisses it', (tester) async {
    await pumpHost(tester);
    TopSnackbar.show(hostContext, message: 'Hello');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Dismiss'));
    await tester.pumpAndSettle();
    expect(find.text('Hello'), findsNothing);
  });

  testWidgets('swiping up dismisses it', (tester) async {
    await pumpHost(tester);
    TopSnackbar.show(hostContext, message: 'Swipe me');
    await tester.pumpAndSettle();
    await tester.fling(find.text('Swipe me'), const Offset(0, -200), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Swipe me'), findsNothing);
  });

  testWidgets('auto-dismisses after its duration', (tester) async {
    await pumpHost(tester);
    TopSnackbar.show(
      hostContext,
      message: 'Brief',
      duration: const Duration(seconds: 2),
    );
    await tester.pumpAndSettle();
    expect(find.text('Brief'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Brief'), findsNothing);
  });

  testWidgets('action runs and then dismisses', (tester) async {
    await pumpHost(tester);
    var undone = false;
    TopSnackbar.show(
      hostContext,
      message: 'Logged',
      actionLabel: 'Undo',
      onAction: () => undone = true,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(undone, isTrue);
    expect(find.text('Logged'), findsNothing);
  });

  testWidgets('a new snackbar replaces the current one', (tester) async {
    await pumpHost(tester);
    TopSnackbar.show(hostContext, message: 'First');
    await tester.pumpAndSettle();
    TopSnackbar.show(hostContext, message: 'Second');
    await tester.pumpAndSettle();
    expect(find.text('First'), findsNothing);
    expect(find.text('Second'), findsOneWidget);
  });

  testWidgets('reduced motion shows it immediately', (tester) async {
    await pumpHost(tester, reduceMotion: true);
    TopSnackbar.show(hostContext, message: 'Instant');
    await tester.pump();
    final opacity = tester.widget<FadeTransition>(
      find
          .ancestor(
            of: find.text('Instant'),
            matching: find.byType(FadeTransition),
          )
          .first,
    );
    expect(opacity.opacity.value, 1);
  });

  testWidgets('is a live region with an accessible close button', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpHost(tester);
    TopSnackbar.show(hostContext, message: 'Announce me');
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(find.text('Announce me')),
      isSemantics(label: 'Announce me', isLiveRegion: true),
    );
    expect(
      tester.getSemantics(find.byTooltip('Dismiss')),
      isSemantics(tooltip: 'Dismiss', isButton: true, hasTapAction: true),
    );
    semantics.dispose();
  });
}
