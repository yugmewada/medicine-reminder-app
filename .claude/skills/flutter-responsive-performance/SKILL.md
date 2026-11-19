---
name: flutter-responsive-performance
description: Improve responsive behavior, accessibility, rendering efficiency, startup, and runtime performance in Flutter apps. Use when layouts overflow, screens must adapt across Android/iOS sizes, scrolling is janky, or performance needs profiling and optimization.
---

# Flutter Responsive UI and Performance

Establish a measurable baseline, fix root causes, and retain visual and accessibility quality across device sizes.

## Responsive implementation

- Build from constraints, not assumptions about a specific phone model. Use `SafeArea`, `MediaQuery` where appropriate, `LayoutBuilder`, flexible widgets, and scrollable layouts.
- Test compact and large phones, portrait/landscape when relevant, keyboard-open states, display cutouts, text scaling, and localization expansion.
- Avoid fixed heights for text-heavy content. Preserve accessible text scaling and use semantic labels, sufficient contrast, and usable touch targets.
- Use adaptive navigation/layout only where product design calls for it; avoid arbitrary breakpoints based on individual devices.

## Performance workflow

1. Reproduce the issue and record a baseline on representative hardware/build modes. Use Flutter DevTools, performance timeline, memory tools, and frame/raster metrics as appropriate.
2. Identify the bottleneck before editing. Separate UI-thread, raster/GPU, network, database, and memory causes.
3. Reduce unnecessary rebuilds by narrowing state scope and using stable widget composition. Add `const` where applicable; do not use it as a substitute for profiling.
4. Use lazy lists/grids for long collections, stable keys where identity matters, and bounded image sizes with caching appropriate to the product.
5. Avoid synchronous heavy work on the UI isolate. Move CPU-intensive work to an isolate only when profiling shows it is warranted; keep isolate messaging and lifecycle simple.
6. Cancel or dispose controllers, streams, timers, subscriptions, and animations correctly. Prevent repeated requests and large retained object graphs.
7. Review network payloads, query patterns, asset sizes, startup initialization, and expensive layout/paint operations. Optimize only after measurement.
8. Recheck visual correctness, functionality, accessibility, and memory behavior after each performance change.

## Guardrails

Do not mask jank by deleting meaningful UI, lowering accessibility, or disabling validation. Avoid premature caching, broad state rewrites, and speculative micro-optimizations. Preserve behavior and compare before/after measurements when possible.

## Completion checks

Run format, analyzer, tests, and a production/profile-mode check when available. Record device, build mode, reproduction steps, baseline and post-change metrics, and any limitations. Never claim a performance improvement without evidence.
