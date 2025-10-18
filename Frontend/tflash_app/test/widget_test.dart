import 'package:flutter_test/flutter_test.dart';
import 'package:insidepulse_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const InsidePulseApp());
    expect(find.text('InsidePulse'), findsOneWidget);
  });
}