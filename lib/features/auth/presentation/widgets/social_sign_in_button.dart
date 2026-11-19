import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';

enum SocialProvider {
  facebook('Facebook'),
  google('Google'),
  apple('Apple');

  const SocialProvider(this.label);

  final String label;
}

/// Circular "Continue with [provider]" button.
class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    super.key,
    required this.provider,
    required this.onPressed,
  });

  final SocialProvider provider;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: 'Continue with ${provider.label}',
      excludeSemantics: true,
      child: Material(
        // White on light; a raised tone on dark so the circle stays visible.
        color: scheme.brightness == Brightness.light
            ? scheme.surfaceContainerLowest
            : scheme.surfaceContainerHighest,
        shape: const CircleBorder(),
        elevation: 3,
        shadowColor: scheme.shadow.withValues(alpha: 0.35),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('social-${provider.name}'),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: AppSizes.socialButton,
            child: Center(child: _ProviderMark(provider)),
          ),
        ),
      ),
    );
  }
}

class _ProviderMark extends StatelessWidget {
  const _ProviderMark(this.provider);

  final SocialProvider provider;

  @override
  Widget build(BuildContext context) {
    return switch (provider) {
      SocialProvider.facebook => const Icon(
        Icons.facebook,
        size: AppSizes.socialIcon,
        color: AppColors.facebookBlue,
      ),
      SocialProvider.apple => Icon(
        Icons.apple,
        size: AppSizes.socialIcon,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      // Placeholder: swap for Google's official multicolor "G" asset
      // (required by Google's sign-in branding guidelines).
      SocialProvider.google => const Text(
        'G',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.googleBlue,
          height: 1,
        ),
      ),
    };
  }
}
