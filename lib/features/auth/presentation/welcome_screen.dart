import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/brand_colors.dart';
import '../../../core/widgets/brand_logo.dart';
import 'widgets/social_sign_in_button.dart';
import 'widgets/welcome_hero.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onCreateAccount,
    required this.onSignIn,
    required this.onSocialSignIn,
    this.heroImage,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onSignIn;
  final ValueChanged<SocialProvider> onSocialSignIn;

  /// Hero photo, e.g. `AssetImage('assets/images/welcome_hero.jpg')`.
  /// A branded placeholder is shown when null.
  final ImageProvider? heroImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Fills the screen on normal sizes; scrolls on short screens or
            // with large text instead of overflowing.
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.xxl),
                      const _Header(),
                      const SizedBox(height: AppSpacing.xl),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                          ),
                          child: WelcomeHero(
                            image: heroImage,
                            child: _AuthActions(
                              onCreateAccount: onCreateAccount,
                              onSignIn: onSignIn,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _SocialSignIn(onSelected: onSocialSignIn),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          const BrandLogo(),
          const SizedBox(height: AppSpacing.xl),
          Semantics(
            header: true,
            child: Text(
              'Welcome!',
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Narrows the subtitle to wrap like the design. Padding (unlike
          // ConstrainedBox) is respected by the IntrinsicHeight pass above.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
            child: Text(
              "Welcome Back! Let's make it better for your style",
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthActions extends StatelessWidget {
  const _AuthActions({required this.onCreateAccount, required this.onSignIn});

  final VoidCallback onCreateAccount;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final brand = BrandColors.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton(
            key: const ValueKey('create-account'),
            onPressed: onCreateAccount,
            style: FilledButton.styleFrom(
              backgroundColor: brand.accent,
              foregroundColor: brand.onAccent,
            ),
            child: const Text('Create Account'),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            key: const ValueKey('sign-in'),
            onPressed: onSignIn,
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}

class _SocialSignIn extends StatelessWidget {
  const _SocialSignIn({required this.onSelected});

  final ValueChanged<SocialProvider> onSelected;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          Text(
            'Continue with social media',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: BrandColors.of(context).mutedInk,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.lg,
            children: [
              SocialSignInButton(
                provider: SocialProvider.facebook,
                onPressed: () => onSelected(SocialProvider.facebook),
              ),
              SocialSignInButton(
                provider: SocialProvider.google,
                onPressed: () => onSelected(SocialProvider.google),
              ),

              if (isIOS)
                SocialSignInButton(
                  provider: SocialProvider.apple,
                  onPressed: () => onSelected(SocialProvider.apple),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
