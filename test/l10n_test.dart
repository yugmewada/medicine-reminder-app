import 'dart:convert';
import 'dart:io';

import 'package:demo_project/app/app.dart';
import 'package:demo_project/core/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('every ARB message has a translator description', () {
    final arb = jsonDecode(
      File('lib/l10n/app_en.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    final keys = arb.keys.where((k) => !k.startsWith('@'));
    for (final key in keys) {
      final meta = arb['@$key'] as Map<String, dynamic>?;
      expect(meta?['description'], isA<String>(), reason: key);
    }
  });

  test('no hard-coded user-facing strings in lib/', () {
    // Literals passed to text-bearing parameters must come from l10n.
    final pattern = RegExp(
      r"""(Text\(|label:|title:|message:|tooltip:|hint:|helperText:|labelText:|hintText:|semanticLabel:)\s*'[^']*[A-Za-z]{2}""",
    );
    final offenders = <String>[];
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.contains('.freezed.dart'))
        .where((f) => !f.path.contains('l10n/app_localizations'));
    for (final file in files) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final previous = i > 0 ? lines[i - 1] : '';
        if (previous.contains('l10n-ignore')) continue;
        if (pattern.hasMatch(lines[i])) {
          offenders.add('${file.path}:${i + 1}: ${lines[i].trim()}');
        }
      }
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });

  testWidgets('plurals, selects and locale formats resolve', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      Localizations(
        locale: const Locale('en'),
        delegates: App.localizationsDelegates,
        child: Builder(
          builder: (context) {
            l10n = context.l10n;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(l10n.stockAmount('tablets', 1), '1 tablet');
    expect(l10n.stockAmount('tablets', 42), '42 tablets');
    expect(l10n.stockAmount('millilitres', 150), '150 mL');
    expect(l10n.medicineCount(1), '1 medicine');
    expect(l10n.doseCount(5), '5 doses');
    expect(
      l10n.progressHeadline(1, 1, 1),
      '1 of 1 scheduled dose logged as taken — 100%',
    );
    expect(l10n.greeting('evening', 'Sam'), 'Good evening, Sam');
    expect(
      l10n.medicineFormIssue('nameMissing', 40, 0, 99999),
      'Please enter a medicine name.',
    );
    expect(
      l10n.medicineFormIssue('quantityOutOfRange', 40, 0, 99999),
      'Please enter a quantity from 0 to 99999.',
    );
    expect(l10n.cadenceWeekly(DateTime(2024, 1, 1)), 'Every Monday');
    expect(
      l10n.todayWithDate(DateTime(2026, 11, 19)),
      'Today · Thursday, November 19',
    );
  });
}
