# Doseza — Master Prompt

> **This file is the single source of truth for any AI agent or developer working on this repo.**
> Read it fully before changing code. `CLAUDE.md` and `AGENTS.md` only point here.
> When a decision below changes, update this file in the same change.
>
> **The project skills in `.claude/skills/` are mandatory.** Load and follow every skill relevant to the task. §11 maps each skill to how it applies here, including the parts that are deliberately out of scope for this prototype. When a skill and this file conflict, this file wins.

---

## 1. Role and product

You are a senior Flutter product designer and engineer working on **Doseza**, a polished **medicine tracker prototype** for **Android and iOS**. It is a **non-production, static-data prototype**: put a complete, attractive, tappable experience ahead of backend integration.

### Hard boundaries (never break)

- **Data:** fictional sample data only.
  - User changes live in memory (Riverpod) for the current session.
  - Nothing is written to disk or a database, or sent over the network.
  - Logout and app restart reset everything.
- **Not included:** backend, API, database, real OAuth or social auth, analytics, crash reporting, real notification scheduling.
- **Sign-in:** Google and Apple are **simulated entry points only**.
  - Tapping one opens a dialog that explains the simulation, then enters with the fictional `DemoProfile.sample` and full access.
  - **"Continue as guest"** enters in **guest mode**, which is restricted (§8 "Guest mode").
  - Never collect credentials or imply that an account was created.
- **Light mode only.** There is no dark theme. `App` pins `ThemeMode.light`, Android has no `values-night` resources, and iOS sets `UIUserInterfaceStyle = Light`. Do not add dark colours or theme variants.
- **No claims** of encryption, secure storage, HIPAA compliance, medical validation, or "never transmitted" beyond what the code establishes. The current honest wording: *no backend, account system or analytics; data is kept in memory on this device and reset on logout or close.*
- **No medical advice:**
  - No missed-dose instructions, dose adjustments, refill authorization or clinical judgement.
  - Never pre-fill a schedule time for a new medicine.
  - A "Taken" log is the user's own record and does not prove the medicine was taken. Say so wherever progress is shown.
- **Tone:** supportive. No blame, no streaks, no "missed". An unlogged past dose is **"Not logged"**.
- **Notifications** are not implemented. If they are ever added, previews must not show medicine names or doses.
- Do not change signing, release or store-submission configuration. Do not publish or upload anything.
- Every visible control must work as described or be disabled with an explanation. No dead ends.

---

## 2. Toolchain and dependencies

| Item | Value |
| --- | --- |
| Flutter | **3.50.0 at `/opt/flutter`**. The 3.44 snap on `PATH` cannot resolve this project, so run `export PATH=/opt/flutter/bin:$PATH` first. |
| Dart | 3.14 (SDK constraint `^3.13.0`) |
| Material | **`package:material_ui/material_ui.dart`** only. `package:flutter/material.dart` has been deprecated since Flutter 3.47. **Never import it.** |
| Package name | `demo_project` (imports use `package:demo_project/...`) |

**Dependencies:**
- Runtime: `material_ui`, `cupertino_ui` (for the iOS page transition), `flutter_localizations`, `flutter_riverpod` 3, **`auto_route` 11** (built on `material_ui`), `freezed_annotation`, `intl`, `cupertino_icons`, `flutter_slidable` 5 (swipe actions; built on `material_ui`), and `image_picker` (+ `image_picker_android`, `image_picker_platform_interface`).
- Dev: `build_runner`, `auto_route_generator`, `freezed`, `flutter_lints`.
- **No local packages.** All app code, utilities included, lives in `lib/` (user decision). Don't create `packages/`.
- **Generator pins:** the generators must share one analyzer version. `auto_route_generator` 10.6 needs analyzer <14, so `build_runner` is on 2.16.1 and `freezed` on 4.0.1; later releases of both need analyzer 14. Upgrade all three together.
  - build_runner's warning that the SDK language (3.14) is newer than analyzer's (3.13) is expected and harmless: the package's language version is 3.13 (`sdk: ^3.13.0`). Don't use 3.14-only syntax until the generators move to analyzer 14.

**Before adding a dependency:**
- Check that its **latest** version on pub.dev does not import `package:flutter/material.dart`. Don't rely on a stale copy in `~/.pub-cache`.
- Explain the dependency to the user first.

### Code generation (never hand-edit generated files; they are committed)

```bash
dart run build_runner build      # *.freezed.dart and lib/app/router/app_router.gr.dart
flutter gen-l10n                 # lib/l10n/app_localizations*.dart (also runs on pub get / build)
```

---

## 3. Architecture (skill: flutter-architecture)

The app uses MVI-style one-way data flow with Riverpod:

**View → intent (a method on a Notifier) → new immutable Freezed state → View.**

```
lib/
  main.dart                      # font license, PlatformMediaPicker.configure(), runApp(DosezaApp)
  app/
    app.dart                     # MaterialApp.router, themes, localization delegates
    router/
      app_router.dart            # AppRouter (auto_route config), SessionGuard, appRouterProvider
      app_router.gr.dart         # generated typed routes (TodayRoute, MedicineDetailRoute, …)
      navigation_policy.dart     # AppPaths, NavigationPolicy (pure rules, unit-tested)
  core/
    constants/app_info.dart      # version (mirrors pubspec; a test enforces this)
    formatting/app_formats.dart  # weekday/time formatting that is not a sentence
    l10n/l10n.dart               # context.l10n + re-export of AppLocalizations
    navigation/app_transitions.dart # AppPageRoute (every screen) + animated tab container
    providers/core_providers.dart# clockProvider, mediaPickerProvider (overridden in tests)
    utils/                       # UI- and language-agnostic utilities (§7): media_picker, day_utils, validators
    theme/                       # app_colors (raw), app_theme (+ context ext), app_status_colors, app_tokens
    widgets/                     # shared widgets; import the widgets.dart barrel
  l10n/                          # app_en.arb (source) + generated AppLocalizations
  features/
    session/session_controller.dart   # AppStage, SignInMethod, DemoProfile, SessionState (Freezed)
    splash/ onboarding/ auth/          # pre-sign-in screens
    shell/home_shell.dart              # AutoTabsRouter + AppTabBar (floating glass pill) + AnimatedBranchContainer
    shell/not_found_screen.dart        # unknown-link fallback
    today/      domain/dose_schedule.dart (pure rules, Freezed) · presentation/ (controller, screen, widgets)
    medicines/  domain/medicine.dart (Freezed) · data/sample_medicines.dart
                presentation/ medicines_controller, medicine_form_controller (MVI), medicine_l10n,
                              inventory_screen, medicine_detail_screen, medicine_form_screen, widgets/
    profile/presentation/profile_screen.dart
```

### State
- Riverpod `Notifier` and `Provider`, written by hand with no Riverpod codegen.
- **Freezed** for models and state: `Medicine`, `ScheduleTime`, `DoseOccasion`, `DayProgress`, `DayPlan`, `DemoProfile`, `SessionState`, `MedicineFormState`.
- `json_serializable` is not used because there is no JSON or API.
- Each public notifier method is **one user intent**. Results that need UI feedback, such as `AddTimeResult` or `MediaPickResult`, are returned to the view, which shows the feedback.
- Business rules live in `domain/` (pure Dart) or in notifiers, never in widgets. Example: `MedicineFormController` owns validation (`MedicineFormState.firstIssue`), dirty-checking, unit-follows-type, time limits, photo picking and saving. The view only renders state and holds `TextEditingController`s.
- Always read "now" from `clockProvider`. Never call `DateTime.now()` in rules or screens.
- Domain code must not import `material_ui`. Use `ScheduleTime`, not `TimeOfDay`.

### Routing (`auto_route`)

Screens are annotated with `@RoutePage()`. The generator names each route after its class, replacing `Screen` with `Route` (`TodayScreen` becomes `TodayRoute`). `HomeShell` is named `HomeShellRoute` explicitly.

| Path | Route | Notes |
| --- | --- | --- |
| `/splash`, `/onboarding`, `/welcome` | `SplashRoute`, `OnboardingRoute`, `WelcomeRoute` | default route (`AppPageRoute`), like every screen |
| `/` → `/today` | `HomeShellRoute` → `TodayRoute` | the shell is `AutoTabsRouter.builder` plus `AnimatedBranchContainer` (tabs fade through) |
| `/inventory` | `InventoryTabRoute` → `InventoryRoute` | `InventoryTabScreen extends AutoRouter`: a nested stack for the tab |
| `/inventory/medicine/:medicineId` | `MedicineDetailRoute` | inside the tab's stack, so the tab bar stays visible |
| `/inventory/add` | `AddMedicineRoute` | **root** stack, above the tab bar; full-screen dialog |
| `/inventory/medicine/:medicineId/edit` | `EditMedicineRoute` | root stack |
| `/profile` | `ProfileRoute` | |
| `*` | `NotFoundRoute` | "Go to Today" |

**Navigating:**
- Always use typed routes: `context.router.push(MedicineDetailRoute(medicineId: id))`.
- Use `navigate` or `replaceAll` for jumps between tabs or flows, `maybePop` for Cancel and back, and `pop(result)` after saving (it bypasses `PopScope`).
- Never use path literals, `Navigator.push` or `MaterialPageRoute` for screens. `AppPaths` exists only for deep links and tests.

**Session rules** (pure, in `NavigationPolicy`, tested in `test/app/navigation_policy_test.dart`):
- `SessionGuard`, a global guard, lets a navigation through only when `NavigationPolicy.allows(stage, routeName)`:
  - Signed out: only the current stage's screen, plus Not found.
  - Signed in: every app route, but not the pre-auth screens.
  - A blocked navigation shows the stage's screen instead.
- `App` listens to `sessionProvider` and calls `AppRouter.syncToSession` whenever the stage changes. This covers splash → onboarding → welcome → home, and logout → welcome.

**Deep links:**
- `AppRouter.deepLinkBuilder` routes platform links, including the launch location, through `NavigationPolicy.resolveDeepLink`.
- A safe in-app link (`isSafeInAppLocation`) that arrives while signed out is opened after sign-in.
- Logout never passes through `deepLinkBuilder`, so the screen the user left is not reopened.
- **Unknown or malformed ids** show a recoverable "not found" state.

**Back behavior:**
- System back pops the active tab's stack first.
- On the Inventory or Profile tab with nothing to pop, back goes to Today.
- Tapping the active tab returns it to its root (`popUntilRoot`).
- Each tab keeps its own stack.

**Other:**
- auto_route resolves the launch route asynchronously, so the first frame is blank (covered by the native launch screen). In tests, `pump()` once after `pumpWidget`.
- Native deep-link configuration (intent filters, associated domains) is not set up. Add it only if the product asks for it.

### Logout
`SessionController.logout()` invalidates `medicinesProvider`, `doseLogProvider` and `selectedDateProvider`, then sets the stage to Welcome. The router redirect takes the user to Welcome. Onboarding is not repeated within the same app run.

---

## 4. Localization (skill: flutter-localization)

- **Every user-visible string comes from `lib/l10n/app_en.arb` via `context.l10n`.** That includes semantics labels, tooltips, hints, dialog text, validation errors and snackbars.
  - `test/l10n_test.dart` fails on hard-coded literals passed to text-bearing parameters.
  - A rare non-text glyph (such as the placeholder Google "G") must have a `// l10n-ignore:` comment above it.
- **Every ARB entry needs a translator `description`.** This is enforced by `required-resource-attributes` and a test.
- Use complete sentences with named placeholders. Never concatenate translated fragments.
- **Plurals and selects** use ICU (`doseCount`, `medicineCount`, `stockAmount`, `progressHeadline`, `greeting`, `doseStatus`, `medicineType`, …).
- **Dates** use `DateTime` placeholders with an intl skeleton (`MMMMEEEEd`, `MMMd`, `EEEE`). Percentages use a `double` with `percentPattern`, so `DayProgress.percentFraction` is passed in rather than a formatted string.
- Domain enums carry **no display text**. Map them in `medicine_l10n.dart` (`l10n.typeLabel(...)`, `l10n.stock(...)`, `l10n.cadence(...)`). The utilities in `lib/core/utils/` return typed codes (`ValidationIssue`, `MediaPickFailure`), and presentation code maps those to messages.
- **Localization delegates:** use `App.localizationsDelegates`, which is `AppLocalizations.delegate` plus `material_ui`'s `GlobalMaterialLocalizations.delegates`. **Do not use the generated `AppLocalizations.localizationsDelegates`**: it points at the deprecated `flutter_localizations` Material delegates.
- **Locales:** English only. Adding a locale means a new `app_<locale>.arb` with reviewed translations. Never machine-invent translations.
- Fictional sample data (medicine names, the demo profile) is data, not UI text, and is not localized.
- **RTL:** use direction-aware APIs (`EdgeInsetsDirectional`, `AlignmentDirectional`). Decorative art and gradients are intentionally not mirrored. Every screen is smoke-tested in RTL.

---

## 5. Design system (skill: flutter-visual-design-system)

Calm, trustworthy and contemporary, built on Material 3. **All styling comes from the theme.** Widgets never contain hex literals or one-off font sizes.

### Colour

The palette is light only; the app has no dark mode.

| Role | Value | Notes |
| --- | --- | --- |
| `primary` / `onPrimary` | `#3350CB` / `#FFFFFF` | 6.7:1 |
| `primaryContainer` / `onPrimaryContainer` | `#E7EBFC` / `#1B2A78` | progress card, selected chips |
| `surface` (page) | `#F6F7FB` | |
| `surfaceContainerLowest` (cards) | `#FFFFFF` | |
| `surfaceContainerHigh` / `Highest` | `#EEF0F6` / `#E5E8F0` | |
| `onSurface` / `onSurfaceVariant` | `#1B2030` / `#596178` | |
| `outline` / `outlineVariant` | `#8A91A5` / `#E1E4EC` | ≥3:1 on cards |
| success (Taken) | `#1D7A4C` on `#E2F3E9` | `AppStatusColors` |
| warning (Skipped) | `#8F5200` on `#FFF0DA` | `AppStatusColors` |
| error | `#BA2F2A` | |

All text pairs meet WCAG AA. In widgets, use `context.colors`, `context.status` and `context.text`.

### Typography
- One family: **Outfit**, under the SIL OFL licence. Weights: 400 for body, 500 for labels and titles, 600 for headlines.
- Scale: displaySmall 32, headlineMedium 28, headlineSmall 24, titleLarge 20, titleMedium 17, titleSmall 15, bodyLarge 16, bodyMedium 15, bodySmall 13, labelLarge 15, labelMedium 13, labelSmall 12. Nothing smaller than 12.

### Tokens
- **Spacing:** 4, 8, 12, 16, 24, 32 and 48, plus a page gutter of 20.
- **Radius:** 8, 12, 16 (cards) and 28 (dialogs, sheets).
- **Sizes:** buttons are 52 tall, tap targets are at least 48, and content is at most 560 wide (`ContentWidth`).

### Rules
- Status is never shown by colour alone. Always pair an icon with text.
- Use rounded Material icons.
- Use `ChoiceGroup` instead of `SegmentedButton`, which overflows at large text sizes.
- Icon-only controls need a localized tooltip or label.

### Bottom navigation (`AppTabBar`, `lib/core/widgets/app_tab_bar.dart`)

The bar is a **floating frosted-glass pill**. It was chosen after researching the iOS 26 tab bar (floating, Liquid Glass, capsule highlight), Material 3 Expressive (a shorter 64dp bar), and the industry move to floating pills (Google Photos, Oura).

**Shape and material:**
- 64dp of content inside a 6dp inset.
- Stadium shape with 16dp side margins and a maximum width of 440dp, centred on tablets.
- `surfaceContainerLowest` at 86% opacity over a 20σ backdrop blur, with an `outlineVariant` hairline and a soft shadow.

**Placement:**
- The bar sits directly above the iOS home indicator or Android gesture bar (`viewPadding.bottom`), or 12dp above the screen edge when there is none.
- The shell uses `Scaffold(extendBody: true)`, so content scrolls *behind* the glass.

**Selected tab:**
- A `primary` capsule slides between tabs (`AnimatedAlign`, `AlignmentDirectional` so it follows RTL, `easeOutCubic`, **150 ms, no overshoot**). It lands together with the content cross-fade.
- The icon (outlined to filled) and the label (weight 600, colour `onPrimary`) switch **instantly**, on the first frame, like the iOS tab bar. Contrast is AA.
- **Responsiveness is a requirement.** On the first frame after a tap, the filled icon, the new tab and the capsule's new target are all in place; this is tested. Don't reintroduce delayed or overshooting animations here. A 300 ms `easeOutBack` capsule and an icon that scaled in from 70% made selection look late compared with the content, and users reported it as a delay.

**Rules:**
- **Labels are always visible.** Text scale clamps at 1.3× inside the bar so it never overflows.
- **Never icon-only**, and tabs are never disabled or hidden (HIG).
- **Semantics:** each tab is one button with its label, the hint "Tab x of 3", `selected`, and an explicit `onTap` (child semantics are excluded, so the tap action must be declared).
- **No haptics** on tab switches; the motion skill says routine navigation shouldn't vibrate.
- **Reduced motion:** the capsule and icon change instantly.
- The tab *content* switch (`AnimatedBranchContainer`) is separate: a 150 ms cross-fade (see §6).

**Using it in screens (required):**
- Every scrolling screen inside the shell adds **`context.bottomBarInset`** (`MediaQuery.paddingOf(context).bottom`) to its bottom padding, so the last item scrolls clear of the bar.
- A FAB inside a tab is wrapped in `Padding(bottom: context.bottomBarInset)`, because Scaffold positions FABs from the system safe area only.
- Tests: `test/core/app_tab_bar_test.dart` covers:
  - margins and the home indicator
  - tablet width
  - labels and semantics
  - the sliding capsule
  - reduced motion
  - RTL
  - 200% text
  - content and the FAB staying clear of the bar

### App-level assets
- The in-app splash is designed.
- The native launch screens are deliberately left as Flutter defaults, as the original prompt asked. App icons are not designed yet (§10).

---

## 6. Motion (skill: flutter-motion-animation)

- **Tokens:** short 150 ms, medium 300 ms and long 500 ms, with the `enter`, `exit` and `emphasized` curves. **Always use `AppMotion.of(context, …)`**, which returns zero when reduced motion is on.
- **Screen transitions** (`lib/core/navigation/app_transitions.dart`). Never leave a screen change un-animated.

  **One transition for every screen change.** The Inventory → Add medicine transition is the standard.

  | Change | Pattern | Where |
  | --- | --- | --- |
  | **Every screen navigation**: splash → walkthrough → welcome → home, list → detail, Add/Edit medicine, licenses, not found, and all back navigation | **Platform push**: Android `PredictiveBackPageTransitionsBuilder` (zoom plus predictive back), iOS `CupertinoPageTransitionsBuilder` (slide plus edge swipe-back) | `AppTheme.pageTransitionsTheme`, built by **`AppPageRoute`**, the router's `defaultRouteType` |
  | Bottom-tab switch (kept separate on purpose) | **150 ms cross-fade**. The new tab is visible from the first frame, with no delayed phase and no scaling, the same with reduced motion. Every tab stays mounted, so its state is kept. | `AnimatedBranchContainer` inside `AutoTabsRouter.builder` |

  **Tab switches must feel instant** (iOS doesn't animate them at all). A 300 ms fade-through with a scaled entry and a frame-clamped clock made the new tab half-visible only after ~144 ms (~250 ms on slow frames), and users reported it as slow. Measured now: half-visible after 32 ms and done at 144 ms at 60 fps. With 50 ms frames, it is visible on the first frame and done at 150 ms. Don't lengthen it, delay the incoming tab, scale the whole tab, or frame-clamp it.

  Screen routes follow the OS reduced-motion setting exactly as Add medicine does. Add medicine alone is `fullscreenDialog: true`, which on iOS makes it slide up as a modal; that is intended.

  **Adding a screen:** register it as a plain `AutoRoute` so it gets the default `AppPageRoute`. For an imperative push (e.g. `LicensePage`), use `Navigator.push(AppPageRoute(...))`. Never use `CustomRoute`, `MaterialPageRoute`, `PageRouteBuilder` or `showLicensePage`. `test/core/transitions_test.dart` ("every screen uses the same transition as Add medicine") checks every screen.

  **Slow frames must never skip a transition.** Flutter animations are time-based, and the first frame of a transition also builds the new screen. If that frame is slow (a screen's first build, which is much slower in debug builds), the next timestamp is already past the end, and the screen appears with no animation. Every screen-transition and entrance controller therefore uses **`FrameClampedTickerProvider`** (`lib/core/motion/`), which advances at most 34 ms per frame: a slow frame slows the animation briefly instead of skipping it, and timing is unchanged at normal frame rates.
  - It is already wired into `AppPageRoute`, the splash intro and `TopSnackbar`. **Not** into tab switches: those must finish on time, so a slow frame completes them sooner instead of stretching them (tested in "a slow frame finishes a tab switch on time").
  - New routes must use the router's default route type (`AppPageRoute`). Never construct `MaterialPageRoute` or `PageRouteBuilder` directly.
  - New entrance animations use `AnimationController(vsync: FrameClampedTickerProvider(this), …)`.
  - Regression tests: "a slow first frame does not skip the transition" in `test/core/transitions_test.dart`.

  When the OS disables animations (Android "Remove animations", or transition animation scale Off in developer options; iOS Reduce Motion), Flutter cuts every normal `AnimationController` to 5% of its length. `AnimatedBranchContainer` uses `AnimationBehavior.preserve` so the short tab cross-fade still plays. Screen transitions (`AppPageRoute`) follow the OS setting.
- **Also used:**
  - a Hero on the medicine thumbnail from the inventory list to its detail (`MedicineBadge.heroTag`; only those two screens use it, so tags stay unique)
  - a cross-fade when a dose status chip changes
  - the progress ring tween
  - the top snackbar slide
  - the onboarding page and dot animation
  - splash scale and fade
- **Haptics:** only `HapticFeedback.lightImpact()` when a dose is logged.
- No skeletons, because all data is in memory and nothing loads.

---

## 7. Common widgets and utilities

### Shared widgets (`lib/core/widgets/widgets.dart`): use these, don't rebuild them

| Need | Widget |
| --- | --- |
| Any top app bar | `AppToolbar` |
| Bottom navigation | **`AppTabBar`** with `AppTabItem`s (see §5 "Bottom navigation"); add `context.bottomBarInset` to scrolling content in tabs |
| Any button | `AppButton` (primary), `.tonal`, `.secondary`, `.text`, with options `icon`, `expand`, `loading`, `compact`, `destructive` (error-coloured; use with secondary or text) |
| Swipe actions on a card | `Slidable` (flutter_slidable) with an `endActionPane` of **`SwipeAction`** (themed, same radius as `AppCard`). Wrap the list in `SlidableAutoCloseBehavior`, and also expose each action as a `CustomSemanticsAction` inside a `MergeSemantics` with the card. |
| Feedback | **`TopSnackbar.show(...)`**: slides in from the top, closes with ✕ or a swipe up, or times out. Only one shows at a time and it respects reduced motion. **Never use `ScaffoldMessenger` or `SnackBar`.** |
| Dialogs | `AppDialogs.info` and `AppDialogs.confirm` |
| Inputs | `AppTextField` (a `TextField`, with no validator or error support by design); `ChoiceGroup<T>` for single choices |
| Layout and content | `AppCard`, `ActionRow`, `InfoRow`, `SectionHeader`, `ContentWidth`, `EmptyState`, `StatusChip`, `ProgressRing`, `PrototypeNotice`, `IconBadge`, `AppAvatar`, `BrandLogo`, `FeatureArt` |

If a pattern appears twice, promote it to `core/widgets/` and add it to this table.

**Form validation:**
- Fields never show inline or red errors.
- Validate when the user taps Save.
- Show **only the first problem**, in on-screen order, with `TopSnackbar.show(..., tone: SnackTone.warning)`. Phrase it as a request, e.g. "Please enter a medicine name."
- Model problems as an enum on the form state (e.g. `MedicineFormIssue`) and map it to one ICU `select` message (e.g. `medicineFormIssue`).
- Don't use `Form`/`GlobalKey<FormState>`, `validator:` or `errorText:`.

### Utilities: `lib/core/utils/` (import the `utils.dart` barrel)
These are UI- and language-agnostic helpers: `MediaPicker` (`media_picker.dart`), `DayUtils` (`day_utils.dart`) and `Validators` (`validators.dart`). Tests live in `test/core/utils/`.
- **All utilities live inside `lib/`.** Never create a separate Dart package for them.
- Utilities contain no widgets, theme or user-facing text. They return typed codes instead.

### Image picking: one picker for both platforms
- **Only `MediaPicker` / `PlatformMediaPicker`**, which wraps `image_picker`. Screens and notifiers get it through `mediaPickerProvider`.
- **Android:** always uses the system **Photo Picker** (`PickVisualMedia`). `PlatformMediaPicker.configure()` in `main` forces it on Android 15 and below.
  - Never request `READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO` or `READ_EXTERNAL_STORAGE`. The manifest removes them with `tools:node="remove"`.
- **iOS:** uses PHPicker. `NSPhotoLibraryUsageDescription` is set for the iOS 13 fallback.
- **Gallery only**, with images capped at 1024 px and kept as in-memory bytes.
- Results are typed: `MediaPicked`, `MediaPickCancelled` or `MediaPickFailed(MediaPickFailure)`.

---

## 8. UX specification (skill: flutter-ui-ux-design)

### Primary flows
1. **First run:** Splash (about 1.2 s; tap to skip) → Onboarding (3 pages; Skip available) → Welcome.
   - Google or Apple → dialog explaining the sign-in is simulated → Today. Cancel stays on Welcome.
   - Continue as guest → Today, in guest mode.
2. **Log a dose:** Today → pick a day (±14 days) → Taken or Skip on a card. The status chip and progress update, a top snackbar appears with Undo, and the card shows its own Undo.
3. **Add a medicine:** Inventory FAB, or the Add button in a day's empty state → form → Save. A snackbar confirms and the medicine appears in the list and on matching days.
4. **Edit:** Inventory → card → Detail → **Edit medicine** button → Save. (The detail toolbar has no actions.) Alternatively, swipe a card right-to-left → **Edit**.
5. **Delete:** use the Detail **Delete medicine** button, or swipe a card right-to-left → **Delete**. Both use `confirmAndDeleteMedicine`:
   - A confirm dialog ("Delete Brevora?") appears first.
   - The medicine is removed from the inventory and from every day's plan.
   - The detail screen, if open, pops back to the list.
   - A snackbar ("Brevora deleted.") offers **Undo**, which restores the medicine at the same position along with its dose logs, which are kept.
   - Deleting the last medicine shows the inventory empty state.
6. **Leave the form:** Cancel or system back with changes asks "Discard changes?" first. With no changes, it closes immediately.
7. **Log out:** Profile → Log out → confirm → Welcome, with all data reset.

### Guest mode

A guest **has no data**: no medicines and no dose logs. `MedicinesController.build` returns an empty list for guests, and only signed-in users get the sample medicines. So a guest sees only empty states:
- Today: "No doses scheduled for this day" and "Nothing scheduled"
- Inventory: "No medicines yet"

A guest:
- **Can** browse the screens, pick dates on Today, and use Profile.
- **Cannot** add, edit or delete medicines, which means they also can't open the medicine form or pick photos.

**How it is enforced:**
- **One rule:** `SessionState.canManageMedicines`, also exposed as `canManageMedicinesProvider`, is false for guests.
- **UI:** every add/edit/delete entry point calls **`runIfCanManageMedicines(context, ref, action)`**. That covers the Inventory FAB, the empty-state Add buttons (Inventory and Today), swipe Edit/Delete and their screen-reader actions, and the detail Edit/Delete buttons.
  - Signed-in users run the action directly.
  - Guests get **`showSignInRequired`**: an **alert in the same style as the logout confirmation** (`AppDialogs.confirm`), with a lock icon, "Sign in to manage medicines", "You're using the app as a guest. Sign in to add, edit or delete medicines.", and **Cancel** / **Sign in** buttons. Do not use a bottom sheet.
  - **Sign in** calls `SessionController.requestSignIn()`, which returns to **Welcome** to pick Google or Apple. The tapped action is **not** resumed afterwards. "Continue as guest" on Welcome returns to guest mode.
- **Data resets:** `SessionController` owns them. Every `signIn` and `logout` invalidates the medicines, logs and selected date, so each identity starts fresh: sample data for Google/Apple, empty for a guest. `MedicinesController` only `ref.read`s the session; watching it would create a circular dependency with those resets.
  - The **Sign in** button in the Profile card calls `requestSignIn()` directly, with no alert.
- **Router:** `SessionGuard` blocks guests from `MemberOnlyRoutes` (Add and Edit), including deep links. The guest stays where they are.
- **New features:** any new medicine-changing action must go through `runIfCanManageMedicines`, and any new route that changes data must be added to `MemberOnlyRoutes`.

**What guests see:**
- Today greets them without a name ("Good morning").
- Inventory shows its plain empty state (no guest banner, removed by user decision) and no FAB. The Add button there opens the sign-in alert.
- Profile shows a person avatar, "Guest", "Browsing as a guest", a "Guest mode" chip and a **Sign in** button. There is **no logout row** for guests; Sign in is the way out.

### Screen states

| Screen | States |
| --- | --- |
| Today | today or another day; doses or empty ("Nothing scheduled" plus Add); past, today or future (future doses can't be logged); each dose Taken / Skipped / Upcoming / Not logged / Scheduled |
| Progress | has doses (headline, detail, caption) or none ("No doses scheduled for this day", "–") |
| Inventory | list (with a swipe hint), a card swiped open (Edit/Delete; only one open at a time), or empty (illustration plus Add, no FAB), including after deleting every medicine |
| Detail | found (bottom Edit medicine / Delete medicine buttons; no toolbar actions), deleting (keeps showing the medicine while animating out), or not found (Back to inventory) |
| Form | pristine, dirty, invalid on Save (a warning snackbar with the first problem; no inline errors), picking photo (loading), photo failure (snackbar), weekly (weekday chips), monthly (day 1–28) |
| Router | unknown link → Not found; signed out → flow stage |

### Acceptance criteria
- The progress headline reads exactly "{taken} of {total} scheduled dose(s) logged as taken — {percent}". Percent is `taken×100 ~/ total`; with zero scheduled there is no percentage.
- The 20% case: 1 of 5 doses taken on Monday 16 Nov 2026 (test clock).
- Selecting a date updates the label, the section title, the cards and the progress.
- Undo restores the previous log exactly.
- Deleting a medicine always asks first, removes it from the inventory and from every day's plan, and offers Undo, which restores its position and logs. Deleting all medicines shows "No medicines yet" and the Today empty state.
- Logout resets medicines, logs and the selected date; signing in again shows 0 logged.
- Guest mode:
  - "Continue as guest" enters with no data: empty Today and Inventory.
  - Every add, edit or delete attempt shows the sign-in alert.
  - Cancel changes nothing.
  - Sign in goes to Welcome; signing in there loads the sample data and removes the restrictions.
  - Guest Profile has no logout row.
  - Guest deep links to Add or Edit are blocked.
- Form validation:
  - name: required, at most 40 characters
  - at least one time, at most 6
  - quantity: whole number from 0 to 99999
  - the unit follows the type until the user picks one
  - Save with problems shows a snackbar for the first one, in that order ("Please enter a medicine name.", "Please add at least one schedule time.", "Please enter the quantity in stock.", …); fields show no inline errors
- No overflow at 320×568, at 200% text, in landscape or in RTL. Tap targets are at least 48 dp. Text contrast meets AA (the app is light only).

### Sample data
All names are invented.

| Medicine | Type | Schedule | Times | Stock |
| --- | --- | --- | --- | --- |
| Brevora | tablet | daily | 08:00, 20:00 | 42 |
| Ceralin | capsule | daily | 13:00 | 18 |
| Omnivy | liquid | daily | 21:30 | 150 mL |
| Dulvexa | tablet | weekly, Monday | 09:00 | 6 |
| Novaxil | other | monthly, day 1 | 10:00 | 2 units |

The simulated Google/Apple user is Jordan Ellis, `jordan.ellis@example.com`. A guest has no profile.

---

## 9. Quality gates (skills: flutter-testing-quality, flutter-responsive-performance)

```bash
export PATH=/opt/flutter/bin:$PATH
dart run build_runner build && flutter gen-l10n   # after model or ARB changes
dart format lib test packages
flutter analyze                                    # must report "No issues found"
flutter test
```

**Test layout:**
- **Unit tests:** domain rules (`dose_schedule_test`), notifier state transitions (`session_controller_test`, `today_controller_test`, `medicine_form_controller_test`), navigation policy (`navigation_policy_test`), l10n (plurals and selects, required descriptions, the **hard-coded string guard**), and utilities (`test/core/utils/`).
- **Widget tests:** the full flow, Today, Inventory, Profile, guard, deep links (including a launch link via `pumpApp(launchLocation:)`) and back behavior (`router_test`), screen transitions (`transitions_test`), and the top snackbar.
- **`accessibility_layout_test.dart`:** every screen at 5 sizes including 200% text, in RTL, with tap-target, label and contrast checks for signed-in and guest users, with the keyboard open, and with reduced motion. **Add every new screen to it.**

**Test conventions:**
- Use the harness in `test/helpers/test_app.dart`: `pumpApp(...)` (signed in with simulated Google by default; `guest: true` for guest mode; `signedIn: false` to start at the splash; `settle: false` to inspect the launch frame by frame), `routerOf(tester)` and `testContainer()`. The clock is pinned to **Thu 2026-11-19 10:30**.
- **Pump at 60 Hz** when timing matters: `tester.pumpAndSettle(frame60Hz)`, or `pumpFrames(...)` in the transitions test. A single large `pump(Duration)` is a *slow frame*, so transitions deliberately advance only 34 ms in it.
- Give interactive widgets stable `ValueKey`s (`nav-*`, `dose-taken-<id>`, `field-*`, `row-*`, …).
- The top snackbar overlays the top of the screen. Call `TopSnackbar.dismiss()` before tapping anything under it.

**Performance:** use lazy lists (`ListView.separated`, `SliverList.separated`), `cacheWidth` on images and `const` widgets, and keep provider selections narrow.

**Reporting:** never claim device validation that wasn't done. Widget tests run on the host machine.

---

## 10. Known placeholders

- `BrandLogo` (a capsule drawn in code) and `FeatureArt` (scenes built from shapes) stand in for real vector or illustration assets.
- The Google "G" is a text placeholder.
- Native launch screens and app icons are Flutter defaults.
- The application ID is `com.example.demo_project`. Changing it is release configuration, which is out of scope.
- No reference screenshots were supplied for the splash and onboarding. When they arrive, align `SplashScreen`, `OnboardingScreen` and `FeatureArt` with them.

---

## 11. Skill compliance map

| Skill | How it applies here |
| --- | --- |
| flutter-architecture | MVI with Riverpod and Freezed (§3). **Routing uses `auto_route` instead of the skill's go_router, by user decision** (generated typed routes, guards, nested tabs, deep-link fallback). **Out of scope by boundary:** Dio, interceptors and persistence (no backend or storage allowed). json_serializable is unused because there is no JSON. |
| flutter-localization | ARB, gen-l10n, intl and ICU, with no literals and RTL-safe layout (§4). |
| flutter-visual-design-system | Tokens, semantic roles and M3 component themes (§5). **Light mode only, by user decision.** No dark theme. |
| flutter-ui-ux-design | Flows, states and acceptance criteria (§8). |
| flutter-motion-animation | Motion tokens, reduced motion, Hero, transitions and haptics (§6). |
| flutter-responsive-performance | Constraint-based layouts, lazy lists and the size/text/RTL matrix (§9). |
| flutter-testing-quality | Unit, widget and flow tests plus a11y checks (§9). |
| flutter-figma-mobile | No Figma supplied. Follow it when frames are provided. |
| flutter-release-deployment | Out of scope: the boundary forbids signing, release and store changes. |

## 12. Decision log

| Date | Decision |
| --- | --- |
| 2026-11-19 | Prototype built: Riverpod, Outfit, brand blue kept and the neon accent dropped, `TopSnackbar`, `doseza_utils` with a Photo Picker–only `MediaPicker`. |
| 2026-11-20 | **Guest banner removed (user edit):** the Inventory guest banner and its Sign in button were removed. The leftover unused variable, import and the `inventoryGuestBanner` string were cleaned up. Guests sign in via the Profile card or the sign-in alert. |
| 2026-11-20 | **Tab selection felt delayed (user report):** the capsule went from 300 ms `easeOutBack` (overshoot, settled at 300 ms) to 150 ms `easeOutCubic`. The icon and label now switch instantly instead of a scale/fade, and each tab paints into a `RepaintBoundary` during the cross-fade (animation frames went from ~2 ms to ~1 ms on the host). Verified that frame 1 already shows the new state. Also: the Today prototype notice was removed (user edit), so the dose list and empty state now carry the bottom clearance for the floating bar. |
| 2026-11-20 | **Faster tab switching (user report: tabs took too long):** the tab content switch went from a 300 ms fade-through (outgoing first, delayed and scaled incoming, frame-clamped) to an unclamped 150 ms cross-fade. Measured: fully visible at 144 ms (was 304 ms) at 60 fps, and 150 ms (was 450 ms) with 50 ms frames. |
| 2026-11-20 | **New bottom navigation (user request, researched):** replaced the stock `NavigationBar` with `AppTabBar`, a floating glass pill with a sliding brand capsule, outlined-to-filled icons and always-visible labels (iOS 26 / M3 Expressive / floating-pill research). `extendBody` shell, `bottomBarInset` padding, FAB lifted above the bar, tab semantics with an explicit tap action, no navigation haptics. Removed `navigationBarTheme`. |
| 2026-11-20 | **Guests have no data and no logout row (user request):** guests start with empty medicines and logs (empty states everywhere), and only signed-in users get the sample data. Removed the guest "Exit guest mode" row and its strings; Sign in in the profile card is the way out. Sign-in/logout resets now live in `SessionController` (fixes a circular provider dependency). The detail toolbar Edit/Delete icons were removed (user edit); the bottom buttons remain. |
| 2026-11-20 | **Guest sign-in prompt is an alert (user request):** replaced the bottom sheet with an `AppDialogs.confirm` alert (Cancel / Sign in) like logout. Sign in goes to Welcome via `requestSignIn()` and keeps session data; the in-place `upgradeGuest` was removed. |
| 2026-11-19 | **Light only, and guest mode (user requests):** dark theme, dark palette and Android `values-night` removed; `ThemeMode.light` pinned; iOS `UIUserInterfaceStyle = Light`. "Continue as demo" became **"Continue as guest"**, with restrictions: guests view and log doses but cannot add, edit or delete medicines (`canManageMedicines`, `runIfCanManageMedicines`, sign-in prompt with an in-place upgrade, `MemberOnlyRoutes` guard). Guest profile and greeting added. |
| 2026-11-19 | **Delete medicine (user request):** Delete on the detail screen (toolbar and button) and a right-to-left swipe on inventory cards revealing Edit and Delete (`flutter_slidable` 5, `SwipeAction`). One shared confirm → delete → Undo flow, screen-reader custom actions, and the existing empty state once the list is empty. Added `AppButton.destructive`. |
| 2026-11-19 | **Form errors via snackbar (user request):** no inline or red field errors. Save shows the first problem (name → times → quantity) in the top snackbar. Removed `Form`, validators, the `submitted` state and six error strings (now one `medicineFormIssue` message); `AppTextField` is a plain `TextField`. |
| 2026-11-19 | **One screen transition app-wide (user request):** every screen navigation now uses the Inventory → Add medicine transition (`AppPageRoute`, platform push). The flow screens and Home switched from fade-through, `FadeThroughRoute` was removed, and licenses moved off `showLicensePage`. Bottom-tab fade-through is unchanged. |
| 2026-11-19 | Some transitions showed no animation, inconsistently: a slow first frame (first build of a screen) pushed the time-based animation past its end. All transition and entrance clocks are now frame-clamped (`FrameClampedTickerProvider`), drill-down routes go through `AppPageRoute`, and tests pump at 60 Hz. |
| 2026-11-19 | **User decisions:** routing moved from go_router to **auto_route** (`AppRouter`, generated typed routes, `SessionGuard`, `AutoTabsRouter`), and the `packages/doseza_utils` package was folded into **`lib/core/utils/`**, because all code lives in `lib/`. Generator versions pinned to a shared analyzer (§2). |
| 2026-11-19 | Screen transitions: tabs used to switch instantly (`indexedStack` has no animation) and the flow cross-fade was too subtle, and instant under OS reduced motion. Now fade-through for peers and tabs, explicit platform push for drill-down, and a 150 ms dissolve (preserved) under reduced motion. Tests in `test/core/transitions_test.dart`. |
| 2026-11-19 | Skills applied fully: **go_router 18** replaces stage-switching (an earlier note claiming it imports the deprecated Material library came from a stale cached 14.x and was wrong); **Freezed** models and state; **MVI form controller**; **full localization** (ARB/ICU, typed codes from the utils package); Hero and status animation; lazy lists; router, notifier and l10n tests; RTL smoke tests. Logout no longer restores the previous screen on next sign-in. |
