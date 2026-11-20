import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// One destination in [AppTabBar].
@immutable
class AppTabItem {
  const AppTabItem({
    required this.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  /// Widget key for the tab (tests and analytics-free identification).
  final Key key;

  /// Outlined icon when not selected; [selectedIcon] (filled) when selected,
  /// following the HIG preference for filled symbols on the active tab.
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// The app's bottom navigation: a floating, frosted-glass pill.
///
/// Design (see docs/MASTER_PROMPT.md > Bottom navigation):
/// - Floats above content with side margins and sits above the iOS home
///   indicator / Android gesture bar; content scrolls behind a blur, like the
///   iOS 26 tab bar and Google's floating pill bars.
/// - The selected tab gets a brand-colored capsule that slides between
///   tabs (150 ms, no overshoot); its icon (outlined → filled) and label
///   switch instantly so selection feels immediate. Labels are always
///   visible. Selection never relies on color alone (filled icon, weight,
///   capsule, and `selected` semantics).
/// - Navigation only: no actions in the bar, no haptics for routine tab
///   switches, every tab always enabled.
/// - Labels clamp at 1.3× text scale so the bar never overflows; screen
///   readers still get the full label plus "Tab x of y".
///
/// Used with `Scaffold(extendBody: true)`: the Scaffold then reports the
/// bar's height in `MediaQuery.paddingOf(context).bottom`, which scrolling
/// screens add to their bottom padding (`context.bottomBarInset`).
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  }) : assert(items.length >= 2 && items.length <= 5);

  final List<AppTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Height of the pill's contents (Material 3 Expressive bars are 64dp).
  static const double height = 64;
  static const double _maxWidth = 440;
  static const double _inset = 6;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final systemBottom = MediaQuery.viewPaddingOf(context).bottom;
    // Sit just above the home indicator / gesture bar; keep a margin when
    // there is none (older Android 3-button navigation, landscape).
    final bottomGap = systemBottom > 0 ? systemBottom : AppSpacing.md;
    final radius = BorderRadius.circular(height / 2 + _inset);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        bottomGap,
      ),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxWidth),
          child: DecoratedBox(
            // Soft floating shadow outside the clipped glass.
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    // Translucent enough to read as glass, opaque enough to
                    // keep label contrast (AA) over any content.
                    color: colors.surfaceContainerLowest.withValues(
                      alpha: 0.86,
                    ),
                    borderRadius: radius,
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(_inset),
                    child: SizedBox(
                      height: height,
                      child: MediaQuery.withClampedTextScaling(
                        maxScaleFactor: 1.3,
                        child: _Items(
                          items: items,
                          selectedIndex: selectedIndex,
                          onSelected: onSelected,
                        ),
                      ),
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

class _Items extends StatelessWidget {
  const _Items({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<AppTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final count = items.length;
    // 150 ms, no overshoot: the capsule lands together with the content
    // cross-fade, so selection never looks like it lags behind navigation.
    final duration = AppMotion.of(context, AppMotion.short);
    return Stack(
      children: [
        // Sliding capsule behind the selected tab. AlignmentDirectional
        // keeps it under the right tab in RTL, where the Row is mirrored.
        AnimatedAlign(
          alignment: AlignmentDirectional(
            count == 1 ? 0 : -1 + 2 * selectedIndex / (count - 1),
            0,
          ),
          duration: duration,
          curve: AppMotion.enter,
          child: FractionallySizedBox(
            widthFactor: 1 / count,
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(AppTabBar.height / 2),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            for (var i = 0; i < count; i++)
              Expanded(
                child: _Tab(
                  item: items[i],
                  position: i + 1,
                  count: count,
                  selected: i == selectedIndex,
                  onTap: () => onSelected(i),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.item,
    required this.position,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final AppTabItem item;
  final int position;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = selected ? colors.onPrimary : colors.onSurfaceVariant;

    return Semantics(
      key: item.key,
      container: true,
      button: true,
      selected: selected,
      label: item.label,
      hint: context.l10n.tabPositionHint(position, count),
      // Child semantics are excluded (to read as one tab), so the tap
      // action must be declared here for screen readers to activate it.
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon and label switch instantly (outlined → filled, bold),
              // like the iOS tab bar; only the capsule moves.
              Icon(
                selected ? item.selectedIcon : item.icon,
                color: foreground,
                size: 24,
              ),
              const SizedBox(height: 2),
              DefaultTextStyle(
                style: context.text.labelMedium!.copyWith(
                  color: foreground,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom space that scrolling content needs so its end is not hidden
/// behind the floating [AppTabBar] (0 outside the tab shell).
extension BottomBarInset on BuildContext {
  double get bottomBarInset => MediaQuery.paddingOf(this).bottom;
}
