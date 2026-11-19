import 'package:flutter/scheduler.dart';

/// A [TickerProvider] whose tickers never advance more than [maxFrameStep]
/// per frame.
///
/// Flutter animations are time-based. When a transition starts, its first
/// frame also builds the new screen; if that frame is slow (first build of a
/// screen, especially in debug builds), the next timestamp is already past
/// the transition's end and the animation jumps to its final value, so the
/// screen appears with no animation. Clamping the per-frame step means a
/// slow frame slows the animation for a moment instead of skipping it.
/// At normal frame rates (frames shorter than [maxFrameStep]) timing is
/// unchanged.
///
/// Use for screen transitions and other entrance animations:
/// `AnimationController(vsync: FrameClampedTickerProvider(this), ...)`.
class FrameClampedTickerProvider implements TickerProvider {
  const FrameClampedTickerProvider(
    this._inner, {
    this.maxFrameStep = const Duration(milliseconds: 34),
  });

  final TickerProvider _inner;

  /// Largest time step applied per frame (about two 60 Hz frames).
  final Duration maxFrameStep;

  @override
  Ticker createTicker(TickerCallback onTick) {
    var lastElapsed = Duration.zero;
    var clock = Duration.zero;
    return _inner.createTicker((elapsed) {
      // A ticker restarts at zero each time its controller starts again.
      if (elapsed == Duration.zero || elapsed < lastElapsed) {
        clock = elapsed;
      } else {
        final step = elapsed - lastElapsed;
        clock += step > maxFrameStep ? maxFrameStep : step;
      }
      lastElapsed = elapsed;
      onTick(clock);
    });
  }
}
