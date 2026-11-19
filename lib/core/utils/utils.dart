/// Shared, UI- and language-agnostic utilities.
///
/// Rules: no widgets, no theme, no user-facing text. Return typed results or
/// codes (e.g. `ValidationIssue`, `MediaPickFailure`) and let presentation
/// code localize them.
library;

export 'day_utils.dart';
export 'media_picker.dart';
export 'validators.dart';
