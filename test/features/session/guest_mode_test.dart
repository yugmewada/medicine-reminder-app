import 'package:demo_project/core/widgets/widgets.dart';
import 'package:demo_project/features/medicines/presentation/medicine_detail_screen.dart';
import 'package:demo_project/features/medicines/presentation/medicine_form_screen.dart';
import 'package:demo_project/features/session/session_controller.dart';
import 'package:demo_project/features/today/domain/dose_schedule.dart';
import 'package:demo_project/features/today/presentation/today_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  final prompt = find.byKey(const ValueKey('sign-in-prompt'));
  Finder key(String k) => find.byKey(ValueKey(k));

  Future<void> openInventory(WidgetTester tester) =>
      tapAndSettle(tester, key('nav-inventory'));

  Future<void> notNow(WidgetTester tester) async {
    await tapAndSettle(tester, key('sign-in-not-now'));
    expect(prompt, findsNothing);
  }

  group('SessionController', () {
    test('a guest has no profile and cannot manage medicines', () {
      final c = testContainer();
      c.read(sessionProvider.notifier).signIn(SignInMethod.guest);
      final s = c.read(sessionProvider);
      expect(s.isGuest, isTrue);
      expect(s.profile, isNull);
      expect(s.canManageMedicines, isFalse);
      expect(c.read(canManageMedicinesProvider), isFalse);
    });

    test('a guest signing in keeps session data and gains access', () {
      final c = testContainer();
      final session = c.read(sessionProvider.notifier)
        ..signIn(SignInMethod.guest);
      c.read(doseLogProvider.notifier).log('x', DoseStatus.taken);
      session.upgradeGuest(SignInMethod.apple);
      final s = c.read(sessionProvider);
      expect(s.method, SignInMethod.apple);
      expect(s.profile, DemoProfile.sample);
      expect(s.canManageMedicines, isTrue);
      expect(s.stage, AppStage.signedIn);
      expect(c.read(doseLogProvider), {'x': DoseStatus.taken});
    });

    test('Google/Apple users can manage medicines', () {
      final c = testContainer();
      c.read(sessionProvider.notifier).signIn(SignInMethod.google);
      expect(c.read(sessionProvider).canManageMedicines, isTrue);
    });
  });

  testWidgets('guest can view and log doses, greeted without a name', (
    tester,
  ) async {
    await pumpApp(tester, guest: true);
    expect(find.text('Good morning'), findsOneWidget);
    await tapAndSettle(
      tester,
      key('dose-taken-sample-brevora|2026-11-19|08:00'),
    );
    expect(find.textContaining('1 of 4'), findsOneWidget);
    expect(prompt, findsNothing);
  });

  testWidgets('guest: every medicine change asks to sign in first', (
    tester,
  ) async {
    await pumpApp(tester, guest: true);
    await openInventory(tester);
    expect(key('guest-banner'), findsOneWidget);

    // Add
    await tapAndSettle(tester, key('add-medicine'));
    expect(prompt, findsOneWidget);
    expect(find.text('Sign in to manage medicines'), findsOneWidget);
    await notNow(tester);
    expect(find.byType(MedicineFormScreen), findsNothing);

    // Swipe Edit and Delete
    await tester.drag(key('medicine-sample-brevora'), const Offset(-300, 0));
    await tester.pumpAndSettle(frame60Hz);
    await tapAndSettle(tester, key('swipe-edit-sample-brevora'));
    expect(prompt, findsOneWidget);
    await notNow(tester);
    await tester.drag(key('medicine-sample-brevora'), const Offset(-300, 0));
    await tester.pumpAndSettle(frame60Hz);
    await tapAndSettle(tester, key('swipe-delete-sample-brevora'));
    expect(prompt, findsOneWidget);
    await notNow(tester);
    expect(find.text('Delete Brevora?'), findsNothing);
    expect(key('medicine-sample-brevora'), findsOneWidget);

    // Detail: viewing is allowed; Edit and Delete are not.
    await tapAndSettle(tester, key('medicine-sample-ceralin'));
    expect(find.byType(MedicineDetailScreen), findsOneWidget);
    for (final action in [
      'edit-medicine',
      'delete-medicine',
      'delete-medicine-button',
    ]) {
      await tapAndSettle(tester, key(action));
      expect(prompt, findsOneWidget, reason: action);
      await notNow(tester);
    }
    expect(find.byType(MedicineFormScreen), findsNothing);
  });

  testWidgets('signing in from the prompt continues the action', (
    tester,
  ) async {
    await pumpApp(tester, guest: true);
    await tapAndSettle(
      tester,
      key('dose-taken-sample-brevora|2026-11-19|08:00'),
    );
    TopSnackbar.dismiss();
    await tester.pumpAndSettle(frame60Hz);
    await openInventory(tester);

    await tapAndSettle(tester, key('add-medicine'));
    await tapAndSettle(tester, key('social-google'));
    expect(
      find.text(
        'Signed in with Google (simulated). You can now manage medicines.',
      ),
      findsOneWidget,
    );
    // The add form opens straight away; the guest banner is gone.
    expect(find.byType(MedicineFormScreen), findsOneWidget);
    await tapAndSettle(tester, key('cancel-medicine'));
    expect(key('guest-banner'), findsNothing);

    // Session data survived the sign-in.
    await tapAndSettle(tester, key('nav-today'));
    expect(find.text('Good morning, Jordan'), findsOneWidget);
    expect(find.textContaining('1 of 4'), findsOneWidget);
  });

  testWidgets('guest profile: Guest identity, sign in, exit guest mode', (
    tester,
  ) async {
    await pumpApp(tester, guest: true);
    await tapAndSettle(tester, key('nav-profile'));
    expect(find.text('Guest'), findsOneWidget);
    expect(find.text('Browsing as a guest'), findsOneWidget);
    expect(find.text('Guest mode'), findsOneWidget);
    expect(find.text('Jordan Ellis'), findsNothing);

    await tapAndSettle(tester, key('profile-sign-in'));
    expect(prompt, findsOneWidget);
    await notNow(tester);

    await tapAndSettle(tester, key('row-logout'));
    expect(find.text('Exit guest mode?'), findsOneWidget);
    await tapAndSettle(
      tester,
      find.widgetWithText(TextButton, 'Exit guest mode'),
    );
    expect(find.text('Welcome!'), findsOneWidget);
    expect(
      find.text('Exited guest mode. Session changes were cleared.'),
      findsOneWidget,
    );
  });

  testWidgets('guest profile sign-in switches to the signed-in profile', (
    tester,
  ) async {
    await pumpApp(tester, guest: true);
    await tapAndSettle(tester, key('nav-profile'));
    await tapAndSettle(tester, key('profile-sign-in'));
    await tapAndSettle(tester, key('social-apple'));
    expect(find.text('Jordan Ellis'), findsOneWidget);
    expect(find.text('Demo profile · Apple sign-in simulated'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
  });

  testWidgets('guest deep links to Add/Edit are blocked', (tester) async {
    await pumpApp(tester, guest: true);
    for (final path in [
      '/inventory/add',
      '/inventory/medicine/sample-brevora/edit',
    ]) {
      await routerOf(tester).navigatePath(path);
      await tester.pumpAndSettle(frame60Hz);
      expect(find.byType(MedicineFormScreen), findsNothing, reason: path);
    }
    // Viewing a medicine by link is fine.
    await routerOf(tester).navigatePath('/inventory/medicine/sample-brevora');
    await tester.pumpAndSettle(frame60Hz);
    expect(find.byType(MedicineDetailScreen), findsOneWidget);
  });
}
