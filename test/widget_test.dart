// En modo demo, la primera vista debe estar disponible sin registro remoto.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockups/app/app.dart';
import 'package:mockups/presentation/views/onboarding/onboarding_page.dart';

void main() {
  testWidgets('La App abre Bienvenida sin esperar autenticación', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());
    await tester.pump();
    expect(find.byType(App), findsOneWidget);
    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(find.text('BIENVENIDXS'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
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
