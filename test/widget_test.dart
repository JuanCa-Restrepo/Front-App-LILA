// Smoke test mínimo: solo verificamos que la `App` raíz monte sin
// excepciones. Los flujos completos requieren mockear `ApiClient` y
// `FlutterSecureStorage`, lo cual queda fuera del alcance de este test.

import 'package:flutter_test/flutter_test.dart';

import 'package:mockups/app/app.dart';

void main() {
  testWidgets('La App raíz monta sin errores', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    // Si llegamos aquí, el árbol de Providers se construyó correctamente.
    expect(find.byType(App), findsOneWidget);
  });
}
