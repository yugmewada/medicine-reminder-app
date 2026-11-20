import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../session/session_controller.dart';

/// The single gate for guest-restricted actions (add, edit, delete
/// medicines). Runs [action] when the user may manage medicines; otherwise
/// shows the sign-in alert ([showSignInRequired]) instead.
Future<void> runIfCanManageMedicines(
  BuildContext context,
  WidgetRef ref,
  VoidCallback action,
) async {
  if (ref.read(sessionProvider).canManageMedicines) {
    action();
    return;
  }
  await showSignInRequired(context, ref);
}

/// Alert (same style as the logout confirmation) telling a guest that this
/// needs sign-in. "Sign in" returns to Welcome to pick Google/Apple.
Future<void> showSignInRequired(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final signIn = await AppDialogs.confirm(
    context,
    icon: Icons.lock_outline_rounded,
    title: l10n.signInPromptTitle,
    message: l10n.signInPromptMessage,
    confirmLabel: l10n.signIn,
  );
  if (signIn && context.mounted) {
    ref.read(sessionProvider.notifier).requestSignIn();
  }
}
