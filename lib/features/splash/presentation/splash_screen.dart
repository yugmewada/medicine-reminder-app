import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/motion/frame_clamped_ticker.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/widgets.dart';
import '../../session/session_controller.dart';

/// Short in-app brand moment after the native launch screen.
///
/// This is not the native splash (that is the platform launch screen in
/// android/ and ios/). It never waits on work; it only shows the brand
/// briefly. Tapping skips it, and reduced motion shortens it.
@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const Duration hold = Duration(milliseconds: 1200);
  static const Duration reducedHold = Duration(milliseconds: 500);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: FrameClampedTickerProvider(this),
    duration: AppMotion.long + AppMotion.medium,
  );
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_timer != null) return;
    final reduced = AppMotion.reduced(context);
    reduced ? _controller.value = 1 : _controller.forward();
    _timer = Timer(
      reduced ? SplashScreen.reducedHold : SplashScreen.hold,
      _finish,
    );
  }

  void _finish() {
    _timer?.cancel();
    if (mounted) ref.read(sessionProvider.notifier).splashFinished();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final logo = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.7, curve: AppMotion.emphasized),
    );
    final text = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1, curve: AppMotion.enter),
    );

    return Scaffold(
      backgroundColor: colors.primary,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _finish,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: Tween(begin: 0.8, end: 1.0).animate(logo),
                    child: FadeTransition(
                      opacity: logo,
                      child: Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                        ),
                        child: const Center(child: BrandLogo(size: 68)),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FadeTransition(
                    opacity: text,
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(text),
                      child: Column(
                        children: [
                          Text(
                            context.l10n.appTitle,
                            style: context.text.displaySmall?.copyWith(
                              color: colors.onPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            context.l10n.splashTagline,
                            textAlign: TextAlign.center,
                            style: context.text.bodyLarge?.copyWith(
                              color: colors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
