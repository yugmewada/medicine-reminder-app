import 'package:demo_project/features/medicines/presentation/medicines_controller.dart';
import 'package:demo_project/features/session/session_controller.dart';
import 'package:demo_project/features/today/domain/dose_schedule.dart';
import 'package:demo_project/features/today/presentation/today_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  test('splash → onboarding → welcome → signed in', () {
    final c = testContainer();
    final session = c.read(sessionProvider.notifier);
    expect(c.read(sessionProvider).stage, AppStage.splash);

    session.splashFinished();
    expect(c.read(sessionProvider).stage, AppStage.onboarding);
    session.finishOnboarding();
    expect(c.read(sessionProvider).stage, AppStage.welcome);
    session.signIn(SignInMethod.google);

    final state = c.read(sessionProvider);
    expect(state.stage, AppStage.signedIn);
    expect(state.profile, DemoProfile.sample);
    expect(state.method, SignInMethod.google);
  });

  test('intents out of order are ignored', () {
    final c = testContainer();
    final session = c.read(sessionProvider.notifier);
    session.finishOnboarding(); // still on splash
    expect(c.read(sessionProvider).stage, AppStage.splash);
  });

  test('logout clears the profile and resets all demo data', () {
    final c = testContainer();
    final session = c.read(sessionProvider.notifier)
      ..splashFinished()
      ..finishOnboarding()
      ..signIn(SignInMethod.google);

    c.read(doseLogProvider.notifier).log('x', DoseStatus.taken);
    c.read(selectedDateProvider.notifier).select(DateTime(2026, 11, 16));
    final medicines = c.read(medicinesProvider.notifier);
    medicines.save(c.read(medicinesProvider).first.copyWith(name: 'Changed'));

    session.logout();
    final state = c.read(sessionProvider);
    expect(state.stage, AppStage.welcome);
    expect(state.profile, isNull);
    expect(state.method, isNull);
    expect(state.hasSeenOnboarding, isTrue);
    expect(c.read(doseLogProvider), isEmpty);
    expect(c.read(selectedDateProvider), DateTime(2026, 11, 19));
    expect(c.read(medicinesProvider).first.name, 'Brevora');
  });
}
