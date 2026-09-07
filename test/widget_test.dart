import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/main.dart';

void main() {
  testWidgets('App renders successfully smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ApexWalletApp());
    expect(find.text('Welcome back,'), findsOneWidget);
  });
}
