---
name: flutter-ui-ux-design
description: Plan and improve user experience and interface designs for Flutter mobile apps on Android and iOS. Use when defining user journeys, navigation, screen structure, wireframes, interaction states, visual direction, accessibility, design reviews, or design handoff when Figma is absent or incomplete.
---

# Flutter Mobile UI/UX Design

Design for user goals and real-world use before choosing widgets or visual decoration. Produce clear, testable design decisions that can be implemented in Flutter and remain consistent with the product's platform and brand.

## Workflow

1. **Understand the problem.** Inspect the app, product brief, target users, constraints, existing analytics/research, platform needs, and any current designs. Separate known facts from assumptions. Ask focused questions when a missing requirement affects safety, privacy, navigation, or core behavior.
2. **Define user goals and scope.** Identify primary tasks, user context, success outcomes, edge cases, and out-of-scope behavior. For health or medication apps, avoid medical claims and defer clinical rules to approved product requirements.
3. **Map the information architecture.** Define the app sections, screen hierarchy, entry points, navigation paths, and back behavior. Prefer a simple structure that makes frequent tasks easy to find. Do not add screens or features without a user or business need.
4. **Design key flows.** Map the primary journey and important alternate paths, including first use, returning use, permissions, authentication, interruptions, failures, and recovery. Specify what happens after each meaningful action.
5. **Specify screen-level content and states.** For each screen, state its purpose, primary action, secondary actions, information priority, and required states such as loading, empty, error, success, disabled, permission denied, offline, and destructive confirmation.
6. **Choose interaction patterns.** Use familiar mobile conventions and platform-appropriate behavior. Make actions, feedback, focus, validation, keyboard handling, and undo/recovery behavior explicit. Avoid relying on color alone or gestures that are undiscoverable.
7. **Establish visual direction.** Reuse existing brand assets and design-system tokens. If none exist, propose a small coherent system for color, type hierarchy, spacing, shape, elevation, iconography, and components rather than styling each screen independently.
8. **Review and refine.** Evaluate clarity, consistency, accessibility, responsiveness, cognitive load, privacy, and error recovery. Walk through flows at compact and large phone sizes and with text enlargement. Revise issues before implementation.
9. **Hand off for implementation.** Deliver screen inventory, flow diagrams or descriptions, component/state requirements, content, responsive rules, asset needs, assumptions, and acceptance criteria. If Figma is available, inspect or update frames/components consistently; otherwise provide implementation-ready written specs or low-fidelity wireframes.

## Design principles

- Prioritize the user's primary task; keep important actions visible and label them with clear verbs.
- Use plain, concise language. Explain consequences before irreversible actions and provide actionable error messages.
- Maintain consistent navigation, terminology, controls, spacing, and visual hierarchy across screens.
- Design empty, loading, error, permission-denied, and success experiences—not only the ideal path.
- Support dynamic text, localization, different screen sizes, safe areas, keyboard visibility, and assistive technologies.
- Target sufficient contrast and touch area; provide meaningful semantics, focus order, and non-color cues.
- Request only permissions and personal data needed for a clear user benefit. Explain permission requests in context and provide useful behavior when declined.
- Protect privacy in notifications and previews, especially for health or other sensitive information.
- Use platform-native conventions where users expect them, while keeping the product's visual system cohesive.
- Avoid dark patterns, deceptive urgency, hidden costs, unnecessary friction, and unsupported medical or safety claims.

## Design review checklist

For each major screen and flow, verify:

- Can users identify where they are, what they can do, and what happens next?
- Is the primary action obvious, with clear feedback after activation?
- Are validation and error recovery understandable and do they preserve user input where safe?
- Do long labels, large text, keyboard, small screens, localization, and scrolling avoid clipping or blocking actions?
- Are destructive, sensitive, or permission-related actions explained and appropriately confirmed?
- Are accessibility semantics, contrast, touch targets, and focus behavior specified?
- Are empty, offline, loading, and denied-permission cases accounted for?

## Deliverable format

Summarize the design with: user goal and assumptions; primary flows; screen-by-screen purpose and actions; important UI states; navigation behavior; accessibility/responsive rules; content and asset requirements; open questions; and acceptance criteria. Keep recommendations distinguishable from confirmed requirements. Coordinate with `flutter-figma-mobile` for translating approved designs into Flutter widgets and with `flutter-testing-quality` for validating implemented behavior.
