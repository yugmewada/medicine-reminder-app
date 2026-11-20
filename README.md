# Doseza

A Flutter **medicine tracker prototype** for Android and iOS: splash, onboarding, demo sign-in, a daily dose plan with progress, an inventory with add/edit, and a profile.

> **Prototype only.** All data is fictional sample data, kept in memory for the current session. Nothing is saved to disk or sent anywhere. Sign-in with Google or Apple is simulated, with no account and no credentials. The app gives no medical advice.

**Contributors and AI agents: read [docs/MASTER_PROMPT.md](docs/MASTER_PROMPT.md) first.** It is the single source of truth for scope, design system, architecture and conventions.

## Features

- **Splash → onboarding (3 pages, skippable) → welcome.** Google and Apple entry points explain that sign-in is simulated and give full access.
- **Guest mode:** "Continue as guest" opens the app with no data, so every screen shows its empty state. Adding medicines shows a sign-in alert; signing in (simulated) unlocks everything and loads the sample data.
- **Today:** a greeting with the first name, a scrollable date strip (today ±14 days), and a progress ring showing *"1 of 5 scheduled doses logged as taken — 20%"*. Each dose card has Taken / Skip / Undo, with an Undo action in the top snackbar too. There is an empty state for days with nothing scheduled, and future days cannot be logged.
- **Inventory:** sample medicines with stock in explicit units, a detail view, and an add/edit form. The form covers name, type, frequency (daily / weekly / monthly), demo schedule times, quantity plus unit, and an optional photo. It validates input and asks before discarding changes.
- **Profile:** demo profile, plus honest placeholder dialogs for Terms, Privacy and Share. It also has open-source licenses, the app version, and a Log out action that resets every session change.
- **Top snackbar:** slides in from the top, and can be closed with ✕, swiped up, or left to time out.
- **Light mode only**, by design.
- **Accessibility and responsiveness:** WCAG AA contrast, 48 dp tap targets, semantic labels, support for 200% text, small and large phones, landscape, RTL layout, and reduced motion.
- **Fully localized:** every string, including accessibility labels and errors, comes from ARB files with ICU plurals and selects. English ships now.
- **auto_route navigation:** generated typed routes, a session guard, persistent tabs with their own stacks, deep links (remembered across sign-in), and a not-found fallback.

## Requirements

| Tool | Version |
| --- | --- |
| Flutter | **3.50.0** (Dart 3.14). On the dev machine it is at `/opt/flutter`; the snap Flutter on `PATH` is too old. |
| Android | SDK with a device or emulator |
| iOS | Xcode on macOS |

The app uses [`material_ui`](https://pub.dev/packages/material_ui) instead of the deprecated `package:flutter/material.dart`.

## Getting started

```bash
git clone https://github.com/yugmewada/medicine-reminder-app.git
cd medicine-reminder-app
export PATH=/opt/flutter/bin:$PATH   # Flutter 3.50 (adjust to your install)
flutter pub get                 # also generates localizations
dart run build_runner build     # Freezed models + auto_route routes (generated files are committed)
flutter run
```

## Project structure

```
lib/
  app/            # MaterialApp.router; router/ = AppRouter (auto_route), guard, navigation policy
  core/           # theme tokens, shared widgets, transitions, l10n helper, formatting,
                  #   providers, utils/ (MediaPicker, DayUtils, Validators)
  l10n/           # app_en.arb (source strings) + generated AppLocalizations
  features/       # session, splash, onboarding, auth, shell, today, medicines, profile
                  #   each: domain/ (Freezed models, rules) + presentation/ (Riverpod MVI)
docs/
  MASTER_PROMPT.md
test/             # unit, widget, flow, accessibility and layout tests
```

## Image picking

There is one cross-platform picker: `MediaPicker` in `lib/core/utils/media_picker.dart`, which wraps `image_picker` and is gallery only.

- **Android** always uses the system Photo Picker (`PickVisualMedia`), so it needs no media permissions. The manifest explicitly removes `READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO` and `READ_EXTERNAL_STORAGE`.
- **iOS** uses PHPicker. `NSPhotoLibraryUsageDescription` is set for the iOS 13 fallback.

## Design system

The font is **Outfit** (400/500/600, SIL OFL). Colors are semantic roles from the theme; there are no hex values in widgets.

| Role | Colour |
| --- | --- |
| primary | `#3350CB` |
| surface / card | `#F6F7FB` / `#FFFFFF` |
| text / muted | `#1B2030` / `#596178` |
| success (Taken) | `#1D7A4C` |
| warning (Skipped) | `#8F5200` |
| error | `#BA2F2A` |

## Testing

```bash
dart run build_runner build && flutter gen-l10n
dart format lib test
flutter analyze
flutter test
```

## Known placeholders

The following are placeholders to replace before any real release:

- the code-drawn logo and illustrations
- the Google "G" mark
- the default native launch screens
- the `com.example.demo_project` application ID

See [docs/MASTER_PROMPT.md §9](docs/MASTER_PROMPT.md#9-known-placeholders-replace-when-real-assets-exist).
