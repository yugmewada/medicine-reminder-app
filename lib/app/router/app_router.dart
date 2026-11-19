import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation/app_transitions.dart';
import '../../features/session/session_controller.dart';
import 'app_router.gr.dart';
import 'navigation_policy.dart';

/// The app's router (auto_route).
///
/// Typed routes (`TodayRoute()`, `MedicineDetailRoute(medicineId: id)`, …)
/// are generated into `app_router.gr.dart` from screens annotated with
/// `@RoutePage()`. Regenerate with `dart run build_runner build`.
///
/// Session handling:
/// - [SessionGuard] lets a navigation through only when [NavigationPolicy]
///   allows it for the current stage; otherwise it shows that stage's screen.
/// - [syncToSession] moves to the right screen when the stage changes
///   (splash → onboarding → welcome → home, and logout).
/// - [deepLinkBuilder] routes platform deep links. A link that arrives while
///   signed out is opened after sign-in.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({required this.readSession});

  /// Reads the current session (from Riverpod) without listening.
  final SessionState Function() readSession;

  /// Safe in-app location to open after the next sign-in.
  String? _pendingLocation;

  /// Every screen uses the same transition: platform push with a
  /// jank-tolerant clock (see `AppPageRoute`). Tabs animate separately.
  @override
  RouteType get defaultRouteType =>
      RouteType.custom(customRouteBuilder: AppTransitions.pushRoute);

  @override
  List<AutoRouteGuard> get guards => [SessionGuard(readSession)];

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, path: AppPaths.splash),
    AutoRoute(page: OnboardingRoute.page, path: AppPaths.onboarding),
    AutoRoute(page: WelcomeRoute.page, path: AppPaths.welcome),
    // Forms open on the root navigator, above the tab bar. Listed before
    // the shell so their paths match first.
    AutoRoute(
      page: AddMedicineRoute.page,
      path: AppPaths.addMedicine,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: EditMedicineRoute.page,
      path: '/inventory/medicine/:medicineId/edit',
    ),
    AutoRoute(
      page: HomeShellRoute.page,
      path: '/',
      children: [
        AutoRoute(page: TodayRoute.page, path: 'today', initial: true),
        AutoRoute(
          page: InventoryTabRoute.page,
          path: 'inventory',
          children: [
            AutoRoute(page: InventoryRoute.page, path: '', initial: true),
            AutoRoute(
              page: MedicineDetailRoute.page,
              path: 'medicine/:medicineId',
            ),
          ],
        ),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
      ],
    ),
    AutoRoute(page: NotFoundRoute.page, path: '*'),
  ];

  /// Routes platform deep links, including the launch location.
  FutureOr<DeepLink> deepLinkBuilder(PlatformDeepLink link) {
    final decision = NavigationPolicy.resolveDeepLink(
      readSession(),
      link.uri.toString(),
    );
    if (decision.remember != null) _pendingLocation = decision.remember;
    return DeepLink.path(decision.open);
  }

  /// Shows the screen for [session]'s stage. Call on every stage change.
  Future<void> syncToSession(SessionState session) async {
    switch (session.stage) {
      case AppStage.splash:
        await replaceAll([const SplashRoute()]);
      case AppStage.onboarding:
        await replaceAll([const OnboardingRoute()]);
      case AppStage.welcome:
        await replaceAll([const WelcomeRoute()]);
      case AppStage.signedIn:
        final pending = _pendingLocation;
        _pendingLocation = null;
        await replaceAll([const HomeShellRoute()]);
        if (pending != null) await navigatePath(pending);
    }
  }
}

/// Global guard: enforces [NavigationPolicy] for every navigation.
class SessionGuard extends AutoRouteGuard {
  SessionGuard(this.readSession);

  final SessionState Function() readSession;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final session = readSession();
    final name = resolver.route.name;
    if (NavigationPolicy.allows(session, name)) {
      resolver.next();
      return;
    }
    resolver.next(false);
    // A guest opening a member-only screen (e.g. by deep link) just stays
    // where they are; the UI offers sign-in for those actions.
    if (NavigationPolicy.isGuestRestricted(session, name)) return;
    // Wrong screen for the session (e.g. an app route while signed out):
    // show the screen the session is actually on.
    final root = router.root;
    if (root is AppRouter) root.syncToSession(session);
  }
}

final appRouterProvider = Provider<AppRouter>(
  (ref) => AppRouter(readSession: () => ref.read(sessionProvider)),
);
