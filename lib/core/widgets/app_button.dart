import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_tokens.dart';

enum AppButtonVariant {
  /// Filled primary. One per screen section.
  primary,

  /// Filled with the primary container color; for repeated in-list actions.
  tonal,

  /// Outlined; secondary actions.
  secondary,

  /// Text only; tertiary actions such as Cancel or Skip.
  text,
}

/// The app's standard button. Wraps Material buttons so variants, sizing,
/// icon spacing and loading behavior stay consistent.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expand = false,
    this.loading = false,
    this.compact = false,
    this.destructive = false,
  });

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.loading = false,
    this.compact = false,
    this.destructive = false,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.tonal({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.loading = false,
    this.compact = false,
    this.destructive = false,
  }) : variant = AppButtonVariant.tonal;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.loading = false,
    this.compact = false,
    this.destructive = false,
  }) : variant = AppButtonVariant.text;

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? icon;

  /// Fill the available width.
  final bool expand;

  /// Shows a progress indicator and ignores taps.
  final bool loading;

  /// 48dp tall with tighter padding, for in-card actions.
  final bool compact;

  /// Error-colored text/outline for destructive actions (e.g. Delete).
  /// Use with the secondary or text variant.
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final onPressed = loading ? null : this.onPressed;
    final Widget? leading = loading
        ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : icon;
    final child = Text(label, textAlign: TextAlign.center);
    final error = Theme.of(context).colorScheme.error;
    final style = ButtonStyle(
      minimumSize: compact
          ? const WidgetStatePropertyAll(
              Size(AppSizes.minTapTarget, AppSizes.minTapTarget),
            )
          : null,
      padding: compact
          ? const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            )
          : null,
      foregroundColor: destructive ? WidgetStatePropertyAll(error) : null,
      side: destructive && variant == AppButtonVariant.secondary
          ? WidgetStatePropertyAll(BorderSide(color: error))
          : null,
    );

    final button = switch (variant) {
      AppButtonVariant.primary =>
        leading == null
            ? FilledButton(onPressed: onPressed, style: style, child: child)
            : FilledButton.icon(
                onPressed: onPressed,
                style: style,
                icon: leading,
                label: child,
              ),
      AppButtonVariant.tonal =>
        leading == null
            ? FilledButton.tonal(
                onPressed: onPressed,
                style: style,
                child: child,
              )
            : FilledButton.tonalIcon(
                onPressed: onPressed,
                style: style,
                icon: leading,
                label: child,
              ),
      AppButtonVariant.secondary =>
        leading == null
            ? OutlinedButton(onPressed: onPressed, style: style, child: child)
            : OutlinedButton.icon(
                onPressed: onPressed,
                style: style,
                icon: leading,
                label: child,
              ),
      AppButtonVariant.text =>
        leading == null
            ? TextButton(onPressed: onPressed, style: style, child: child)
            : TextButton.icon(
                onPressed: onPressed,
                style: style,
                icon: leading,
                label: child,
              ),
    };

    final semantic = loading
        ? Semantics(
            label: context.l10n.loadingLabel(label),
            excludeSemantics: true,
            button: true,
            child: button,
          )
        : button;
    return expand
        ? SizedBox(width: double.infinity, child: semantic)
        : semantic;
  }
}
