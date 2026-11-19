import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Unobtrusive reminder that the app runs on sample, session-only data.
class PrototypeNotice extends StatelessWidget {
  const PrototypeNotice({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(
              Icons.science_outlined,
              size: 20,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: context.text.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
