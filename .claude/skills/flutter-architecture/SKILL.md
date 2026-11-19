---
name: flutter-architecture
description: Design, scaffold, or refactor Flutter application architecture using MVI, Riverpod, go_router, Dio, Freezed/json_serializable, and appropriate local/secure storage. Use when structuring features, state, navigation, networking, models, persistence, or deep links in a Flutter app.
---

# Flutter Architecture: MVI + Riverpod

Build a maintainable Flutter application around unidirectional state flow. Use the requested stack—MVI, Riverpod, `go_router`, Dio, Freezed with `json_serializable`, and suitable persistence—while first inspecting and respecting the repository's existing structure and SDK constraints.

## Required first steps

1. Inspect `pubspec.yaml`, Flutter/Dart versions, app entry point, feature structure, dependency injection, routing, state management, API clients, models, storage, and tests.
2. Identify existing conventions and generated-code workflows. Reuse installed compatible packages and patterns; do not upgrade dependencies, replace architecture, or rewrite unrelated features without need.
3. Confirm app scope, API contract, authentication/session behavior, deep-link requirements, offline needs, storage lifetime, and flavor/environment setup. Clearly list assumptions where requirements are missing.
4. Plan one vertical feature slice and define boundaries before implementation. Keep the change incremental and testable.

## MVI and feature boundaries

Use a consistent unidirectional cycle:

**View → Intent/action → Riverpod notifier (MVI state holder) → use case/repository → data source → new immutable state → View**

- **View:** Render state and dispatch user intents. Keep business rules, network calls, and persistence out of widgets.
- **Intent:** Represent meaningful user actions, such as refresh, submit, select tab, or update profile. Use explicit methods or typed intent objects consistent with feature complexity; avoid ceremony for trivial screens.
- **State holder:** Use Riverpod `Notifier`/`AsyncNotifier` or the project's established equivalent to process intents and expose immutable state. Keep state transitions predictable and scoped to a feature.
- **State:** Model initial/loading/data/empty/error states explicitly. For screens with simultaneous data and operation status, use an immutable feature state with typed fields rather than a web of booleans that permit impossible combinations.
- **Domain/repository:** Put business rules and repository contracts outside widgets. Repositories abstract API/local sources and are injectable for testing.
- **Data sources:** Own Dio, serialization, and persistence details. Do not let UI depend on raw HTTP responses or database-specific records.

Use Riverpod providers for dependency wiring, lifecycle, and test overrides. Select the narrowest state needed by each widget to avoid unnecessary rebuilds. Do not create global mutable singleton state or pass `BuildContext` into repositories/domain logic.

## Suggested feature organization

Adapt this example to repository conventions rather than imposing it blindly:

```text
lib/
  app/
    app.dart
    router.dart
    providers.dart
  core/
    network/        # Dio setup, interceptors, typed failures
    storage/        # secure and ordinary storage adapters
    errors/         # domain-safe error mapping
  features/
    feature_name/
      data/         # DTOs, data sources, repository implementation
      domain/       # entities, repository contract, use cases (when useful)
      presentation/ # screens, widgets, MVI state/notifier
```

Avoid empty abstraction layers. Introduce use cases or separate domain entities when they clarify business rules, reuse, or testing—not simply to add files.

## Routing: go_router, deep links, and bottom-tab shell

- Use `go_router` for declarative routes, nested navigation, route parameters, and deep-link integration where compatible with the project.
- Define named routes and typed/validated path and query parameters where the current package/API allows it. Handle missing, malformed, expired, and unauthorized deep links with a safe destination and useful feedback.
- Keep route guards aligned with authentication state, but enforce authorization on the backend too. Avoid redirect loops; test signed-out, loading-session, signed-in, and expired-session cases.
- Use a `ShellRoute`/`StatefulShellRoute`-style structure for persistent bottom tabs when each tab should preserve its own navigation stack. Confirm expected back behavior, tab reselection behavior, and deep-link-to-tab behavior with product requirements.
- Keep route configuration centralized or organized by feature without creating circular imports. Do not make widgets manually parse full URLs.
- Test cold-start and warm-app deep links on Android and iOS, including query parameters and fallback routes, when platform configuration is in scope.

## Networking: Dio and interceptors

Create a configured Dio client in the data/core layer; inject it into data sources. Centralize base URL, connect/send/receive timeouts, content types, and environment configuration.

- **Authentication interceptor:** Read tokens via an injected secure-storage/session abstraction; attach authorization only to appropriate requests. Never hard-code tokens or secrets. Design refresh serialization/locking to prevent concurrent refresh storms. On failed refresh, clear/expire session safely and avoid infinite replay loops.
- **Logging interceptor:** Enable detailed logging only in development or explicitly safe environments. Redact authorization, cookies, personal/health data, and sensitive request/response fields. Never ship raw credential logging in production.
- **Retry behavior:** Retry only transient failures and safe/idempotent requests by default, with bounded attempts and backoff. Do not blindly retry non-idempotent writes; use server-supported idempotency keys when applicable. Respect cancellation and prevent retries after logout or request disposal.
- **Error mapping:** Convert `DioException` and response status codes into typed internal failures, then map those to concise, actionable, non-sensitive user-facing messages. Distinguish connectivity/timeouts, unauthorized, forbidden, validation, not-found, rate-limit, server, cancellation, and unknown cases as appropriate. Do not show raw server bodies or stack traces to users.
- Keep API DTO parsing and endpoint logic outside widgets. Handle malformed/empty responses explicitly and check API contracts before assuming status/body shapes.

## Models and code generation

- Use Freezed for immutable state/models and `json_serializable` integration for JSON DTOs where supported by the installed versions. Keep transport DTOs separate from domain types when their lifecycles/contracts differ.
- Configure `part` declarations and generation consistently with the project (for example `build_runner`). Do not hand-edit generated `.freezed.dart` or `.g.dart` files.
- Use explicit JSON keys and converters for dates, enums, and nested types. Treat missing/null/unknown fields according to the API contract; avoid unsafe force casts.
- Run the established generation command after model changes, inspect generated diffs, then format, analyze, and test.

## Persistence and secure storage

Choose storage by data type and lifecycle, not habit:

- `shared_preferences`: small, non-sensitive settings and simple flags. Never store passwords, access/refresh tokens, private keys, or sensitive health records here.
- Hive or Isar (or the project's existing local database): structured/offline data, querying, or larger records when justified. Assess migrations, encryption/access controls, schema evolution, concurrency, and backup behavior. Do not add a database dependency without a clear need.
- `flutter_secure_storage`: credentials/tokens or other small secrets, using platform-backed secure mechanisms. Minimize token lifetime and handle read/write failures. Secure storage does not make app authorization unnecessary.
- Define offline cache and synchronization policy explicitly: source of truth, conflict resolution, deletion propagation, and sign-out cleanup. Apply platform-appropriate protections to sensitive data and avoid logging it.

## Testing and completion

- Unit-test state transitions, validation, use cases, and error mapping with fakes.
- Test repositories/data sources with mocked Dio responses, including malformed JSON, timeouts, auth refresh, retry limits, cancellation, and HTTP errors.
- Widget-test rendering and user intents; override providers for deterministic states.
- Test router redirects, nested bottom-tab navigation, deep-link parsing, and back behavior.
- Test storage adapters and migrations without real user secrets.
- Run code generation, `dart format`, `flutter analyze`, and relevant tests. Report architecture choices, generated files, unverified platform behavior, and any API/security assumptions.

## Guardrails

Do not expose secrets in source, builds, logs, or repository history. Do not treat client-side route guards as authorization. Avoid retries that duplicate writes, unbounded provider lifetimes, domain logic in widgets, generated-file edits, and unnecessary package/architecture rewrites. Keep all abstractions proportionate to the feature.
