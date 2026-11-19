/// App identity. [version] mirrors `version:` in pubspec.yaml; a test fails
/// if they drift apart (test/core/app_info_test.dart). User-facing text
/// for these values comes from localization.
abstract final class AppInfo {
  static const String version = '1.0.0+1';

  /// "1.0.0"
  static String get versionName => version.split('+').first;

  /// "1"
  static String get buildNumber => version.split('+').last;
}
