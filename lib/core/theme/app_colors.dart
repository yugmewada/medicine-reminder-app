import 'package:material_ui/material_ui.dart';

/// Raw brand palette. Widgets must not use these directly — read semantic
/// roles from `Theme.of(context).colorScheme` or [BrandColors] instead.
abstract final class AppColors {
  static const Color brandBlue = Color(0xFF3350CB);
  static const Color brandYellow = Color(0xFFF2FF33);
  static const Color ink = Color(0xFF262626);
  static const Color slateInk = Color(0xFF1F394E);
  static const Color slateInkLight = Color(0xFFB9C7D3);
  static const Color white = Color(0xFFFFFFFF);

  /// Third-party brand colors, used only for their own sign-in marks.
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color googleBlue = Color(0xFF4285F4);
}
