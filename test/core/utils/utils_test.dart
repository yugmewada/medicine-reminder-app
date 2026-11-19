import 'package:demo_project/core/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DayUtils', () {
    test('daysAround is ordered, inclusive and crosses month ends', () {
      final days = DayUtils.daysAround(DateTime(2026, 11, 30, 18), 2);
      expect(days.map(DayUtils.key), [
        '2026-11-28',
        '2026-11-29',
        '2026-11-30',
        '2026-12-01',
        '2026-12-02',
      ]);
    });

    test('daysBetween ignores time of day and handles past dates', () {
      expect(
        DayUtils.daysBetween(DateTime(2026, 3, 1, 23), DateTime(2026, 3, 2)),
        1,
      );
      expect(
        DayUtils.daysBetween(DateTime(2026, 3, 5), DateTime(2026, 3, 1)),
        -4,
      );
    });

    test('isSameDay compares calendar days only', () {
      expect(
        DayUtils.isSameDay(
          DateTime(2026, 1, 1, 0, 1),
          DateTime(2026, 1, 1, 23),
        ),
        isTrue,
      );
      expect(
        DayUtils.isSameDay(DateTime(2026, 1, 1), DateTime(2026, 1, 2)),
        isFalse,
      );
    });
  });

  group('Validators', () {
    test('text trims and limits length', () {
      expect(Validators.text('  ', maxLength: 5), ValidationIssue.empty);
      expect(Validators.text('abcdef', maxLength: 5), ValidationIssue.tooLong);
      expect(Validators.text(' abc ', maxLength: 5), isNull);
    });

    test('wholeNumber rejects blanks, decimals and out-of-range values', () {
      ValidationIssue? check(String v) =>
          Validators.wholeNumber(v, min: 1, max: 10);
      expect(check(''), ValidationIssue.empty);
      expect(check('2.5'), ValidationIssue.notWholeNumber);
      expect(check('0'), ValidationIssue.outOfRange);
      expect(check('10'), isNull);
    });
  });

  test('picker error codes map to typed failures', () {
    expect(
      PlatformMediaPicker.failureFor('photo_access_denied'),
      MediaPickFailure.accessDenied,
    );
    expect(
      PlatformMediaPicker.failureFor('invalid_image'),
      MediaPickFailure.invalidImage,
    );
    expect(
      PlatformMediaPicker.failureFor('already_active'),
      MediaPickFailure.alreadyActive,
    );
    expect(PlatformMediaPicker.failureFor('???'), MediaPickFailure.unknown);
  });
}
