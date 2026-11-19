import 'package:material_ui/material_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../session/session_controller.dart';

/// Full-width "Continue with Google/Apple" button. In this prototype these
/// are simulated entry points only: no OAuth, no credentials.
class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    super.key,
    required this.method,
    required this.onPressed,
  }) : assert(method != SignInMethod.guest);

  final SignInMethod method;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.secondary(
      key: ValueKey('social-${method.name}'),
      label: context.l10n.continueWithProvider(method.brandName!),
      icon: _ProviderMark(method),
      expand: true,
      onPressed: onPressed,
    );
  }
}

class _ProviderMark extends StatelessWidget {
  const _ProviderMark(this.method);

  final SignInMethod method;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: switch (method) {
        SignInMethod.apple => Icon(
          Icons.apple,
          size: 22,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        // Placeholder: swap for Google's official multicolor "G" asset
        // (required by Google's sign-in branding guidelines) if real
        // Google Sign-In is ever added.
        // l10n-ignore: placeholder brand glyph, not translatable text.
        _ => const Text(
          'G',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.googleBlue,
            height: 1,
          ),
        ),
      },
    );
  }
}
