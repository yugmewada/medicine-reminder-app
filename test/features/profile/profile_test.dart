import 'package:demo_project/app/app.dart';
import 'package:demo_project/core/providers/core_providers.dart';
import 'package:demo_project/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  Future<void> openProfile(WidgetTester tester) =>
      tapAndSettle(tester, find.byKey(const ValueKey('nav-profile')));

  testWidgets('shows the demo profile and app version', (tester) async {
    await pumpApp(tester);
    await openProfile(tester);
    expect(find.text('Jordan Ellis'), findsOneWidget);
    expect(find.text('jordan.ellis@example.com'), findsOneWidget);
    expect(
      find.text('Demo profile · Google sign-in simulated'),
      findsOneWidget,
    );
    expect(find.text('Doseza 1.0.0 (build 1) · Prototype'), findsOneWidget);
  });

  for (final (key, title, phrase) in [
    ('row-terms', 'Terms and Conditions', 'no terms and conditions'),
    ('row-privacy', 'Privacy Policy', 'no backend'),
    ('row-share', 'Share App', 'not available in this prototype'),
  ]) {
    testWidgets('$title opens an honest placeholder dialog', (tester) async {
      await pumpApp(tester);
      await openProfile(tester);
      await tapAndSettle(tester, find.byKey(ValueKey(key)));
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining(phrase), findsOneWidget);
      await tapAndSettle(tester, find.text('Close'));
      expect(find.byType(AlertDialog), findsNothing);
    });
  }

  testWidgets('licenses row opens the license page', (tester) async {
    await pumpApp(tester);
    await openProfile(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('row-licenses')));
    expect(find.byType(LicensePage), findsOneWidget);
  });

  testWidgets('logout asks first, returns to Welcome and resets demo data', (
    tester,
  ) async {
    // Starts signed out so that sign-in after logout uses the real flow.
    await pumpApp(tester, signedIn: false);
    await tester.tap(find.byType(BrandLogo));
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.byKey(const ValueKey('onboarding-skip')));
    await tapAndSettle(tester, find.byKey(const ValueKey('social-google')));
    await tapAndSettle(tester, find.text('Continue to demo'));

    // Make session changes: log a dose and edit stock.
    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('dose-taken-sample-brevora|2026-11-19|08:00')),
    );
    expect(find.textContaining('1 of 4'), findsOneWidget);
    TopSnackbar.dismiss();
    await tester.pumpAndSettle();

    await openProfile(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('row-logout')));
    expect(find.text('Log out of the demo?'), findsOneWidget);
    await tapAndSettle(tester, find.text('Cancel'));
    expect(find.text('Jordan Ellis'), findsOneWidget);

    await tapAndSettle(tester, find.byKey(const ValueKey('row-logout')));
    await tapAndSettle(tester, find.widgetWithText(TextButton, 'Log out'));
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Logged out. Demo changes were cleared.'), findsOneWidget);
    // Onboarding is not repeated after logout.
    expect(find.text('All your medicines in one place'), findsNothing);

    TopSnackbar.dismiss();
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.byKey(const ValueKey('social-google')));
    await tapAndSettle(tester, find.text('Continue to demo'));
    expect(find.textContaining('0 of 4'), findsOneWidget);
  });

  testWidgets('a fresh app start has no session changes', (tester) async {
    // Nothing persists: a new ProviderScope starts from sample data.
    final container = ProviderContainer(
      overrides: [clockProvider.overrideWithValue(() => fixedNow)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pump(); // auto_route resolves the launch route async
    await tester.tap(find.byType(BrandLogo));
    await tester.pumpAndSettle();
    expect(find.text('All your medicines in one place'), findsOneWidget);
  });
}
