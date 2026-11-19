import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../session/session_controller.dart';
import 'widgets/social_sign_in_button.dart';

/// Entry. Google and Apple are simulated sign-ins: tapping one explains
/// that, then enters with a fictional profile and full access. "Continue as
/// guest" enters with guest restrictions (no adding/editing/deleting
/// medicines). Nothing is authenticated.
@RoutePage()
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionProvider.notifier);
    final l10n = context.l10n;

    Future<void> simulated(SignInMethod method) async {
      final proceed = await AppDialogs.confirm(
        context,
        icon: Icons.science_outlined,
        title: l10n.demoSignInTitle,
        message: l10n.demoSignInMessage(method.brandName!),
        confirmLabel: l10n.demoSignInConfirm,
      );
      if (proceed) session.signIn(method);
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final artHeight = (constraints.maxHeight * 0.34).clamp(
              150.0,
              300.0,
            );
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.page,
                vertical: AppSpacing.xl,
              ),
              child: ContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const BrandLogo(size: 32),
                        const SizedBox(width: AppSpacing.sm),
                        Text(l10n.appTitle, style: context.text.titleLarge),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      height: artHeight,
                      child: const FeatureArt(kind: FeatureArtKind.welcome),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.welcomeTitle,
                        textAlign: TextAlign.center,
                        style: context.text.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.welcomeSubtitle,
                      textAlign: TextAlign.center,
                      style: context.text.bodyLarge?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    SocialSignInButton(
                      method: SignInMethod.google,
                      onPressed: () => simulated(SignInMethod.google),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SocialSignInButton(
                      method: SignInMethod.apple,
                      onPressed: () => simulated(SignInMethod.apple),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _OrDivider(),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      key: const ValueKey('continue-guest'),
                      label: l10n.continueAsGuest,
                      expand: true,
                      onPressed: () => session.signIn(SignInMethod.guest),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.guestLimitsNote,
                      textAlign: TextAlign.center,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
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
          },
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            context.l10n.welcomeOr,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
