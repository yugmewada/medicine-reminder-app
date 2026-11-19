import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// Product-specific color roles not covered by Material's [ColorScheme].
@immutable
class BrandColors extends ThemeExtension<BrandColors> {

  /// High-emphasis highlight (e.g. the "Create Account" action).
  final Color accent;
  final Color onAccent;
  /// Secondary text such as section captions.
  final Color mutedInk;

  const BrandColors({
    required this.accent,
    required this.onAccent,
    required this.mutedInk,
  });

  static const light = BrandColors(
    accent: AppColors.brandYellow,
    onAccent: AppColors.ink,
    mutedInk: AppColors.slateInk,
  );

  static const dark = BrandColors(
    accent: AppColors.brandYellow,
    onAccent: AppColors.ink,
    mutedInk: AppColors.slateInkLight,
  );

  static BrandColors of(BuildContext context) =>
      Theme.of(context).extension<BrandColors>() ?? light;

  @override
  BrandColors copyWith({Color? accent, Color? onAccent, Color? mutedInk}) {
    return BrandColors(
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      mutedInk: mutedInk ?? this.mutedInk,
    );
  }

  @override
  BrandColors lerp(BrandColors? other, double t) {
    if (other == null) return this;
    return BrandColors(
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      mutedInk: Color.lerp(mutedInk, other.mutedInk, t)!,
    );
  }
}
