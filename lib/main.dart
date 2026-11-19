import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';

void main() {
  _registerFontLicenses();
  runApp(const App());
}

/// Bundled fonts are SIL OFL 1.1, which requires shipping their license.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, file) in [
      ('Playfair Display', 'OFL-PlayfairDisplay.txt'),
      ('Outfit', 'OFL-Outfit.txt'),
    ]) {
      final text = await rootBundle.loadString('assets/licenses/$file');
      yield LicenseEntryWithLineBreaks([family], text);
    }
  });
}
