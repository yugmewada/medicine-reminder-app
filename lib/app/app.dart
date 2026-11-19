import 'package:material_ui/material_ui.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/presentation/welcome_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Project',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const _WelcomeRoute(),
    );
  }
}

/// Wires the Welcome screen's actions. Sign-up, sign-in and social auth
/// flows are not built yet, so each action reports that for now.
class _WelcomeRoute extends StatelessWidget {
  const _WelcomeRoute();

  @override
  Widget build(BuildContext context) {
    void notBuiltYet(String flow) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$flow is not available yet')));
    }

    return WelcomeScreen(
      onCreateAccount: () => notBuiltYet('Create Account'),
      onSignIn: () => notBuiltYet('Sign In'),
      onSocialSignIn: (provider) => notBuiltYet('${provider.label} sign-in'),
    );
  }
}
