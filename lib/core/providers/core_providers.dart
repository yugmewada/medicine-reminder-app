import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/utils.dart';

/// Current time. Override in tests for a deterministic "today".
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// The app's single image picker. Override in tests with a fake.
final mediaPickerProvider = Provider<MediaPicker>(
  (ref) => PlatformMediaPicker(),
);
