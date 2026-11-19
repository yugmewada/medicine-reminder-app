import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// The app's standard top bar. Use on every pushed screen and tab.
///
/// Back navigation is automatic when the route can pop. Pass [onBack] to
/// intercept it (for example to confirm discarding a form).
class AppToolbar extends StatelessWidget implements PreferredSizeWidget {
  const AppToolbar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.onBack,
    this.showBack = true,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final VoidCallback? onBack;
  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
    final subtitle = this.subtitle;
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: showBack && canPop ? 0 : AppSpacing.page,
      leading: showBack && canPop
          ? IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBack ?? () => Navigator.maybePop(context),
            )
          : null,
      title: Semantics(
        header: true,
        child: subtitle == null
            ? Text(title, maxLines: 1, overflow: TextOverflow.ellipsis)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        ...actions,
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}
