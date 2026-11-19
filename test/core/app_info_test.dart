import 'dart:io';

import 'package:demo_project/core/constants/app_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppInfo.version matches pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final version = RegExp(
      r'^version:\s*(\S+)',
      multiLine: true,
    ).firstMatch(pubspec)!.group(1);
    expect(AppInfo.version, version);
    expect(AppInfo.versionName, '1.0.0');
    expect(AppInfo.buildNumber, '1');
  });
}
