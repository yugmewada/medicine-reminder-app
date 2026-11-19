import '../../features/session/session_controller.dart';

/// URL paths, for deep links and tests. In app code navigate with the
/// generated typed routes (`context.router.push(MedicineDetailRoute(...))`).
abstract final class AppPaths {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const welcome = '/welcome';
  static const today = '/today';
  static const inventory = '/inventory';
  static const addMedicine = '/inventory/add';
  static const profile = '/profile';

  static String medicine(String id) =>
      '/inventory/medicine/${Uri.encodeComponent(id)}';
  static String editMedicine(String id) => '${medicine(id)}/edit';

  static const preAuth = {splash, onboarding, welcome};
}

/// Names of the pre-sign-in routes (as generated from the screen classes).
abstract final class PreAuthRoutes {
  static const splash = 'SplashRoute';
  static const onboarding = 'OnboardingRoute';
  static const welcome = 'WelcomeRoute';
  static const notFound = 'NotFoundRoute';

  static const all = {splash, onboarding, welcome};
}

/// Routes that change medicines. Guests cannot open them, even by deep link.
abstract final class MemberOnlyRoutes {
  static const all = {'AddMedicineRoute', 'EditMedicineRoute'};
}

/// Pure navigation rules, unit-tested in test/app/navigation_policy_test.dart.
abstract final class NavigationPolicy {
  /// The screen a signed-out [stage] must show.
  static String routeNameFor(AppStage stage) => switch (stage) {
    AppStage.splash => PreAuthRoutes.splash,
    AppStage.onboarding => PreAuthRoutes.onboarding,
    AppStage.welcome => PreAuthRoutes.welcome,
    AppStage.signedIn => 'HomeShellRoute',
  };

  static String pathFor(AppStage stage) => switch (stage) {
    AppStage.splash => AppPaths.splash,
    AppStage.onboarding => AppPaths.onboarding,
    AppStage.welcome => AppPaths.welcome,
    AppStage.signedIn => AppPaths.today,
  };

  /// Whether navigation to [routeName] may proceed for [session]:
  /// - signed out: only the current stage's screen (and Not found);
  /// - signed in: every app route except the pre-auth screens, and for a
  ///   guest also except [MemberOnlyRoutes].
  static bool allows(SessionState session, String routeName) {
    if (routeName == PreAuthRoutes.notFound) return true;
    if (session.stage != AppStage.signedIn) {
      return routeName == routeNameFor(session.stage);
    }
    if (PreAuthRoutes.all.contains(routeName)) return false;
    return session.canManageMedicines ||
        !MemberOnlyRoutes.all.contains(routeName);
  }

  /// True when [routeName] is blocked only because the user is a guest
  /// (stay where you are instead of resetting to the stage screen).
  static bool isGuestRestricted(SessionState session, String routeName) =>
      session.isGuest && MemberOnlyRoutes.all.contains(routeName);

  /// Decides where an incoming platform deep link goes: the location to
  /// open now, and (when signed out) a safe in-app location to open after
  /// sign-in. Logout never passes through here, so the screen left by
  /// logging out is never reopened.
  static ({String open, String? remember}) resolveDeepLink(
    SessionState session,
    String location,
  ) {
    final path = Uri.tryParse(location)?.path ?? '';
    if (session.stage == AppStage.signedIn) {
      final usable =
          path.isNotEmpty && path != '/' && !AppPaths.preAuth.contains(path);
      return (open: usable ? location : AppPaths.today, remember: null);
    }
    return (
      open: pathFor(session.stage),
      remember: isSafeInAppLocation(location) ? location : null,
    );
  }

  /// Only relative, in-app, post-sign-in paths may be reopened after
  /// sign-in. Rejects external URLs, protocol-relative paths and loops.
  static bool isSafeInAppLocation(String? location) {
    if (location == null || location.isEmpty) return false;
    if (!location.startsWith('/') || location.startsWith('//')) return false;
    final uri = Uri.tryParse(location);
    if (uri == null || uri.hasScheme || uri.hasAuthority) return false;
    return uri.path != '/' && !AppPaths.preAuth.contains(uri.path);
  }
}
