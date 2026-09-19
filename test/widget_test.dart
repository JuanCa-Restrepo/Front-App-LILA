// Smoke test mínimo: solo verificamos que la `App` raíz monte sin
// excepciones. Los flujos completos requieren mockear `ApiClient` y
// `FlutterSecureStorage`, lo cual queda fuera del alcance de este test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockups/app/app.dart';
import 'package:mockups/presentation/views/onboarding/onboarding_page.dart';

void main() {
  testWidgets('La App raíz monta sin errores', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    // Si llegamos aquí, el árbol de Providers se construyó correctamente.
    expect(find.byType(App), findsOneWidget);
  });

  testWidgets('Continuar abre el segundo onboarding', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: OnboardingPage()));

    expect(find.text('Continuar'), findsOneWidget);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(find.text('¿Cómo reportar\nun caso?'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Confirmación'), findsOneWidget);
  });
}
