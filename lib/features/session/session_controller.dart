import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../medicines/presentation/medicines_controller.dart';
import '../today/presentation/today_controller.dart';

part 'session_controller.freezed.dart';

/// Top-level app flow. The router redirects to the route for each stage.
enum AppStage { splash, onboarding, welcome, signedIn }

/// How the user entered. Google and Apple are simulated sign-ins (full
/// access, fictional profile); guest is restricted (see
/// [SessionState.canManageMedicines]).
enum SignInMethod {
  google('Google'),
  apple('Apple'),
  guest(null);

  const SignInMethod(this.brandName);

  /// Provider brand name (a proper noun, not translated). Null for guest.
  final String? brandName;

  bool get isGuest => this == SignInMethod.guest;
}

/// Fictional profile shown after demo sign-in. Sample data, not localized.
@freezed
abstract class DemoProfile with _$DemoProfile {
  const DemoProfile._();

  const factory DemoProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) = _DemoProfile;

  static const sample = DemoProfile(
    firstName: 'Jordan',
    lastName: 'Ellis',
    email: 'jordan.ellis@example.com',
  );

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
}

@freezed
abstract class SessionState with _$SessionState {
  const SessionState._();

  const factory SessionState({
    required AppStage stage,
    DemoProfile? profile,
    SignInMethod? method,

    /// Kept for the app run so logging out lands on Welcome, not onboarding.
    @Default(false) bool hasSeenOnboarding,
  }) = _SessionState;

  bool get isGuest => method?.isGuest ?? false;

  /// The guest restriction, in one place: guests can view medicines and log
  /// doses, but only signed-in users can add, edit or delete medicines.
  /// The UI (`runIfCanManageMedicines`) and the router guard both use it.
  bool get canManageMedicines => stage == AppStage.signedIn && !isGuest;
}

/// Whether the current user may add, edit or delete medicines.
final canManageMedicinesProvider = Provider<bool>(
  (ref) => ref.watch(sessionProvider.select((s) => s.canManageMedicines)),
);

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);

/// Owns the demo session (MVI state holder). Nothing here is persisted.
/// Each public method is one user intent.
class SessionController extends Notifier<SessionState> {
  @override
  SessionState build() => const SessionState(stage: AppStage.splash);

  void splashFinished() {
    if (state.stage != AppStage.splash) return;
    state = state.copyWith(
      stage: state.hasSeenOnboarding ? AppStage.welcome : AppStage.onboarding,
    );
  }

  void finishOnboarding() {
    if (state.stage != AppStage.onboarding) return;
    state = state.copyWith(stage: AppStage.welcome, hasSeenOnboarding: true);
  }

  /// Enters the app. Google/Apple (simulated) use the fictional
  /// [DemoProfile.sample]; a guest has no profile and is restricted.
  void signIn(SignInMethod method) {
    state = state.copyWith(
      stage: AppStage.signedIn,
      profile: method.isGuest ? null : DemoProfile.sample,
      method: method,
    );
  }

  /// A guest signs in (simulated) without leaving the app. Session data
  /// (medicines, logs) is kept; restrictions are lifted.
  void upgradeGuest(SignInMethod method) {
    assert(!method.isGuest);
    if (!state.isGuest) return;
    state = state.copyWith(profile: DemoProfile.sample, method: method);
  }

  /// Returns to Welcome and discards every in-memory demo change.
  void logout() {
    ref
      ..invalidate(medicinesProvider)
      ..invalidate(doseLogProvider)
      ..invalidate(selectedDateProvider);
    state = state.copyWith(
      stage: AppStage.welcome,
      profile: null,
      method: null,
    );
  }
}
