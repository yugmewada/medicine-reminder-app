import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

/// `context.l10n.someKey`. Every user-visible string (including semantics
/// labels, tooltips and errors) must come from here; see lib/l10n/app_en.arb.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
