---
name: flutter-motion-animation
description: Add purposeful motion and micro-interactions to Flutter apps using implicit and explicit animations, route transitions, Hero effects, animated lists, skeleton loading, feedback, and reduced-motion support. Use when polishing screen transitions, loading states, gestures, or interaction feedback.
---

# Flutter Motion and Animation

Use motion to communicate state, hierarchy, continuity, and interaction—not as decoration. Keep animation smooth, accessible, interruptible, and consistent with the product's visual system.

## Workflow

1. Inspect Flutter/Dart version, existing theme and animation conventions, route setup, state management, target platforms, and accessibility requirements.
2. Identify the user purpose for each proposed animation: show a state change, preserve spatial context, provide feedback, or make loading progress clear. If it has no clear purpose, omit it.
3. Choose the simplest suitable mechanism: implicit animation for straightforward property changes; explicit controllers for orchestrated or gesture-driven sequences.
4. Define duration, curve, delay/stagger, begin/end values, and interruption behavior. Keep durations consistent with the product's motion language and test on actual screens.
5. Respect reduced-motion settings and provide a useful static/shortened alternative. Ensure animations do not block essential actions or hide state from assistive technology.
6. Verify performance, lifecycle cleanup, rapid repeated interactions, route changes, and reduced-motion behavior. Run relevant tests and report limitations.

## Motion tokens

Use shared motion constants or a theme extension when the app has repeated timing/curve patterns. Suggested starting points from the product specification are short **150 ms**, medium **300 ms**, and long **500 ms**, with curves such as `Curves.easeOutCubic` for entering/settling and `Curves.easeInOutCubicEmphasized` for emphasized transitions where supported. Treat these as defaults to tune—not mandatory values for every animation.

- Keep micro-interactions brief and responsive. Longer motion should explain a meaningful transition or staged sequence.
- Choose curves based on perceived movement; avoid abrupt starts/stops unless intentional.
- Avoid stacking delays and animations in ways that make the app feel slow.
- Use the same motion intent consistently for similar actions across the app.

## Choosing Flutter animation APIs

### Implicit animations

Use widgets such as `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSwitcher`, `AnimatedPadding`, and `TweenAnimationBuilder` when a target value changes and Flutter can animate between old and new values automatically. Supply intentional duration/curve and stable keys for switcher children. Avoid rebuilding with a new key on every frame.

### Explicit animations

Use `AnimationController`, `Animation`, `Tween`, `CurvedAnimation`, or suitable transition widgets when the animation needs sequencing, repeat/reverse, gesture control, precise status handling, or coordinated values. Prefer `vsync` with `SingleTickerProviderStateMixin`/`TickerProviderStateMixin` where appropriate. Dispose every controller and stop/cancel work when its owner is disposed or no longer active.

Do not use an explicit controller for a simple one-property state change when an implicit widget is sufficient. Avoid excessive custom animation infrastructure for one-off effects.

## Common patterns

- **Page transitions:** Use route transitions that preserve context and do not conflict with platform navigation, system back gestures, or deep links. Keep route motion consistent and avoid long transitions that delay access to content.
- **Hero transitions:** Use `Hero` for a shared element that meaningfully connects source and destination. Ensure unique tags among simultaneously mounted routes, compatible shapes/layouts, and graceful behavior when the source is absent (such as a deep link). Avoid flying large text or sensitive content unexpectedly.
- **Animated lists:** Use `AnimatedList` or another appropriate list approach when items are inserted/removed and the change benefits from visual continuity. Maintain stable item identity and correct insertion/removal bookkeeping; do not animate every item on each rebuild.
- **Staggered entry:** Apply subtle, bounded stagger to a small set of first-load elements when it clarifies hierarchy. Avoid replaying lengthy entrance animations on every tab switch or state refresh.
- **Skeleton/shimmer:** Use skeleton placeholders when the content layout is known and loading is expected to take long enough to warrant a placeholder. Keep its shape close to the loaded UI and expose loading semantics. Prefer a compact progress indicator for very brief/indeterminate operations; never show a spinner or shimmer for every trivial state change. Respect reduced motion by stopping shimmer or using static placeholders.
- **Tap feedback:** Prefer Material ink feedback (`InkWell`/`InkResponse`) with an appropriate `Material` ancestor. Use press-scale or opacity only when it reinforces the interaction and does not shrink the effective hit target.
- **Haptics:** Use `HapticFeedback.lightImpact()` sparingly for meaningful actions and only when consistent with platform/product expectations. Do not vibrate for routine navigation or every list item. Ensure the action succeeds or has clear feedback; do not use haptics as the sole signal.

## Reduced motion and accessibility

- Check the SDK-supported `MediaQuery` reduced-animation preference (commonly `MediaQuery.disableAnimationsOf(context)` or `MediaQuery.of(context).disableAnimations`, depending on Flutter version) and the project's accessibility abstraction.
- When reduced motion is requested, remove nonessential movement, shorten transitions where appropriate, and retain essential state information through immediate/static changes. Do not make content unavailable because animation is disabled.
- Preserve semantics during transitions. Avoid rapidly flashing content, disorienting scaling/rotation, parallax that impairs reading, and motion that communicates information without a non-motion alternative.
- Keep focus order and screen-reader announcements sensible when animated content enters, exits, or changes.

## Performance and lifecycle rules

- Target smooth rendering at the device's display refresh rate (commonly 60 Hz or higher), not a hard-coded universal 60 fps ceiling. Profile frame timing on representative devices; avoid per-frame expensive layout, I/O, large image decoding, and unnecessary rebuilds.
- Keep animated subtrees appropriately small; use `AnimatedBuilder`/`ListenableBuilder` or child caching when it measurably reduces rebuild work.
- Dispose every `AnimationController`, listener, timer, and subscription. Cancel animations when the owning state is removed or the action becomes irrelevant.
- Ensure animations tolerate interruptions: repeated taps, rapid state changes, navigation away/back, app lifecycle changes, and reduced-motion toggles.
- Do not animate sensitive health or personal data in ways that expose it on lock screens, screenshots, or unexpected previews.

## Testing and review

Test start/end states, rapid interactions, repeated list insertions/removals, route transitions from normal and deep-link entry, controller disposal, and reduced-motion mode. Verify no overflow, flicker, stale state, blocked controls, or semantics loss. Use Flutter DevTools/performance tooling when animation smoothness is in question. Run `dart format`, `flutter analyze`, and relevant widget/integration tests; describe what was profiled and on which devices.
