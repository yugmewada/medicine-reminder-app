import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../core/l10n/l10n.dart';
import '../core/theme/app_theme.dart';
import 'router/app_router.dart';
import '../features/session/session_controller.dart';

/// App root. Must sit inside a [ProviderScope] (see [DosezaApp]; tests pass
/// their own scope with overrides).
class App extends ConsumerWidget {
  const App({super.key, this.builder});

  /// Wraps the routed content. Tests use it to force RTL layout, since no
  /// RTL locale ships yet.
  @visibleForTesting
  final TransitionBuilder? builder;

  /// App strings plus Material/Cupertino/Widgets strings from material_ui.
  /// Do not use `AppLocalizations.localizationsDelegates`: the generated
  /// list points at the deprecated flutter_localizations Material delegates.
  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    // Session stage drives the top-level screen (flow, home, logout).
    ref.listen(sessionProvider, (previous, next) {
      if (previous?.stage != next.stage) router.syncToSession(next);
    });
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      // Light only: the OS dark-mode setting is intentionally ignored.
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // config() is cached by auto_route, so rebuilding is safe.
      routerConfig: router.config(deepLinkBuilder: router.deepLinkBuilder),
      builder: builder,
    );
  }
}

/// [App] inside its own [ProviderScope]. Used by `main()`.
class DosezaApp extends StatelessWidget {
  const DosezaApp({super.key});

  @override
  Widget build(BuildContext context) => const ProviderScope(child: App());
}
