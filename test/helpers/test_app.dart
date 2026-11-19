import 'dart:convert';

import 'package:demo_project/app/app.dart';
import 'package:demo_project/app/router/app_router.dart';
import 'package:demo_project/core/providers/core_providers.dart';
import 'package:demo_project/features/medicines/domain/medicine.dart';
import 'package:demo_project/features/medicines/presentation/medicines_controller.dart';
import 'package:demo_project/features/session/session_controller.dart';
import 'package:demo_project/core/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// Thursday 19 November 2026, 10:30. Sample schedule on this day:
/// Brevora 08:00, Ceralin 13:00, Brevora 20:00, Omnivy 21:30 (4 doses).
/// Monday 16 November adds Dulvexa 09:00 (5 doses).
final fixedNow = DateTime(2026, 11, 19, 10, 30);

/// A valid 1×1 PNG.
final onePixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
);

class FakeMediaPicker implements MediaPicker {
  FakeMediaPicker([this.result]);

  MediaPickResult? result;
  int calls = 0;

  @override
  Future<MediaPickResult> pickImage({
    double maxDimension = 1024,
    int imageQuality = 85,
  }) async {
    calls++;
    return result ??
        MediaPicked(PickedImage(bytes: onePixelPng, name: 'photo.png'));
  }
}

/// Starts signed in (simulated Google: full access), skipping the flow.
class SignedInSession extends SessionController {
  @override
  SessionState build() => const SessionState(
    stage: AppStage.signedIn,
    profile: DemoProfile.sample,
    method: SignInMethod.google,
    hasSeenOnboarding: true,
  );
}

/// Starts in guest mode (restricted: no adding/editing/deleting medicines).
class GuestSession extends SessionController {
  @override
  SessionState build() => const SessionState(
    stage: AppStage.signedIn,
    method: SignInMethod.guest,
    hasSeenOnboarding: true,
  );
}

class EmptyMedicines extends MedicinesController {
  @override
  List<Medicine> build() => const [];
}

/// Pumps the full app with a fixed clock and fake picker.
Future<void> pumpApp(
  WidgetTester tester, {
  bool signedIn = true,
  Size size = const Size(400, 1400),
  double textScale = 1,

  /// Start in guest mode instead of signed in (needs [signedIn]).
  bool guest = false,
  MediaPicker? picker,
  List<dynamic> extraOverrides = const [],
  bool reduceMotion = false,
  TextDirection? textDirection,

  /// Simulates the app being launched from this deep link.
  String? launchLocation,

  /// False to inspect the launch frame by frame.
  bool settle = true,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  if (reduceMotion) {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
  }
  if (launchLocation != null) {
    tester.platformDispatcher.defaultRouteNameTestValue = launchLocation;
  }
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAllTestValues);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        clockProvider.overrideWithValue(() => fixedNow),
        mediaPickerProvider.overrideWithValue(picker ?? FakeMediaPicker()),
        if (signedIn)
          sessionProvider.overrideWith(
            guest ? GuestSession.new : SignedInSession.new,
          ),
        ...extraOverrides.cast(),
      ],
      child: App(
        builder: textDirection == null
            ? null
            : (context, child) =>
                  Directionality(textDirection: textDirection, child: child!),
      ),
    ),
  );
  if (settle) await tester.pumpAndSettle(frame60Hz);
}

/// A 60 Hz frame. Settle with it: transitions clamp larger per-frame steps
/// (see FrameClampedTickerProvider), so 100 ms test frames would stretch
/// them in fake time and let timers (e.g. the splash) fire early.
const frame60Hz = Duration(milliseconds: 16);

Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle(frame60Hz);
  await tester.tap(finder);
  await tester.pumpAndSettle(frame60Hz);
}

/// The app's [AppRouter], for navigating to deep links in tests.
AppRouter routerOf(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(App)))
        .read(appRouterProvider);

/// A [ProviderContainer] with the fixed clock and fake picker, for unit
/// tests of notifiers.
ProviderContainer testContainer({
  MediaPicker? picker,
  List<dynamic> overrides = const [],
}) {
  final container = ProviderContainer(
    overrides: [
      clockProvider.overrideWithValue(() => fixedNow),
      mediaPickerProvider.overrideWithValue(picker ?? FakeMediaPicker()),
      ...overrides.cast(),
    ],
  );
  addTearDown(container.dispose);
  return container;
}
