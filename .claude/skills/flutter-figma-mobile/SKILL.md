---
name: flutter-figma-mobile
description: Convert Figma designs and design specifications into production-ready Flutter interfaces for Android and iOS. Use when implementing screens, navigation, design tokens, reusable widgets, responsive layouts, or visual QA from Figma.
---

# Figma-to-Flutter Mobile UI

Implement the supplied design faithfully while producing maintainable Flutter code that works across Android and iOS.

## Workflow

1. Inspect the repository before changing it. Identify Flutter/Dart versions, routing, state-management and theming conventions, existing assets, and test structure. Preserve established patterns unless there is a concrete reason to change them.
2. Inspect the Figma frames, variants, components, typography, colors, spacing, assets, and interaction states. If a design detail is unavailable, record the assumption and choose a consistent accessible default; do not invent product behavior silently.
3. Map screens and user journeys before coding. Define reusable components for repeated patterns rather than duplicating entire screens.
4. Translate design tokens into centralized Flutter theme/extensions. Use logical pixels, constraints, `SafeArea`, scroll behavior, and platform-aware insets. Avoid hard-coded device dimensions.
5. Implement semantic, composable widgets. Keep view rendering separate from data/business logic. Use the project's existing architecture and dependencies; ask before adding a large dependency or replacing architecture.
6. Include loading, empty, error, disabled, focused, and success states where the flow requires them. Wire visible controls to real navigation/actions; avoid decorative dead-end buttons.
7. Compare the running UI with supplied frames at representative phone sizes and both platforms when possible. Fix hierarchy, spacing, text wrapping, image crops, keyboard overlap, and overflow.

## Flutter guidance

- Prefer `LayoutBuilder`, `Flexible`, `Expanded`, `Wrap`, scrolling containers, and constraints over screen-size conditionals that assume one device.
- Use `ThemeData` and shared text styles; preserve text scaling and support localization-friendly layouts.
- Provide meaningful semantics and labels for controls. Maintain accessible contrast, touch targets, focus order, and keyboard behavior.
- Keep assets in the project's asset structure and update `pubspec.yaml` deliberately. Use vector assets where appropriate and provide raster density variants as needed.
- Use platform-specific behavior only when it improves native usability; keep domain behavior consistent.
- Do not copy unlicensed fonts, illustrations, or brand assets into the project.

## Completion checks

Run formatting and static analysis, for example `dart format .` and `flutter analyze`, plus relevant widget tests. Report implemented screens, notable assumptions, files changed, and any checks that could not be run. Never claim pixel-perfect parity without visual comparison.
