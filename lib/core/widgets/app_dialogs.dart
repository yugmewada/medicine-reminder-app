import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Shared dialog helpers so every dialog has the same structure.
abstract final class AppDialogs {
  /// Informational dialog with a single dismiss action.
  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon,
    String? closeLabel,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: icon == null
            ? null
            : Icon(icon, color: context.colors.primary, size: 32),
        title: Text(title, textAlign: TextAlign.center),
        content: SingleChildScrollView(child: Text(message)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(closeLabel ?? context.l10n.actionClose),
          ),
        ],
      ),
    );
  }

  /// Confirmation dialog. Resolves to true only when the user confirms.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    IconData? icon,
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colors = context.colors;
        return AlertDialog(
          icon: icon == null
              ? null
              : Icon(
                  icon,
                  color: destructive ? colors.error : colors.primary,
                  size: 32,
                ),
          title: Text(title, textAlign: TextAlign.center),
          content: SingleChildScrollView(child: Text(message)),
          actionsPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelLabel ?? context.l10n.actionCancel),
            ),
            TextButton(
              style: destructive
                  ? TextButton.styleFrom(foregroundColor: colors.error)
                  : null,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
