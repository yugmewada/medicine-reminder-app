# CLAUDE.md

**Read [docs/MASTER_PROMPT.md](docs/MASTER_PROMPT.md) before any change.** It is the single source of truth. **Load and follow every relevant skill in `.claude/skills/`**; §11 of the master prompt maps each skill to this repo.

Quick facts (details in the master prompt):

- Flutter **3.50 at `/opt/flutter`**: `export PATH=/opt/flutter/bin:$PATH`.
- Import `package:material_ui/material_ui.dart`, never `package:flutter/material.dart`.
- **Light mode only.** Never add a dark theme or dark colours.
- **Guest mode is restricted:** any action that adds, edits or deletes medicines must go through `runIfCanManageMedicines(...)`, and data-changing routes belong in `MemberOnlyRoutes`.
- **No hard-coded UI strings.** Add them to `lib/l10n/app_en.arb` (with a description) and use `context.l10n`. A test enforces this.
- **Navigate with auto_route typed routes** (`context.router.push(MedicineDetailRoute(medicineId: id))`). New screens get `@RoutePage()` and an entry in `lib/app/router/app_router.dart`. Never use path literals, `Navigator.push` or `go_router`.
- Models and state are **Freezed**. Logic lives in Riverpod notifiers (MVI), not in widgets.
- Use the shared widgets in `lib/core/widgets/` (`AppToolbar`, `AppButton`, `TopSnackbar`, …). Never use `ScaffoldMessenger` snackbars.
- **All code lives in `lib/`. Never create local packages.** Utilities go in `lib/core/utils/`. Image picking goes only through `MediaPicker` there (Android Photo Picker, no `READ_MEDIA_*`).
- Before finishing: `dart run build_runner build && flutter gen-l10n && dart format lib test && flutter analyze && flutter test`.
