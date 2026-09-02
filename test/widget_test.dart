import 'package:flutter_test/flutter_test.dart';

import 'package:trabalhaki2/main.dart';

void main() {
  testWidgets('the app boots into the Trabalhaki flow', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 5));
    await tester.pump();

    expect(find.text('Trabalhaki'), findsWidgets);
  });
}
