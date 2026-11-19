import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:demo_project/core/theme/app_theme.dart';
import 'package:demo_project/features/auth/presentation/welcome_screen.dart';
import 'package:demo_project/features/auth/presentation/widgets/social_sign_in_button.dart';

void main() {
  final events = <String>[];

  Future<void> pumpWelcome(
    WidgetTester tester, {
    Size size = const Size(375, 812),
    double textScale = 1,
    ThemeData? theme,
    // iOS by default so all three social providers are shown.
    TargetPlatform platform = TargetPlatform.iOS,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        theme: (theme ?? AppTheme.light).copyWith(platform: platform),
        home: WelcomeScreen(
          onCreateAccount: () => events.add('create'),
          onSignIn: () => events.add('signIn'),
          onSocialSignIn: (p) => events.add(p.name),
        ),
      ),
    );
  }

  setUp(events.clear);

  testWidgets('renders the design content', (tester) async {
    await pumpWelcome(tester);

    expect(find.text('Welcome!'), findsOneWidget);
    expect(
      find.text("Welcome Back! Let's make it better for your style"),
      findsOneWidget,
    );
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Continue with social media'), findsOneWidget);
    expect(find.byType(SocialSignInButton), findsNWidgets(3));
  });

  testWidgets('every action reaches its callback', (tester) async {
    await pumpWelcome(tester);

    await tester.tap(find.byKey(const ValueKey('create-account')));
    await tester.tap(find.byKey(const ValueKey('sign-in')));
    for (final p in SocialProvider.values) {
      await tester.tap(find.byKey(ValueKey('social-${p.name}')));
    }

    expect(events, ['create', 'signIn', 'facebook', 'google', 'apple']);
  });

  testWidgets('social buttons expose accessible labels and touch targets', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpWelcome(tester);

    for (final p in SocialProvider.values) {
      expect(find.bySemanticsLabel('Continue with ${p.label}'), findsOneWidget);
    }
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  final layouts = <String, (Size, double)>{
    'small phone (320x568)': (const Size(320, 568), 1),
    'large phone (430x932)': (const Size(430, 932), 1),
    'landscape (812x375)': (const Size(812, 375), 1),
    '200% text on 375x812': (const Size(375, 812), 2),
  };
  for (final MapEntry(key: name, value: (size, scale)) in layouts.entries) {
    testWidgets('no overflow and actions reachable: $name', (tester) async {
      await pumpWelcome(tester, size: size, textScale: scale);

      // Overflow would already have thrown a FlutterError during layout.
      final apple = find.byKey(const ValueKey('social-apple'));
      await tester.ensureVisible(apple);
      await tester.pumpAndSettle();
      await tester.tap(apple);
      expect(events, ['apple']);
    });
  }

  testWidgets('iOS shows Facebook, Google and Apple', (tester) async {
    await pumpWelcome(tester, platform: TargetPlatform.iOS);

    expect(find.byKey(const ValueKey('social-facebook')), findsOneWidget);
    expect(find.byKey(const ValueKey('social-google')), findsOneWidget);
    expect(find.byKey(const ValueKey('social-apple')), findsOneWidget);
  });

  testWidgets('Android hides Apple', (tester) async {
    await pumpWelcome(tester, platform: TargetPlatform.android);

    expect(find.byKey(const ValueKey('social-facebook')), findsOneWidget);
    expect(find.byKey(const ValueKey('social-google')), findsOneWidget);
    expect(find.byKey(const ValueKey('social-apple')), findsNothing);
  });

  testWidgets('renders in dark theme', (tester) async {
    await pumpWelcome(tester, theme: AppTheme.dark);
    expect(find.text('Welcome!'), findsOneWidget);
  });
}
