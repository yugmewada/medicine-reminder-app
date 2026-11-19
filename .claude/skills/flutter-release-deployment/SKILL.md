---
name: flutter-release-deployment
description: Prepare Flutter apps for Android and iOS release, including versioning, signing, app bundles, TestFlight, store assets, obfuscation, and pre-release verification. Use for production build configuration, release checklists, CI release pipelines, or store submission preparation.
---

# Flutter Release and Deployment

Prepare reproducible, secure release artifacts for Android and iOS. Inspect the project and current platform/toolchain requirements before changing configuration. Separate building an artifact from publishing it: do not upload, submit, release, or change a live listing without explicit authorization for that external action.

## Workflow

1. Inspect Flutter/Dart versions, repository state, flavors/environments, app identifiers, platform build files, dependency constraints, CI configuration, versioning convention, signing setup, and prior release notes.
2. Confirm target platforms, environment/flavor, intended version/build number, minimum OS support, release channel, permissions/features, signing owner, and whether the requested task is build-only or includes store submission.
3. Run code generation if applicable, formatting, static analysis, unit/widget/integration tests, and platform-specific checks. Resolve or report failures; do not hide warnings by weakening analysis or tests.
4. Verify production configuration: API endpoints, feature flags, privacy settings, app display name, bundle/application IDs, deep links, permissions, icons, launch screens, and logging. Ensure no development credentials, debug menus, or test endpoints leak into production.
5. Configure Android and iOS signing securely, create release artifacts, verify metadata and symbols, and record artifact locations/checksums as appropriate.
6. Review store assets and release metadata, then present a pre-release checklist. Ask for confirmation before any public submission, phased rollout, or production release action.

## Versioning and build numbers

- Follow the repository's existing version convention and store requirements. In Flutter, update `version` and build suffix/number in `pubspec.yaml` deliberately (or the established CI source of truth).
- Ensure build numbers increase appropriately for each platform and release channel. Keep version name, build number, changelog, and store metadata aligned.
- Build with the intended flavor and release configuration; verify the embedded environment and app identifiers rather than assuming the command selected them correctly.

## Android release

- Produce the requested release artifact, normally an Android App Bundle (`.aab`) for Play distribution unless the project/store workflow specifies otherwise. Validate package ID, signing configuration, min/target SDK requirements, manifest permissions, network security, and product flavors.
- Keep keystores, passwords, upload keys, and service-account credentials out of source control and logs. Use CI secret storage or secure local configuration. Never print secrets or replace keys without explicit direction.
- Confirm the artifact is signed with the intended upload/release key and that Play App Signing expectations are understood. A local debug build is not a release artifact.
- Preserve and securely store the matching obfuscation symbol files and mapping files for crash diagnostics. Do not discard files needed to symbolicate production crashes.

## iOS release and TestFlight

- Verify bundle identifier, signing team, certificates/profiles or automatic signing setup, entitlements, capabilities, privacy usage descriptions, deployment target, and version/build values.
- Use the project's supported Xcode/Flutter release workflow to archive/export an IPA or upload to TestFlight as requested. Check that the archive uses the intended scheme/configuration and distribution signing.
- Do not request, expose, or commit Apple account passwords, signing private keys, certificates, or provisioning secrets. Prefer secure CI secret management and documented team-owned signing processes.
- Treat TestFlight upload, external testing, App Store submission, and phased release as separate actions; get explicit approval before performing any upload or public release.
- Retain dSYM files and other required symbol artifacts for crash reporting and debugging.

## Store assets and metadata

Check current store specifications rather than assuming fixed dimensions or policies. Confirm app icon, screenshots for required device classes, localized listing text, privacy/support URLs, age/content ratings, privacy disclosures, and release notes. Keep screenshots representative of the actual app and avoid fabricating features, testimonials, or results. For localized listings, coordinate with the localization skill and have translations reviewed as needed.

## Obfuscation and diagnostics

- Use Dart obfuscation only where appropriate for the release workflow; it is not encryption and does not protect embedded secrets. Keep symbol output (for example, obfuscation symbol maps) and platform debug symbols securely associated with the exact release build.
- Verify crash reporting configuration and privacy-safe logging. Do not log credentials, health information, or sensitive user payloads.
- Record Flutter/Dart/Xcode/Android Gradle Plugin versions and build parameters needed to reproduce the artifact.

## Pre-release checklist

- [ ] Correct release branch/commit, version, build number, flavor, and application identifiers.
- [ ] Production endpoints and non-development configuration verified; no client-embedded server secrets.
- [ ] Formatting, analyzer, tests, and platform builds pass or exceptions are documented.
- [ ] Android bundle is release-signed; iOS archive uses intended distribution signing.
- [ ] Permissions, privacy descriptions, entitlements, deep links, and minimum OS settings reviewed.
- [ ] App icon, screenshots, store metadata, privacy/support links, and release notes checked.
- [ ] Obfuscation mappings, dSYMs, and crash-symbol artifacts retained and matched to build.
- [ ] Smoke-tested on representative Android and iOS devices or simulators; limitations documented.
- [ ] Upload/submission/rollout action and audience are explicitly authorized before execution.

## Reporting

State exactly which artifacts were built, the version/build number, platform and flavor, checks performed, signing status (without exposing secrets), artifact/symbol locations, unresolved issues, and whether anything was uploaded or submitted. Never claim a release was published if only a local build was created.
