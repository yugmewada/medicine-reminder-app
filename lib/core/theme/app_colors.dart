import 'package:material_ui/material_ui.dart';

/// Raw palette (light only; the app has no dark mode). Only the theme
/// files read these.
///
/// Widgets must use `Theme.of(context).colorScheme` or [AppStatusColors]
/// (via `context.status`) instead. Contrast ratios are documented in
/// docs/MASTER_PROMPT.md and all text pairs meet WCAG AA.
abstract final class AppColors {
  static const Color brandBlue = Color(0xFF3350CB);
  static const Color brandBlueContainer = Color(0xFFE7EBFC);
  static const Color onBrandBlueContainer = Color(0xFF1B2A78);
  static const Color page = Color(0xFFF6F7FB);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardHigh = Color(0xFFEEF0F6);
  static const Color cardHighest = Color(0xFFE5E8F0);
  static const Color ink = Color(0xFF1B2030);
  static const Color inkMuted = Color(0xFF596178);
  static const Color outline = Color(0xFF8A91A5);
  static const Color outlineSoft = Color(0xFFE1E4EC);

  static const Color success = Color(0xFF1D7A4C);
  static const Color successContainer = Color(0xFFE2F3E9);
  static const Color onSuccessContainer = Color(0xFF145C38);
  static const Color warning = Color(0xFF8F5200);
  static const Color warningContainer = Color(0xFFFFF0DA);
  static const Color onWarningContainer = Color(0xFF7A4500);
  static const Color error = Color(0xFFBA2F2A);
  static const Color errorContainer = Color(0xFFFDE7E5);
  static const Color onErrorContainer = Color(0xFF8C1D19);

  static const Color white = Color(0xFFFFFFFF);

  /// Third-party mark color, used only inside the Google sign-in mark.
  static const Color googleBlue = Color(0xFF4285F4);
}
