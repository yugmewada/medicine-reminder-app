import 'package:material_ui/material_ui.dart';

import '../../../../core/formatting/app_formats.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/utils/utils.dart';

/// Horizontally scrollable day picker. The selected day is filled; today is
/// outlined with a dot, so neither state relies on color alone.
class DateStrip extends StatefulWidget {
  const DateStrip({
    super.key,
    required this.days,
    required this.selected,
    required this.today,
    required this.onSelected,
  });

  final List<DateTime> days;
  final DateTime selected;
  final DateTime today;
  final ValueChanged<DateTime> onSelected;

  @override
  State<DateStrip> createState() => _DateStripState();
}

class _DateStripState extends State<DateStrip> {
  final _controller = ScrollController();
  final _keys = <String, GlobalKey>{};

  GlobalKey _keyFor(DateTime day) =>
      _keys.putIfAbsent(DayUtils.key(day), GlobalKey.new);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _reveal(animate: false),
    );
  }

  @override
  void didUpdateWidget(DateStrip old) {
    super.didUpdateWidget(old);
    if (!DayUtils.isSameDay(old.selected, widget.selected)) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _reveal(animate: true),
      );
    }
  }

  void _reveal({required bool animate}) {
    final context = _keyFor(widget.selected).currentContext;
    if (context == null || !mounted) return;
    Scrollable.ensureVisible(
      context,
      alignment: 0.5,
      duration: animate
          ? AppMotion.of(this.context, AppMotion.medium)
          : Duration.zero,
      curve: AppMotion.enter,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A Row inside a scroll view sizes to its tallest child, so the strip
    // grows with the text size instead of clipping.
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final day in widget.days)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
              child: _DayCell(
                key: _keyFor(day),
                day: day,
                selected: DayUtils.isSameDay(day, widget.selected),
                isToday: DayUtils.isSameDay(day, widget.today),
                onTap: () => widget.onSelected(day),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    super.key,
    required this.day,
    required this.selected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime day;
  final bool selected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = selected
        ? colors.onPrimary
        : isToday
        ? colors.primary
        : colors.onSurface;
    final label = isToday
        ? context.l10n.dayCellTodayLabel(day)
        : context.l10n.dayCellLabel(day);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.short),
        curve: AppMotion.enter,
        constraints: const BoxConstraints(minWidth: 56),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected
                ? colors.primary
                : isToday
                ? colors.primary
                : colors.outlineVariant,
            width: isToday && !selected ? 1.5 : 1,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: ValueKey('day-${DayUtils.key(day)}'),
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.md,
              ),
              child: Column(
                children: [
                  Text(
                    AppFormats.weekdayShort(context, day),
                    style: context.text.labelMedium?.copyWith(
                      color: selected
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${day.day}',
                    style: context.text.titleLarge?.copyWith(color: foreground),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Today marker: a dot, visible whether or not selected.
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isToday ? foreground : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
