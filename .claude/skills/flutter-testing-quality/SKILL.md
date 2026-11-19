---
name: flutter-testing-quality
description: Test, debug, and optimize Flutter applications for Android and iOS. Use for unit, widget, integration, regression, accessibility, platform validation, bug diagnosis, or pre-release quality checks.
---

# Flutter Testing and Quality

Choose tests that protect user-visible behavior and critical domain rules. Reproduce failures, isolate causes, and verify fixes on the narrowest useful layer plus relevant end-to-end paths.

## Test strategy

- **Unit tests:** domain rules, validation, schedule calculations, serialization, repository behavior, and state transitions.
- **Widget tests:** rendering, interaction, validation messages, loading/error/empty states, semantics, and responsive behavior under controlled constraints.
- **Integration tests:** critical user journeys across navigation, authentication, persistence, APIs, and notifications where test infrastructure permits.
- Use deterministic fakes, fixtures, and a controllable clock. Keep tests independent of production services and user accounts.
- Test failure conditions, not only happy paths: network loss, timeouts, malformed responses, permission denial, expired sessions, empty data, and duplicate actions.

## Debugging workflow

1. Capture exact steps, expected versus actual behavior, environment, OS/device, Flutter/Dart version, and logs that can be safely shared.
2. Reproduce with the smallest test or sample; inspect the stack trace and state/data flow. Distinguish app bug, platform configuration, dependency issue, backend contract, and environment issue.
3. Form one testable hypothesis at a time. Make the smallest fix, add a regression test, and avoid unrelated refactors.
4. Verify the fix on impacted platforms and nearby edge cases. Remove temporary diagnostics and ensure no sensitive data is logged.
5. Summarize root cause, changed files, tests run, and known limitations.

## Quality gates

At minimum, run `dart format` on changed Dart files, `flutter analyze`, and relevant automated tests. For release candidates, validate Android and iOS build configuration, permissions, icons/assets, deep links if used, secure environment configuration, and signing setup without exposing signing material. Use real devices for behavior that simulators cannot reliably validate, including notification delivery, biometrics, camera, and vendor-specific power management.

Do not claim all-platform validation when only one platform was tested. Do not suppress analyzer warnings or weaken tests merely to obtain a green run; explain justified exceptions.
