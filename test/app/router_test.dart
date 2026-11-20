import 'package:demo_project/app/router/navigation_policy.dart';
import 'package:demo_project/core/widgets/widgets.dart';
import 'package:demo_project/features/medicines/presentation/medicine_detail_screen.dart';
import 'package:demo_project/features/shell/not_found_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('deep link to a medicine opens its detail', (tester) async {
    await pumpApp(tester);
    await routerOf(tester).navigatePath(AppPaths.medicine('sample-ceralin'));
    await tester.pumpAndSettle();
    expect(find.byType(MedicineDetailScreen), findsOneWidget);
    expect(find.text('Ceralin'), findsWidgets);
    // Detail lives in the Inventory tab, so the tab bar stays visible.
    expect(find.byType(AppTabBar), findsOneWidget);
  });

  testWidgets('a malformed medicine id shows a recoverable state', (
    tester,
  ) async {
    await pumpApp(tester);
    await routerOf(tester).navigatePath(AppPaths.medicine('does-not-exist'));
    await tester.pumpAndSettle();
    expect(find.text('Medicine not found'), findsOneWidget);
    await tapAndSettle(tester, find.byKey(const ValueKey('back-to-inventory')));
    expect(find.text('Inventory'), findsWidgets);
  });

  testWidgets('editing a missing medicine shows not found', (tester) async {
    await pumpApp(tester);
    await routerOf(tester).navigatePath(AppPaths.editMedicine('nope'));
    await tester.pumpAndSettle();
    expect(find.text('Medicine not found'), findsOneWidget);
  });

  testWidgets('an unknown link shows the not-found screen', (tester) async {
    await pumpApp(tester);
    await routerOf(tester).navigatePath('/no/such/page');
    await tester.pumpAndSettle();
    expect(find.byType(NotFoundScreen), findsOneWidget);
    await tapAndSettle(tester, find.byKey(const ValueKey('go-today')));
    expect(find.text('Good morning, Jordan'), findsOneWidget);
  });

  testWidgets('cold-start deep link opens after demo sign-in', (tester) async {
    await pumpApp(
      tester,
      signedIn: false,
      launchLocation: AppPaths.medicine('sample-omnivy'),
    );
    // Still in the signed-out flow.
    expect(find.byType(BrandLogo), findsOneWidget);
    await tester.tap(find.byType(BrandLogo));
    await tester.pumpAndSettle();
    await tapAndSettle(tester, find.byKey(const ValueKey('onboarding-skip')));
    await tapAndSettle(tester, find.byKey(const ValueKey('social-google')));
    await tapAndSettle(tester, find.text('Continue to demo'));
    expect(find.byType(MedicineDetailScreen), findsOneWidget);
    expect(find.text('Omnivy'), findsWidgets);
  });

  testWidgets('system back on another tab returns to Today first', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-profile')));
    expect(find.text('Jordan Ellis'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Good morning, Jordan'), findsOneWidget);
  });

  testWidgets('back from detail returns to the list in the same tab', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-inventory')));
    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('medicine-sample-brevora')),
    );
    expect(find.byType(MedicineDetailScreen), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(MedicineDetailScreen), findsNothing);
    expect(find.text('5 medicines'), findsOneWidget);
  });

  testWidgets('tabs keep their stack; reselecting a tab pops to its root', (
    tester,
  ) async {
    await pumpApp(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-inventory')));
    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('medicine-sample-brevora')),
    );
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-today')));
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-inventory')));
    // Stack preserved across tab switches.
    expect(find.byType(MedicineDetailScreen), findsOneWidget);
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-inventory')));
    expect(find.byType(MedicineDetailScreen), findsNothing);
  });

  testWidgets('deep link while signed out is held back by the guard', (
    tester,
  ) async {
    await pumpApp(tester, signedIn: false);
    await routerOf(tester).navigatePath(AppPaths.profile);
    await tester.pumpAndSettle();
    expect(find.text('Jordan Ellis'), findsNothing);
    expect(find.byType(BrandLogo), findsOneWidget); // still on splash
  });

  testWidgets('signed in: pre-auth screens are not reachable', (tester) async {
    await pumpApp(tester);
    await routerOf(tester).navigatePath(AppPaths.welcome);
    await tester.pumpAndSettle();
    expect(find.text('Welcome!'), findsNothing);
    expect(find.text('Good morning, Jordan'), findsOneWidget);
  });

  testWidgets('the add form opens above the tab bar', (tester) async {
    await pumpApp(tester);
    await tapAndSettle(tester, find.byKey(const ValueKey('nav-inventory')));
    await tapAndSettle(tester, find.byKey(const ValueKey('add-medicine')));
    expect(find.byKey(const ValueKey('save-medicine')), findsOneWidget);
    expect(find.byType(AppTabBar).hitTestable(), findsNothing);
  });
}
