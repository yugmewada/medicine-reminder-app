import 'package:flutter_test/flutter_test.dart';

import 'package:demo_project/app/app.dart';

void main() {
  testWidgets('App starts on the Welcome screen', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Welcome!'), findsOneWidget);
  });
}
