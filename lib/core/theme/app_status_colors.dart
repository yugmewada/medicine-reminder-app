import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// Semantic status roles that Material's [ColorScheme] does not cover.
///
/// Status is never shown by color alone: pair these with an icon and label
/// (see `StatusChip`).
@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
  });

  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;

  static const light = AppStatusColors(
    success: AppColors.success,
    successContainer: AppColors.successContainer,
    onSuccessContainer: AppColors.onSuccessContainer,
    warning: AppColors.warning,
    warningContainer: AppColors.warningContainer,
    onWarningContainer: AppColors.onWarningContainer,
  );

  static AppStatusColors of(BuildContext context) =>
      Theme.of(context).extension<AppStatusColors>() ?? light;

  @override
  AppStatusColors copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
  }) {
    return AppStatusColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
    );
  }

  @override
  AppStatusColors lerp(AppStatusColors? other, double t) {
    if (other == null) return this;
    return AppStatusColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
    );
  }
}
