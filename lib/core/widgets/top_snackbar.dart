import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../motion/frame_clamped_ticker.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

enum SnackTone { info, success, warning, error }

/// App-wide feedback banner that slides in from the top.
///
/// - Only one is visible at a time; showing a new one replaces the old one.
/// - Dismiss by the close button, by swiping it up, or let it time out.
/// - Optional single action (for example "Undo").
/// - Reduced motion: appears and leaves without sliding.
///
/// Use this instead of `ScaffoldMessenger.showSnackBar` everywhere.
abstract final class TopSnackbar {
  static _TopSnackbarViewState? _active;

  static void show(
    BuildContext context, {
    required String message,
    SnackTone tone = SnackTone.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    assert((actionLabel == null) == (onAction == null));
    final overlay = Overlay.of(context, rootOverlay: true);
    _active?._removeNow();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _TopSnackbarView(
        message: message,
        tone: tone,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
        onRemove: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );
    overlay.insert(entry);
  }

  /// Animates the visible snackbar out, if any.
  static void dismiss() => _active?._dismiss();
}

class _TopSnackbarView extends StatefulWidget {
  const _TopSnackbarView({
    required this.message,
    required this.tone,
    required this.duration,
    required this.onRemove,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final SnackTone tone;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onRemove;

  @override
  State<_TopSnackbarView> createState() => _TopSnackbarViewState();
}

class _TopSnackbarViewState extends State<_TopSnackbarView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: FrameClampedTickerProvider(this),
    duration: AppMotion.medium,
    reverseDuration: AppMotion.short,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.enter,
    reverseCurve: AppMotion.exit,
  );
  Timer? _timer;
  bool _removed = false;

  @override
  void initState() {
    super.initState();
    TopSnackbar._active = this;
    _timer = Timer(widget.duration, _dismiss);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.isDismissed) {
      AppMotion.reduced(context)
          ? _controller.value = 1
          : _controller.forward();
    }
  }

  Future<void> _dismiss() async {
    _timer?.cancel();
    if (_removed || !mounted) return;
    if (!AppMotion.reduced(context)) await _controller.reverse();
    _removeNow();
  }

  void _removeNow() {
    if (_removed) return;
    _removed = true;
    _timer?.cancel();
    if (TopSnackbar._active == this) TopSnackbar._active = null;
    widget.onRemove();
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (TopSnackbar._active == this) TopSnackbar._active = null;
    _controller.dispose();
    super.dispose();
  }

  (IconData, Color) _toneStyle(BuildContext context) => switch (widget.tone) {
    SnackTone.info => (Icons.info_outline_rounded, context.colors.primary),
    SnackTone.success => (
      Icons.check_circle_outline_rounded,
      context.status.success,
    ),
    SnackTone.warning => (Icons.error_outline_rounded, context.status.warning),
    SnackTone.error => (
      Icons.report_gmailerrorred_rounded,
      context.colors.error,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (icon, accent) = _toneStyle(context);
    final actionLabel = widget.actionLabel;

    final card = Material(
      color: colors.surfaceContainerLowest,
      elevation: 6,
      shadowColor: colors.shadow.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: AppSpacing.lg,
          top: AppSpacing.xs,
          bottom: AppSpacing.xs,
          end: AppSpacing.xs,
        ),
        child: Row(
          children: [
            Icon(icon, color: accent),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text(widget.message, style: context.text.bodyMedium),
              ),
            ),
            if (actionLabel != null)
              TextButton(
                onPressed: () {
                  widget.onAction?.call();
                  _dismiss();
                },
                child: Text(actionLabel),
              ),
            IconButton(
              tooltip: context.l10n.actionDismiss,
              onPressed: _dismiss,
              icon: const Icon(Icons.close_rounded),
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                0,
              ),
              child: FadeTransition(
                opacity: _curve,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                  ).animate(_curve),
                  child: Dismissible(
                    key: ObjectKey(this),
                    direction: DismissDirection.up,
                    onDismissed: (_) => _removeNow(),
                    child: Semantics(
                      container: true,
                      liveRegion: true,
                      child: card,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
