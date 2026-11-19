# flutter-arc

A Flutter app for Android and iOS, built feature-first on a token-based Material 3 design system. It currently ships the **Welcome screen** of the authentication flow, with light and dark themes.

## Features

- **Welcome screen**: brand logo, headline, a hero section with *Create Account* and *Sign In* actions, and social sign-in buttons.
- **Platform-aware social sign-in**: Facebook and Google on every platform; Apple appears on iOS only.
- **Light and dark themes** built from one brand palette, with custom brand roles in a `ThemeExtension`.
- **Responsive layout**: the screen fills the display on normal sizes and scrolls on short screens or with large text instead of overflowing.
- **Accessibility**: semantic labels on the logo and social buttons, a header role on the title, and minimum touch targets.
- **Bundled fonts**: Playfair Display (headlines) and Outfit (body). Their SIL OFL licenses are registered in the in-app license page.

> **Status:** the sign-up, sign-in and social auth flows are not built yet. Tapping those actions shows a "not available yet" snackbar.

## Requirements

| Tool | Version |
| --- | --- |
| Flutter | 3.50.0 or newer |
| Dart | 3.13.0 or newer (bundled with Flutter) |
| Android | Android Studio or SDK with a device/emulator |
| iOS | Xcode on macOS (for iOS builds) |

The app uses the [`material_ui`](https://pub.dev/packages/material_ui) package instead of `package:flutter/material.dart`, which needs this newer SDK. Older Flutter versions fail at `flutter pub get` with a "requires SDK version ^3.13.0" error. Run `flutter upgrade` to fix it.

## Getting started

```bash
git clone https://github.com/yugmewada/flutter-arc.git
cd flutter-arc
flutter pub get
flutter run
```

## Project structure

```
lib/
├── main.dart                     # Entry point; registers font licenses
├── app/
│   └── app.dart                  # MaterialApp, themes, and Welcome screen wiring
├── core/
│   ├── theme/
│   │   ├── app_colors.dart       # Raw brand palette (not used directly by widgets)
│   │   ├── app_theme.dart        # Light/dark ThemeData, fonts, button themes
│   │   ├── app_tokens.dart       # Spacing, radius, and size tokens
│   │   └── brand_colors.dart     # ThemeExtension for brand-specific color roles
│   └── widgets/
│       └── brand_logo.dart       # App logo drawn with CustomPainter
└── features/
    └── auth/
        └── presentation/
            ├── welcome_screen.dart
            └── widgets/
                ├── social_sign_in_button.dart
                └── welcome_hero.dart

assets/
├── fonts/                        # Playfair Display, Outfit
└── licenses/                     # OFL license texts for the bundled fonts

test/
├── widget_test.dart              # App launches on the Welcome screen
└── features/auth/presentation/
    └── welcome_screen_test.dart  # Content, callbacks, a11y, layouts, platforms, dark theme
```

New features go under `lib/features/<feature>/`. Code shared between features goes in `lib/core/`.

## Design system

Widgets read styling from the theme instead of hard-coding values:

- **Colors**: use `Theme.of(context).colorScheme` for Material roles and `BrandColors.of(context)` for brand roles (`accent`, `onAccent`, `mutedInk`). `AppColors` is the raw palette and is only referenced by the theme.
- **Spacing and sizes**: use `AppSpacing` (4–48), `AppRadius` (8–28) and `AppSizes` from `app_tokens.dart`.
- **Typography**: use `Theme.of(context).textTheme`. `headlineMedium` uses Playfair Display; other styles use Outfit.

| Token | Value |
| --- | --- |
| Brand blue (primary) | `#3350CB` |
| Brand yellow (accent) | `#F2FF33` |
| Ink (text) | `#262626` |
| Slate ink (muted text) | `#1F394E` |

## Testing and analysis

```bash
flutter analyze
flutter test
```

The widget tests cover the Welcome screen's content, that each button reaches its callback, accessible labels and touch targets, no overflow across screen sizes, the iOS/Android social button sets, and dark theme rendering.

## Known placeholders

- **Brand logo**: drawn in code from the design screenshot. Replace it with the official vector asset exported from Figma.
- **Google mark**: a plain "G" stands in for Google's official multicolor logo, which Google's sign-in branding guidelines require.
- **Hero image**: `WelcomeScreen` accepts an optional `heroImage`. A branded gradient placeholder is shown until one is supplied.
- **App ID**: the Android/iOS bundle ID is still `com.example.demo_project` and must be changed before release.
