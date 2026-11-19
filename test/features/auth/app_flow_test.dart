import 'package:demo_project/core/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  Future<void> passSplash(WidgetTester tester) async {
    expect(find.text('Doseza'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();
  }

  testWidgets('splash → onboarding → welcome → Google demo → Home', (
    tester,
  ) async {
    await pumpApp(tester, signedIn: false, size: const Size(400, 860));
    await passSplash(tester);

    expect(find.text('All your medicines in one place'), findsOneWidget);
    expect(find.bySemanticsLabel('Page 1 of 3'), findsOneWidget);
    await tapAndSettle(tester, find.byKey(const ValueKey('onboarding-next')));
    expect(find.text('See each day at a glance'), findsOneWidget);
    await tapAndSettle(tester, find.byKey(const ValueKey('onboarding-next')));
    expect(find.text('Progress without pressure'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    await tapAndSettle(tester, find.byKey(const ValueKey('onboarding-next')));

    expect(find.text('Welcome!'), findsOneWidget);
    await tapAndSettle(tester, find.byKey(const ValueKey('social-google')));
    // Explains the simulation before entering.
    expect(find.text('Demo sign-in'), findsOneWidget);
    expect(find.textContaining('Google sign-in is simulated'), findsOneWidget);
    await tapAndSettle(tester, find.text('Continue to demo'));

    expect(find.text('Good morning, Jordan'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('cancelling the demo sign-in dialog stays on Welcome', (
    tester,
  ) async {
    await pumpApp(tester, signedIn: false, size: const Size(400, 860));
    await passSplash(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('onboarding-skip')));
    await tapAndSettle(tester, find.byKey(const ValueKey('social-apple')));
    expect(find.textContaining('Apple sign-in is simulated'), findsOneWidget);
    await tapAndSettle(tester, find.text('Cancel'));
    expect(find.text('Welcome!'), findsOneWidget);
  });

  testWidgets('Skip goes straight to Welcome; Continue as guest enters', (
    tester,
  ) async {
    await pumpApp(tester, signedIn: false, size: const Size(400, 860));
    await passSplash(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('onboarding-skip')));
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.textContaining('Sign-in is simulated'), findsOneWidget);
    expect(find.text('Continue as guest'), findsOneWidget);
    await tapAndSettle(tester, find.byKey(const ValueKey('continue-guest')));
    // Guests are greeted without a name.
    expect(find.text('Good morning'), findsOneWidget);
  });

  testWidgets('system back on onboarding returns to the previous page', (
    tester,
  ) async {
    await pumpApp(tester, signedIn: false, size: const Size(400, 860));
    await passSplash(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('onboarding-next')));
    expect(find.text('See each day at a glance'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('All your medicines in one place'), findsOneWidget);
  });

  testWidgets('tapping the splash skips the wait', (tester) async {
    await pumpApp(tester, signedIn: false, size: const Size(400, 860));
    await tester.tap(find.byType(BrandLogo));
    await tester.pumpAndSettle();
    expect(find.text('All your medicines in one place'), findsOneWidget);
  });
}
