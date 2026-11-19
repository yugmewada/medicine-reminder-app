import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../session/session_controller.dart';
import 'widgets/social_sign_in_button.dart';

/// The single gate for guest-restricted actions (add, edit, delete
/// medicines). Runs [action] when the user may manage medicines; otherwise
/// asks a guest to sign in first and, if they do, continues with [action].
Future<void> runIfCanManageMedicines(
  BuildContext context,
  WidgetRef ref,
  VoidCallback action,
) async {
  if (ref.read(sessionProvider).canManageMedicines) {
    action();
    return;
  }
  final signedIn = await showSignInPrompt(context, ref);
  if (signedIn && context.mounted) action();
}

/// Bottom sheet offering a guest the (simulated) Google/Apple sign-in.
/// Keeps all session data. Returns true when the guest signed in.
Future<bool> showSignInPrompt(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final method = await showModalBottomSheet<SignInMethod>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const _SignInSheet(),
  );
  if (method == null || !context.mounted) return false;
  ref.read(sessionProvider.notifier).upgradeGuest(method);
  TopSnackbar.show(
    context,
    message: l10n.signedInUpgrade(method.brandName!),
    tone: SnackTone.success,
  );
  return true;
}

class _SignInSheet extends StatelessWidget {
  const _SignInSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void choose(SignInMethod method) => Navigator.of(context).pop(method);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: ContentWidth(
        child: Column(
          key: const ValueKey('sign-in-prompt'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: IconBadge(icon: Icons.lock_outline_rounded)),
            const SizedBox(height: AppSpacing.lg),
            Semantics(
              header: true,
              child: Text(
                l10n.signInPromptTitle,
                textAlign: TextAlign.center,
                style: context.text.titleLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.signInPromptMessage,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SocialSignInButton(
              method: SignInMethod.google,
              onPressed: () => choose(SignInMethod.google),
            ),
            const SizedBox(height: AppSpacing.md),
            SocialSignInButton(
              method: SignInMethod.apple,
              onPressed: () => choose(SignInMethod.apple),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton.text(
              key: const ValueKey('sign-in-not-now'),
              label: l10n.notNow,
              expand: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.welcomeSimulatedNote,
              textAlign: TextAlign.center,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
