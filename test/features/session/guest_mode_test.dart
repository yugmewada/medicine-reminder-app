import 'package:demo_project/features/medicines/presentation/medicine_form_screen.dart';
import 'package:demo_project/features/medicines/presentation/medicines_controller.dart';
import 'package:demo_project/features/session/session_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  // The sign-in alert (same style as the logout confirmation).
  final prompt = find.widgetWithText(
    AlertDialog,
    'Sign in to manage medicines',
  );
  Finder key(String k) => find.byKey(ValueKey(k));
  final alertSignIn = find.descendant(
    of: find.byType(AlertDialog),
    matching: find.widgetWithText(TextButton, 'Sign in'),
  );

  Future<void> cancel(WidgetTester tester) async {
    await tapAndSettle(tester, find.widgetWithText(TextButton, 'Cancel'));
    expect(prompt, findsNothing);
  }

  group('SessionController', () {
    test('a guest has no profile, no medicines, and cannot manage', () {
      final c = testContainer();
      c.read(sessionProvider.notifier).signIn(SignInMethod.guest);
      final s = c.read(sessionProvider);
      expect(s.isGuest, isTrue);
      expect(s.profile, isNull);
      expect(s.canManageMedicines, isFalse);
      expect(c.read(canManageMedicinesProvider), isFalse);
      expect(c.read(medicinesProvider), isEmpty);
    });

    test('a guest who signs in gets the sample medicines', () {
      final c = testContainer();
      final session = c.read(sessionProvider.notifier)
        ..signIn(SignInMethod.guest);
      expect(c.read(medicinesProvider), isEmpty);
      session.requestSignIn();
      expect(c.read(sessionProvider).stage, AppStage.welcome);
      session.signIn(SignInMethod.apple);
      final s = c.read(sessionProvider);
      expect(s.profile, DemoProfile.sample);
      expect(s.canManageMedicines, isTrue);
      expect(c.read(medicinesProvider), hasLength(5));
    });

    test('requestSignIn does nothing for signed-in users', () {
      final c = testContainer();
      c.read(sessionProvider.notifier)
        ..signIn(SignInMethod.google)
        ..requestSignIn();
      expect(c.read(sessionProvider).stage, AppStage.signedIn);
    });
  });

  testWidgets('guest sees empty screens instead of sample data', (
    tester,
  ) async {
    await pumpApp(tester, guest: true);
    expect(find.text('Good morning'), findsOneWidget);
    expect(find.text('No doses scheduled for this day'), findsOneWidget);
    expect(find.text('Nothing scheduled'), findsOneWidget);
    expect(find.text('Brevora'), findsNothing);

    await tapAndSettle(tester, key('nav-inventory'));
    expect(find.text('No medicines yet'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.text('Brevora'), findsNothing);
  });

  testWidgets('guest: Add asks to sign in (Inventory and Today)', (
    tester,
  ) async {
    await pumpApp(tester, guest: true);

    // Today's empty state.
    await tapAndSettle(
      tester,
      find.widgetWithText(OutlinedButton, 'Add medicine'),
    );
    expect(prompt, findsOneWidget);
    expect(
      find.text(
        "You're using the app as a guest. "
        'Sign in to add, edit or delete medicines.',
      ),
      findsOneWidget,
    );
    await cancel(tester);
    expect(find.byType(MedicineFormScreen), findsNothing);

    // Inventory's empty state.
    await tapAndSettle(tester, key('nav-inventory'));
    await tapAndSettle(tester, key('add-medicine'));
    expect(prompt, findsOneWidget);
    await cancel(tester);
    expect(find.byType(MedicineFormScreen), findsNothing);
  });

  testWidgets('alert Sign in → Welcome → Google gives full access', (
    tester,
  ) async {
    await pumpApp(tester, guest: true);
    await tapAndSettle(tester, key('nav-inventory'));
    await tapAndSettle(tester, key('add-medicine'));
    await tapAndSettle(tester, alertSignIn);
    expect(find.text('Welcome!'), findsOneWidget);

    await tapAndSettle(tester, key('social-google'));
    await tapAndSettle(tester, find.text('Continue to demo'));
    expect(find.text('Good morning, Jordan'), findsOneWidget);
    expect(find.textContaining('0 of 4'), findsOneWidget);

    await tapAndSettle(tester, key('nav-inventory'));
    expect(find.text('Brevora'), findsOneWidget);
    await tapAndSettle(tester, key('add-medicine'));
    expect(prompt, findsNothing);
    expect(find.byType(MedicineFormScreen), findsOneWidget);
  });

  testWidgets('from Welcome a guest can continue as guest again', (
    tester,
  ) async {
    await pumpApp(tester, guest: true);
    await tapAndSettle(tester, key('nav-profile'));
    await tapAndSettle(tester, key('profile-sign-in'));
    expect(find.text('Welcome!'), findsOneWidget);
    await tapAndSettle(tester, key('continue-guest'));
    expect(find.text('Good morning'), findsOneWidget);
    expect(find.text('Nothing scheduled'), findsOneWidget);
  });

  testWidgets('guest profile: Guest identity, Sign in, no logout row', (
    tester,
  ) async {
    await pumpApp(tester, guest: true);
    await tapAndSettle(tester, key('nav-profile'));
    expect(find.text('Guest'), findsOneWidget);
    expect(find.text('Browsing as a guest'), findsOneWidget);
    expect(find.text('Guest mode'), findsOneWidget);
    expect(find.text('Jordan Ellis'), findsNothing);
    expect(key('row-logout'), findsNothing);
    expect(find.text('Exit guest mode'), findsNothing);
    expect(find.text('Log out'), findsNothing);

    await tapAndSettle(tester, key('profile-sign-in'));
    expect(find.text('Welcome!'), findsOneWidget);
    await tapAndSettle(tester, key('social-apple'));
    await tapAndSettle(tester, find.text('Continue to demo'));
    await tapAndSettle(tester, key('nav-profile'));
    expect(find.text('Jordan Ellis'), findsOneWidget);
    expect(find.text('Demo profile · Apple sign-in simulated'), findsOneWidget);
    expect(key('row-logout'), findsOneWidget);
  });

  testWidgets('guest deep links: Add/Edit blocked, sample ids not found', (
    tester,
  ) async {
    await pumpApp(tester, guest: true);
    for (final path in [
      '/inventory/add',
      '/inventory/medicine/sample-brevora/edit',
    ]) {
      await routerOf(tester).navigatePath(path);
      await tester.pumpAndSettle(frame60Hz);
      expect(find.byType(MedicineFormScreen), findsNothing, reason: path);
    }
    await routerOf(tester).navigatePath('/inventory/medicine/sample-brevora');
    await tester.pumpAndSettle(frame60Hz);
    expect(find.text('Medicine not found'), findsOneWidget);
  });
}
