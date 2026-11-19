import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';
import 'app_tokens.dart';
import 'brand_colors.dart';

abstract final class AppFonts {
  static const String display = 'PlayfairDisplay';
  static const String body = 'Outfit';
}

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final seeded = ColorScheme.fromSeed(
      seedColor: AppColors.brandBlue,
      brightness: brightness,
    );
    final scheme = isLight
        ? seeded.copyWith(
            primary: AppColors.brandBlue,
            onPrimary: AppColors.white,
            surface: AppColors.white,
            onSurface: AppColors.ink,
            surfaceContainerLowest: AppColors.white,
          )
        : seeded;

    final baseText = ThemeData(brightness: brightness).textTheme.apply(
      fontFamily: AppFonts.body,
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    final textTheme = baseText.copyWith(
      headlineMedium: baseText.headlineMedium?.copyWith(
        fontFamily: AppFonts.display,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      bodyLarge: baseText.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      titleMedium: baseText.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: baseText.titleSmall?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppFonts.body,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, AppSizes.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: const StadiumBorder(),
          textStyle: textTheme.titleMedium,
        ),
      ),
      extensions: [isLight ? BrandColors.light : BrandColors.dark],
    );
  }
}
