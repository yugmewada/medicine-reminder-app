import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Labelled single-choice group of chips that wraps onto new lines, so it
/// never overflows on small screens or with large text.
class ChoiceGroup<T> extends StatelessWidget {
  const ChoiceGroup({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    this.iconOf,
    this.helper,
    this.errorText,
    this.keyPrefix,
  });

  final String label;
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;
  final Widget Function(T)? iconOf;
  final String? helper;
  final String? errorText;

  /// Chips get `ValueKey('$keyPrefix-$option')` for tests.
  final String? keyPrefix;

  @override
  Widget build(BuildContext context) {
    final helper = this.helper;
    final errorText = this.errorText;
    return Semantics(
      container: true,
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(child: Text(label, style: context.text.titleSmall)),
          if (helper != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              helper,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final option in options)
                ChoiceChip(
                  key: keyPrefix == null
                      ? null
                      : ValueKey('$keyPrefix-${_keyOf(option)}'),
                  label: Text(labelOf(option)),
                  avatar: iconOf?.call(option),
                  selected: option == selected,
                  onSelected: (_) => onSelected(option),
                ),
            ],
          ),
          if (errorText != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              errorText,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _keyOf(Object? option) =>
      option is Enum ? option.name : option.toString();
}
