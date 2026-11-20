import 'package:auto_route/auto_route.dart';
import 'package:material_ui/material_ui.dart';

import '../motion/frame_clamped_ticker.dart';
import '../theme/app_tokens.dart';

/// Shared screen-transition patterns (skill: flutter-motion-animation).
///
/// - **Every screen navigation** (flow screens, entering Home, drill-down,
///   forms, licenses, not found) uses one transition: the platform push from
///   `AppTheme.pageTransitionsTheme` (Android zoom with predictive back, iOS
///   slide), built by [AppPageRoute]. It is the router's default route type.
/// - **Bottom-tab switches** cross-fade in 150 ms ([AnimatedBranchContainer]).
abstract final class AppTransitions {
  /// auto_route default route builder: every screen uses [AppPageRoute].
  static Route<T> pushRoute<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) => AppPageRoute<T>(
    settings: page,
    fullscreenDialog: page.fullscreenDialog,
    maintainState: page.maintainState,
    builder: (_) => child,
  );
}

/// The app's screen route: platform push (zoom/predictive back on Android,
/// slide on iOS, from the theme) whose clock is frame-clamped
/// ([FrameClampedTickerProvider]), so a slow first frame cannot skip the
/// transition. Use it for every screen, including imperative pushes.
class AppPageRoute<T> extends MaterialPageRoute<T> {
  AppPageRoute({
    required super.builder,
    required RouteSettings super.settings,
    super.fullscreenDialog,
    super.maintainState,
  });

  @override
  AnimationController createAnimationController() => AnimationController(
    duration: transitionDuration,
    reverseDuration: reverseTransitionDuration,
    debugLabel: debugLabel,
    vsync: FrameClampedTickerProvider(navigator!),
  );
}

/// Tab container (used with `AutoTabsRouter.builder`) that cross-fades
/// quickly when switching tabs, while keeping every tab (and its nested
/// stack, scroll position and state) alive.
///
/// The widget structure around each branch never changes, only the
/// animations do, so switching tabs never remounts a branch.
class AnimatedBranchContainer extends StatefulWidget {
  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  State<AnimatedBranchContainer> createState() =>
      _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<AnimatedBranchContainer>
    with SingleTickerProviderStateMixin {
  /// Tab switches must feel instant (iOS doesn't animate them at all): a
  /// short cross-fade where the new tab is visible from the first frame.
  static const Duration _duration = AppMotion.short;

  // Deliberately NOT frame-clamped: unlike screen pushes, a tab switch must
  // finish on time even when frames are slow, so a slow frame completes it
  // sooner rather than stretching it. `preserve` keeps the brief fade when
  // the OS disables animations (Flutter would otherwise cut it to 5%).
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration,
    value: 1,
    animationBehavior: AnimationBehavior.preserve,
  );

  /// Tab fading out during a switch; null when idle.
  int? _previous;

  @override
  void didUpdateWidget(AnimatedBranchContainer old) {
    super.didUpdateWidget(old);
    if (old.currentIndex == widget.currentIndex) return;
    _previous = old.currentIndex;
    _controller.forward(from: 0).whenCompleteOrCancel(() {
      if (mounted) setState(() => _previous = null);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const idle = AlwaysStoppedAnimation<double>(1);
    // Cross-fade: the new tab fades in while the old one fades out, both
    // from the first frame. No scaling (it is costly for a full screen and
    // reads as slow), so this is identical with reduced motion.
    final incoming = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.enter,
    );
    final outgoing = ReverseAnimation(incoming);

    return Stack(
      fit: StackFit.expand,
      children: [
        for (var i = 0; i < widget.children.length; i++)
          _branch(
            index: i,
            child: widget.children[i],
            opacity: i == widget.currentIndex
                ? incoming
                : i == _previous
                ? outgoing
                : idle,
          ),
      ],
    );
  }

  Widget _branch({
    required int index,
    required Widget child,
    required Animation<double> opacity,
  }) {
    final active = index == widget.currentIndex;
    final visible = active || index == _previous;
    return Offstage(
      offstage: !visible,
      child: TickerMode(
        enabled: active,
        child: ExcludeSemantics(
          excluding: !active,
          child: IgnorePointer(
            ignoring: !active,
            // RepaintBoundary: the cross-fade only blends the tab's cached
            // layer instead of repainting the whole tab on every frame.
            child: FadeTransition(
              opacity: opacity,
              child: RepaintBoundary(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
