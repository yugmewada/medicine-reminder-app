import 'package:material_ui/material_ui.dart';

/// Spacing scale in logical pixels.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Horizontal gutter for screen content.
  static const double page = 20;
}

/// Corner-radius scale in logical pixels.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 28;
}

/// Component sizes shared across screens.
abstract final class AppSizes {
  static const double buttonHeight = 52;
  static const double minTapTarget = 48;
  static const double logo = 44;
  static const double iconBadge = 44;
  static const double avatar = 88;

  /// Widest content column before it is centered (tablets, landscape).
  static const double maxContentWidth = 560;
}

/// Motion tokens. Always read durations through [AppMotion.of] so reduced
/// motion settings are respected.
abstract final class AppMotion {
  static const Duration short = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// Screen-to-screen transitions (fade-through).
  static const Duration page = Duration(milliseconds: 300);

  /// Returns [Duration.zero] when the platform asks for reduced motion.
  /// Use for decorative and micro-interaction motion.
  static Duration of(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;

  /// Screen transitions never become instant (that reads as broken): under
  /// reduced motion they shorten to a brief dissolve with no movement.
  static Duration pageOf(BuildContext context) =>
      reduced(context) ? short : page;

  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;
}
