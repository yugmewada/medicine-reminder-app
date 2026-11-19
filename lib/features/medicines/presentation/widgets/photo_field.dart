import 'package:material_ui/material_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';

/// Optional medicine photo: preview plus choose/change/remove actions.
class PhotoField extends StatelessWidget {
  const PhotoField({
    super.key,
    required this.photo,
    required this.loading,
    required this.onPick,
    required this.onRemove,
  });

  final PickedImage? photo;
  final bool loading;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  static const double _previewSize = 104;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final photo = this.photo;

    final preview = Semantics(
      button: true,
      label: photo == null ? l10n.photoAddLabel : l10n.photoChangeLabel,
      excludeSemantics: true,
      child: Material(
        color: colors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: colors.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: loading ? null : onPick,
          child: SizedBox.square(
            dimension: _previewSize,
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : photo == null
                ? Icon(
                    Icons.add_a_photo_outlined,
                    size: 32,
                    color: colors.onSurfaceVariant,
                  )
                : Image.memory(
                    photo.bytes,
                    fit: BoxFit.cover,
                    cacheWidth: (_previewSize * 3).round(),
                  ),
          ),
        ),
      ),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.photoTitle, style: context.text.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.photoHelp,
          style: context.text.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            AppButton.secondary(
              key: const ValueKey('pick-photo'),
              label: photo == null ? l10n.photoChoose : l10n.photoChange,
              icon: const Icon(Icons.photo_library_outlined),
              compact: true,
              loading: loading,
              onPressed: onPick,
            ),
            if (photo != null)
              AppButton.text(
                key: const ValueKey('remove-photo'),
                label: l10n.photoRemove,
                compact: true,
                onPressed: loading ? null : onRemove,
              ),
          ],
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Stack vertically when the row would leave too little text room.
        final narrow = constraints.maxWidth < 320;
        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              preview,
              const SizedBox(height: AppSpacing.md),
              details,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            preview,
            const SizedBox(width: AppSpacing.lg),
            Expanded(child: details),
          ],
        );
      },
    );
  }
}
