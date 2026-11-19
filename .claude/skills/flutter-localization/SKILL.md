---
name: flutter-localization
description: Add or maintain localization and internationalization in Flutter apps using flutter_localizations, ARB resources, gen-l10n, and intl. Use for translated UI strings, locale selection, RTL layouts, pluralization, or localized date/number formatting.
---

# Flutter Localization and Internationalization

Make user-facing content translatable, locale-correct, and layout-safe. Use Flutter's supported localization workflow and the project's existing architecture; do not build a competing string system.

## Workflow

1. Inspect the Flutter/Dart SDK constraints, `pubspec.yaml`, `l10n.yaml`, generated localization setup, routing/state management, supported locales, and existing translation files. Preserve current conventions and avoid hand-editing generated output.
2. Confirm the requested locales, default/fallback behavior, locale selector requirements, translation ownership, and whether backend-delivered content also requires localization. Do not invent translations for content that must be professionally reviewed.
3. Configure Flutter localization using `flutter_localizations`, `intl`, ARB source files, and `gen-l10n` according to the project's SDK. Declare supported locales and the app's localization delegates/locales at the app root.
4. Move all user-visible app-owned strings into ARB resources. Include clear, stable message keys and descriptions/context for translators. Avoid hard-coded UI strings, including validation, accessibility labels, notifications, and error messages.
5. Represent interpolation, plural, and gender/select variants with ICU message syntax and generated typed accessors. Use `intl` for locale-sensitive dates, numbers, currencies, and units; never manually concatenate localized fragments or hard-code locale-specific formats.
6. Regenerate localization code using the configured Flutter tooling. Update all call sites and remove obsolete literals carefully. Never edit generated localization files directly.
7. Validate every supported locale, including fallback behavior and missing/unused keys. Test longer translations, plural boundaries, non-Latin scripts, and RTL where applicable.

## ARB and message rules

- Keep the source ARB and translated ARBs structurally aligned. Preserve placeholders, placeholder types, ICU syntax, and metadata across locales.
- Write messages as complete natural phrases. Prefer a full sentence with named placeholders over concatenated fragments.
- Add translator descriptions for ambiguous context, variables, character limits, or product terminology. Keep keys stable and meaningful; do not make UI depend on translated text as an identifier.
- Provide plural/select logic through ICU messages, including locale-appropriate categories; do not assume English singular/plural rules apply universally.
- Include accessibility labels and semantics text in localization resources when they are user-facing.
- Keep server-owned content distinct from app UI strings. Clarify API localization contracts instead of silently translating server data on the client.

## Locale, formatting, and RTL

- Resolve locale from explicit user choice or platform settings according to product policy. Provide a sensible supported-locale fallback and avoid unexpected locale changes during navigation.
- Use `Localizations.localeOf(context)`, generated localization accessors, and `intl` APIs for locale-aware formatting. Do not store formatted display strings as canonical data.
- Use direction-aware layout APIs such as `EdgeInsetsDirectional`, `AlignmentDirectional`, and start/end text alignment. Avoid assuming left-to-right ordering or flipping directional icons that are not directional.
- Verify RTL screens for navigation, back/forward controls, text alignment, mixed-direction text, numbers, icons, animations, and image placement. Confirm which brand assets should remain unmirrored.
- Respect locale-specific calendars, digits, separators, currency conventions, and time formats where required. Test on actual supported locales rather than relying only on the device's default.

## Quality checks

Run localization generation and inspect output for missing or malformed resources. Run `dart format`, `flutter analyze`, and relevant widget tests. Test locale switching, persistence if supported, fallback behavior, large text, long translations, plural forms, RTL, and date/number formatting. Report which locales were checked and identify translations that require human/native-speaker review.

Do not claim full localization merely because strings are in ARB files. Confirm all user-visible surfaces in scope—including dialogs, forms, notifications, accessibility labels, and errors—are covered.
