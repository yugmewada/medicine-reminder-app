import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoPageTransitionsBuilder;
import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';
import 'app_status_colors.dart';
import 'app_tokens.dart';

/// The app uses a single type family. Hierarchy comes from size, weight
/// (400 body, 500 labels/titles, 600 headlines) and spacing.
abstract final class AppFonts {
  static const String family = 'Outfit';
}

/// The app is light-only by product decision: there is no dark theme, and
/// `App` pins `ThemeMode.light` so the OS dark setting has no effect.
abstract final class AppTheme {
  static ThemeData get light => _build();

  static ColorScheme _scheme() =>
      ColorScheme.fromSeed(seedColor: AppColors.brandBlue).copyWith(
        primary: AppColors.brandBlue,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.brandBlueContainer,
        onPrimaryContainer: AppColors.onBrandBlueContainer,
        surface: AppColors.page,
        onSurface: AppColors.ink,
        onSurfaceVariant: AppColors.inkMuted,
        surfaceContainerLowest: AppColors.card,
        surfaceContainerLow: AppColors.card,
        surfaceContainer: AppColors.cardHigh,
        surfaceContainerHigh: AppColors.cardHigh,
        surfaceContainerHighest: AppColors.cardHighest,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineSoft,
        error: AppColors.error,
        onError: AppColors.white,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
      );

  static TextTheme _textTheme(ColorScheme scheme) {
    TextStyle style(double size, FontWeight weight, double height) => TextStyle(
      fontFamily: AppFonts.family,
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: scheme.onSurface,
      letterSpacing: 0,
    );
    const regular = FontWeight.w400;
    const medium = FontWeight.w500;
    const semiBold = FontWeight.w600;
    return TextTheme(
      displaySmall: style(32, semiBold, 1.2),
      headlineMedium: style(28, semiBold, 1.25),
      headlineSmall: style(24, semiBold, 1.3),
      titleLarge: style(20, semiBold, 1.3),
      titleMedium: style(17, medium, 1.35),
      titleSmall: style(15, medium, 1.35),
      bodyLarge: style(16, regular, 1.5),
      bodyMedium: style(15, regular, 1.45),
      bodySmall: style(13, regular, 1.4),
      labelLarge: style(15, medium, 1.3),
      labelMedium: style(13, medium, 1.3),
      labelSmall: style(12, medium, 1.3),
    );
  }

  static ThemeData _build() {
    final scheme = _scheme();
    final text = _textTheme(scheme);

    final roundedMd = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );
    const buttonMinSize = Size(64, AppSizes.buttonHeight);
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.md,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      fontFamily: AppFonts.family,
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      // Screen transitions, explicit so they are consistent and
      // documented. Used by every screen via AppPageRoute; only bottom-tab
      // switches differ (AnimatedBranchContainer).
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          // Shared-axis zoom, plus Android 14+ predictive back gesture.
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          // Native slide with edge swipe-back.
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
        },
      ),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: scheme.shadow.withValues(alpha: 0.12),
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        indicatorColor: scheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => text.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.onPrimaryContainer
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: const StadiumBorder(),
          textStyle: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: const StadiumBorder(),
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          textStyle: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(AppSizes.minTapTarget, AppSizes.minTapTarget),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: const StadiumBorder(),
          textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppSizes.minTapTarget),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 2,
        extendedTextStyle: text.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: const StadiumBorder(),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        labelStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        floatingLabelStyle: text.bodyLarge?.copyWith(color: scheme.primary),
        hintStyle: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
        helperStyle: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        helperMaxLines: 3,
        errorMaxLines: 3,
        errorStyle: text.bodySmall?.copyWith(color: scheme.error),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: scheme.outlineVariant),
        labelStyle: text.labelLarge,
        shape: const StadiumBorder(),
        showCheckmark: true,
        checkmarkColor: scheme.onPrimaryContainer,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          minimumSize: const Size(0, AppSizes.minTapTarget),
          selectedBackgroundColor: scheme.primaryContainer,
          selectedForegroundColor: scheme.onPrimaryContainer,
          textStyle: text.labelLarge,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: roundedMd,
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: text.titleSmall,
        subtitleTextStyle: text.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        minVerticalPadding: AppSpacing.md,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        circularTrackColor: scheme.surfaceContainerHighest,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
      ),
      extensions: const [AppStatusColors.light],
    );
  }
}

/// Short accessors so widgets read semantic roles, never raw colors.
extension AppThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  AppStatusColors get status => AppStatusColors.of(this);
}
