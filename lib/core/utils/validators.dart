/// Why a value failed validation. The app maps each case to a localized
/// message, so this package stays free of user-facing text.
enum ValidationIssue { empty, tooLong, notWholeNumber, outOfRange }

/// Pure input checks. Return null when the value is valid.
abstract final class Validators {
  /// Non-blank text of at most [maxLength] characters (after trimming).
  static ValidationIssue? text(String? value, {required int maxLength}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return ValidationIssue.empty;
    if (text.length > maxLength) return ValidationIssue.tooLong;
    return null;
  }

  /// A whole number within [min]..[max] (inclusive).
  static ValidationIssue? wholeNumber(
    String? value, {
    required int min,
    required int max,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return ValidationIssue.empty;
    final number = int.tryParse(text);
    if (number == null) return ValidationIssue.notWholeNumber;
    if (number < min || number > max) return ValidationIssue.outOfRange;
    return null;
  }
}
