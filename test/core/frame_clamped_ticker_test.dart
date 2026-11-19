import 'package:demo_project/core/motion/frame_clamped_ticker.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

class _ManualTickerProvider implements TickerProvider {
  late TickerCallback callback;

  @override
  Ticker createTicker(TickerCallback onTick) {
    callback = onTick;
    return Ticker(onTick);
  }
}

void main() {
  test('slow frames advance by at most maxFrameStep; normal frames exact', () {
    final inner = _ManualTickerProvider();
    final seen = <int>[];
    FrameClampedTickerProvider(inner)
        .createTicker((elapsed) => seen.add(elapsed.inMilliseconds));
    for (final ms in [0, 16, 32, 532, 548]) {
      inner.callback(Duration(milliseconds: ms));
    }
    // 500 ms gap is clamped to 34 ms; 16 ms steps pass through unchanged.
    expect(seen, [0, 16, 32, 66, 82]);
  });

  test('restarts from zero when the ticker restarts', () {
    final inner = _ManualTickerProvider();
    final seen = <int>[];
    FrameClampedTickerProvider(inner)
        .createTicker((elapsed) => seen.add(elapsed.inMilliseconds));
    for (final ms in [0, 400, 0, 16]) {
      inner.callback(Duration(milliseconds: ms));
    }
    expect(seen, [0, 34, 0, 16]);
  });
}
