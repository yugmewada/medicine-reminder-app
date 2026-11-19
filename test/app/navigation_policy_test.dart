import 'package:demo_project/app/router/navigation_policy.dart';
import 'package:demo_project/features/session/session_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const splash = SessionState(stage: AppStage.splash);
  const welcome = SessionState(stage: AppStage.welcome);
  const signedIn = SessionState(
    stage: AppStage.signedIn,
    method: SignInMethod.google,
  );
  const guest = SessionState(
    stage: AppStage.signedIn,
    method: SignInMethod.guest,
  );

  group('allows', () {
    test('signed out: only the current stage screen and Not found', () {
      expect(NavigationPolicy.allows(splash, 'SplashRoute'), isTrue);
      expect(NavigationPolicy.allows(splash, 'OnboardingRoute'), isFalse);
      expect(NavigationPolicy.allows(welcome, 'WelcomeRoute'), isTrue);
      expect(NavigationPolicy.allows(welcome, 'TodayRoute'), isFalse);
      expect(NavigationPolicy.allows(welcome, 'HomeShellRoute'), isFalse);
      expect(NavigationPolicy.allows(welcome, 'NotFoundRoute'), isTrue);
    });

    test('signed in: app routes yes, pre-auth screens no', () {
      for (final name in [
        'HomeShellRoute',
        'TodayRoute',
        'MedicineDetailRoute',
        'AddMedicineRoute',
        'NotFoundRoute',
      ]) {
        expect(NavigationPolicy.allows(signedIn, name), isTrue);
      }
      for (final name in PreAuthRoutes.all) {
        expect(NavigationPolicy.allows(signedIn, name), isFalse);
      }
    });
  });

  test('guests cannot open member-only routes; everything else is open', () {
    for (final name in MemberOnlyRoutes.all) {
      expect(NavigationPolicy.allows(guest, name), isFalse, reason: name);
      expect(NavigationPolicy.isGuestRestricted(guest, name), isTrue);
      expect(NavigationPolicy.allows(signedIn, name), isTrue, reason: name);
      expect(NavigationPolicy.isGuestRestricted(signedIn, name), isFalse);
    }
    for (final name in [
      'HomeShellRoute',
      'TodayRoute',
      'InventoryRoute',
      'MedicineDetailRoute',
      'ProfileRoute',
    ]) {
      expect(NavigationPolicy.allows(guest, name), isTrue, reason: name);
    }
  });

  group('resolveDeepLink', () {
    test('signed out: open the stage screen, remember an in-app link', () {
      final d = NavigationPolicy.resolveDeepLink(
        splash,
        '/inventory/medicine/abc',
      );
      expect(d.open, '/splash');
      expect(d.remember, '/inventory/medicine/abc');
    });

    test('signed out: the launch location "/" is not remembered', () {
      final d = NavigationPolicy.resolveDeepLink(welcome, '/');
      expect(d.open, '/welcome');
      expect(d.remember, isNull);
    });

    test('signed in: in-app links open; pre-auth or root go to Today', () {
      expect(
        NavigationPolicy.resolveDeepLink(signedIn, '/profile').open,
        '/profile',
      );
      expect(NavigationPolicy.resolveDeepLink(signedIn, '/').open, '/today');
      expect(
        NavigationPolicy.resolveDeepLink(signedIn, '/welcome').open,
        '/today',
      );
    });

    test('unsafe links are never remembered', () {
      for (final link in [
        'https://evil.example',
        '//evil.example',
        'today',
        '/welcome',
        '/',
        '',
      ]) {
        expect(
          NavigationPolicy.resolveDeepLink(splash, link).remember,
          isNull,
          reason: link,
        );
      }
    });
  });

  test('paths encode ids', () {
    expect(AppPaths.medicine('a b'), '/inventory/medicine/a%20b');
    expect(AppPaths.editMedicine('x'), '/inventory/medicine/x/edit');
  });
}
