import 'package:flutter_test/flutter_test.dart';
import 'package:praktikum7/main.dart';

void main() {
  testWidgets('Dompetku tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const DompetkuApp());

    expect(find.text('Dompetku'), findsOneWidget);
    expect(find.text('Transaksi'), findsOneWidget);
    expect(find.text('Kategori'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Statistik'), findsOneWidget);
  });
}