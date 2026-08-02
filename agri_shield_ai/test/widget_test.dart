import 'package:flutter_test/flutter_test.dart';
import 'package:agri_shield_ai/main.dart';

void main() {
  testWidgets('AgriShield boots', (tester) async {
    await tester.pumpWidget(const AgriShieldApp());
    expect(find.text('AgriShield AI'), findsOneWidget);
  });
}
