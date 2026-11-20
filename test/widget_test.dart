
import 'package:flutter_test/flutter_test.dart';
import 'package:edit_doc_flutter/main.dart';

void main() {
  testWidgets('Aplicativo inicia na tela de login', (tester) async {
    await tester.pumpWidget(const MeuApp());

    expect(find.text('Login'), findsOneWidget);
  });
}
