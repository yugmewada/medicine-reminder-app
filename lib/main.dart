import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'app/app.dart';
import 'core/utils/utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();
  // Android: always use the system Photo Picker (no media permissions).
  PlatformMediaPicker.configure();
  runApp(const DosezaApp());
}

/// The bundled font is SIL OFL 1.1, which requires shipping its license.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    final text = await rootBundle.loadString('assets/licenses/OFL-Outfit.txt');
    yield LicenseEntryWithLineBreaks(['Outfit'], text);
  });
}
