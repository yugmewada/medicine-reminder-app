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
/// - **Bottom-tab switches** fade through ([AnimatedBranchContainer]).
abstract final class AppTransitions {
  /// Outgoing tab fades out during the first 35% of a tab switch.
  static const Interval _outgoing = Interval(0, 0.35, curve: AppMotion.exit);

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

  /// Opacity for the tab leaving during fade-through (1 → 0 early on).
  static Animation<double> outgoing(Animation<double> animation) => Tween(
    begin: 1.0,
    end: 0.0,
  ).animate(CurvedAnimation(parent: animation, curve: _outgoing));
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

/// Tab container (used with `AutoTabsRouter.builder`) that fades through
/// when switching tabs, while keeping every tab (and its nested stack,
/// scroll position and state) alive.
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
  // preserve: see FadeThroughPage. Under reduced motion the switch is a
  // short dissolve; without this Flutter would make it instant.
  late final AnimationController _controller = AnimationController(
    vsync: FrameClampedTickerProvider(this),
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
    _controller
      ..duration = AppMotion.pageOf(context)
      ..forward(from: 0).whenCompleteOrCancel(() {
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
    final reduced = AppMotion.reduced(context);
    const idle = AlwaysStoppedAnimation<double>(1);
    final incoming = CurvedAnimation(
      parent: _controller,
      curve: reduced
          ? AppMotion.enter
          : const Interval(0.35, 1, curve: AppMotion.enter),
    );
    final scale = reduced
        ? idle
        : Tween(begin: 0.92, end: 1.0).animate(incoming);

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
                ? AppTransitions.outgoing(_controller)
                : idle,
            scale: i == widget.currentIndex ? scale : idle,
          ),
      ],
    );
  }

  Widget _branch({
    required int index,
    required Widget child,
    required Animation<double> opacity,
    required Animation<double> scale,
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
            child: FadeTransition(
              opacity: opacity,
              child: ScaleTransition(scale: scale, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
