import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/router/app_router.gr.dart';
import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';

/// Safe destination for unknown or malformed links.
@RoutePage()
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppToolbar(title: l10n.notFoundTitle, showBack: false),
      body: Center(
        child: SingleChildScrollView(
          child: EmptyState(
            icon: Icons.link_off_rounded,
            title: l10n.notFoundTitle,
            message: l10n.notFoundMessage,
            action: AppButton(
              key: const ValueKey('go-today'),
              label: l10n.goToToday,
              onPressed: () => context.router.replaceAll([
                const HomeShellRoute(children: [TodayRoute()]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
