---
name: flutter-visual-design-system
description: Define and apply a cohesive visual design system for Flutter apps, including Material 3 light/dark theming, semantic color schemes, typography, spacing, shapes, elevation, component themes, icons, illustrations, app icons, splash screens, and visual polish. Use when establishing or consistently applying a polished visual language across Flutter screens.
---

# Flutter Visual Design System

Build a coherent, attractive, accessible visual language for a Flutter app and apply it consistently across its screens. Inspect the current product and design references before changing styling; preserve existing brand identity and project conventions unless asked to redesign them.

## Workflow

1. **Inspect the app.** Review `pubspec.yaml`, Flutter/Dart constraints, app entry point, existing Material version, themes, fonts, asset setup, reusable widgets, icons, representative screens, and any brand/Figma guidelines. Search for existing styling constants and avoid creating duplicate systems.
2. **Confirm the visual direction.** Extract colors, typography, density, shapes, elevation, and component treatment from supplied references. Distinguish confirmed brand/design decisions from proposals. If references are incomplete, propose a compact system and identify assumptions instead of silently inventing a brand.
3. **Define design tokens.** Establish semantic colors, typography roles, spacing and radius scales, and elevation/shape tokens as needed. Keep names role-based and tokens centrally discoverable.
4. **Configure Material 3 themes.** Build light and dark `ThemeData` from a coherent `ColorScheme`; support system theme selection if appropriate. Add `ThemeExtension` only for semantic design roles not represented by standard Material tokens.
5. **Set global type and component styles.** Create a role-based `TextTheme`, configure reusable component themes, and ensure screens consume the shared theme rather than local styling literals.
6. **Establish icon and image rules.** Define when to use outlined or filled icons, asset conventions, illustration style, empty-state imagery, and placeholders. Keep assets licensed, sized appropriately, and consistent with the visual language.
7. **Apply and refine across screens.** Migrate incrementally, checking hierarchy, alignment, whitespace, contrast, consistency, responsiveness, and content states. Compare against the design references or inspect screenshots where available.
8. **Validate and report.** Test light/dark modes and representative screens, run formatting, analysis, and tests, and report implementation scope, assumptions, unconverted styles, and unresolved design questions.

## Material 3 and semantic color

- Use Material 3 (`useMaterial3: true`) when appropriate for the project's SDK and design direction. Do not change Material behavior blindly if the existing app intentionally follows another system.
- Create related color roles from a supplied seed or brand palette using `ColorScheme.fromSeed` when this matches the design. Review and adjust generated roles for brand fidelity, contrast, and surface layering; seed generation alone does not guarantee a finished palette.
- Provide a coordinated light and dark scheme when both modes are required. Test real surfaces, text, icons, controls, overlays, disabled states, borders, focus, and errors in both modes.
- Use semantic roles such as `primary`, `surface`, `onSurface`, `surfaceContainer`, `outline`, and `error` through `Theme.of(context).colorScheme`. Add product-specific semantic roles through a theme extension when standard roles are insufficient.
- Do not hard-code hex colors inside widgets. Centralize raw palette values and map them to semantic roles. Avoid using a raw brand shade where a semantic role communicates intent better.
- Verify text and control contrast against each actual background. Do not rely on color alone for status; add labels, icons, patterns, or shape cues.
- Keep success, warning, error, and informational roles distinct and ensure their content remains legible across themes.

## Typography and font assets

- Build a compact hierarchy using Flutter `TextTheme` roles. A typical hierarchy maps display/headline/title/body/label roles from larger to smaller (for example, `displayLarge` through `labelSmall`); select exact sizes and weights from Figma/brand guidance rather than imposing a generic scale.
- Use a consistent font family and a limited set of weights. Use supplied, licensed font assets where available; otherwise use platform defaults unless a deliberate brand decision requires another font.
- Declare font families and actual weight files accurately in `pubspec.yaml`; include only fonts the project may distribute. Avoid false weight mappings and unnecessary font assets.
- Define reusable text roles rather than screen-specific styles. Permit local overrides only for genuine exceptions and avoid scattering font sizes, weights, and colors in widgets.
- Preserve platform text scaling. Avoid fixed-height text boxes that clip larger text, and verify longer/localized strings and different scripts.
- Typography should establish clear hierarchy without sacrificing legibility. Use line heights and letter spacing deliberately, particularly for dense labels and all-caps text.

## Spacing, shape, and elevation tokens

Use the supplied system when one exists. Otherwise use a compact scale inspired by the screenshot's example values, then adjust based on actual layouts:

- **Spacing:** 4, 8, 12, 16, 24, 32, 48 logical pixels.
- **Corner radii:** 8, 12, 16, 28 logical pixels for increasing softness/emphasis where appropriate.

Centralize values as immutable constants or a theme extension, using clear names such as `xs`, `sm`, `md`, `lg`, `xl`, or semantic equivalents. Avoid arbitrary near-duplicate values and one-off tokens that obscure rather than simplify the design.

- Use logical pixels and responsive constraints; do not encode device width/height as design tokens.
- Define component shapes and elevation intentionally. Prefer subtle elevation and appropriate surface colors over layering shadows everywhere.
- Ensure spacing supports content hierarchy, grouping, and touch comfort. Visual icon size is not the same as interactive target size.
- Keep radii consistent among related controls and cards while allowing intentional hierarchy (for example, a pill action vs. a standard text field).

## Component themes and reuse

Configure relevant Material component themes centrally so repeated widgets remain consistent. Consider `FilledButtonThemeData`, `ElevatedButtonThemeData`, `OutlinedButtonThemeData`, `TextButtonThemeData`, `CardThemeData`/the SDK-compatible card theme API, `InputDecorationThemeData`/the SDK-compatible input theme API, `AppBarTheme`, `NavigationBarThemeData`, dialogs, chips, and floating action buttons as appropriate.

- Check the Flutter SDK version before selecting theme property/class names; APIs can change between versions. Use the project's available API rather than copying incompatible snippets.
- Specify typography, foreground/background colors, padding, shape, elevation, minimum size, and interaction states where the product needs consistent treatment.
- Prefer component themes for standard Material controls and reusable widgets for genuinely product-specific patterns. Avoid styling every instance differently.
- Keep reusable components semantic and configurable; do not create a large component library before repeated needs are clear.
- Review hover, focus, pressed, selected, disabled, loading, validation, and error states when a component supports them.

## Icons, illustrations, and empty states

- Choose a consistent icon style—outlined or filled—based on the design. Mix styles only for a deliberate hierarchy or state change.
- Prefer platform/system iconography or a consistent licensed icon set already in the project. Use predictable size, stroke/weight, alignment, and semantic labels.
- Use illustrations and empty-state images only when they improve comprehension or warmth; match their color, line, and shape language to the rest of the app.
- Provide meaningful placeholders/loading states for remote images, correct aspect ratios/crops, and accessibility descriptions where images convey information. Decorative assets should not create redundant screen-reader output.
- Do not use unrelated stock imagery, emoji as a replacement for designed icons, or unlicensed assets. Avoid icons as the only labels for unfamiliar or consequential actions.

## App icon and splash screen

When app-level branding assets are in scope, inspect platform setup and use the project's chosen tooling rather than editing generated platform assets inconsistently.

- Prefer the existing `flutter_launcher_icons` configuration/tooling when present or approved; verify Android adaptive icon layers and iOS icon requirements for the project's target versions.
- Prefer the existing `flutter_native_splash` configuration/tooling when present or approved; coordinate splash background/logo with light/dark and platform behavior.
- Use source assets that are crisp at required densities, centered safely, and compliant with platform masking/cropping. Do not place important text or fine detail near crop boundaries.
- Regenerate platform assets using the configured command, inspect the output, and report the source asset and generation steps. Do not add dependencies or overwrite custom native assets without checking first.
- Distinguish native launch/splash behavior from an in-app loading page; avoid extending splash screens to conceal slow startup.

## Visual polish checklist

For each representative screen, review:

- **Hierarchy:** Is the primary content and action immediately clear? Are headings, body text, and labels distinct and consistent?
- **Whitespace:** Are related elements grouped and unrelated groups separated? Is density consistent across screens?
- **Alignment:** Do text baselines, card edges, icons, and controls align to a consistent grid?
- **Contrast:** Are text, controls, disabled states, icons, and surfaces legible in light and dark themes?
- **Consistency:** Do colors, type, spacing, shapes, buttons, fields, navigation, and icon styles follow the same rules?
- **States:** Are loading, empty, error, success, selected, pressed, disabled, and focus states designed where needed?
- **Responsiveness:** Do small/large screens, keyboard display, safe areas, large text, and localization avoid clipping or awkward gaps?
- **Accessibility:** Are semantics, touch targets, focus indicators, text scaling, and non-color cues adequate?
- **Assets:** Are icons and imagery crisp, correctly cropped, licensed, and stylistically cohesive?

As a default polish constraint, avoid using more than two font families/weights as separate visual voices on one screen unless the supplied design clearly calls for it. Use type roles and consistent weights rather than adding more styles to create hierarchy.

## Implementation guardrails

- Follow existing project architecture and the Flutter SDK's compatible APIs.
- Keep tokens separate from feature/business logic. Do not put account settings, API data, or runtime user preferences inside immutable brand-token classes.
- Support runtime theme mode through app-level state only if product requirements call for it; do not hard-code all users to a new theme mode.
- Do not claim visual parity or complete asset regeneration without inspecting the rendered app/platform outputs.
- Keep changes scoped, avoid unrelated redesigns, and explain provisional visual decisions for user approval when brand requirements are unclear.

## Completion checks

Run `dart format`, `flutter analyze`, and relevant tests. Verify representative screens in applicable light/dark themes and sizes; inspect generated app icon/splash assets if changed. Report changed token/theme/component files, screens migrated, assumptions, checks run, and known gaps.
