import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockups/core/services/auth_service.dart';
import 'package:mockups/core/services/google_drive_uploader.dart';
import 'package:mockups/data/models/tipo_acoso_model.dart';
import 'package:mockups/domain/repositories/caso_repository.dart';
import 'package:mockups/domain/repositories/evidencia_repository.dart';
import 'package:mockups/domain/repositories/responsable_repository.dart';
import 'package:mockups/domain/repositories/tipo_acoso_repository.dart';
import 'package:mockups/presentation/viewmodels/case_status_viewmodel.dart';
import 'package:mockups/presentation/viewmodels/report_case_viewmodel.dart';
import 'package:mockups/presentation/viewmodels/tipo_acoso_viewmodel.dart';
import 'package:mockups/presentation/views/home/home_page.dart';
import 'package:mockups/presentation/views/report_case/report_case_step1_page.dart';
import 'package:mockups/presentation/views/report_case/report_case_step2_page.dart';
import 'package:mockups/presentation/views/report_case/report_case_step3_page.dart';
import 'package:mockups/presentation/views/report_case/report_case_step4_page.dart';
import 'package:mockups/presentation/views/report_case/report_case_step5_page.dart';
import 'package:mockups/presentation/views/report_case/report_final_page.dart';
import 'package:mockups/presentation/widgets/app_bottom_bar.dart';

class _Cases extends Fake implements CasoRepository {}

class _Evidence extends Fake implements EvidenciaRepository {}

class _Responsibles extends Fake implements ResponsableRepository {}

class _Catalog implements TipoAcosoRepository {
  Future<List<TipoAcosoModel>> Function()? fetch;
  @override
  Future<List<TipoAcosoModel>> fetchAll() async => fetch != null
      ? fetch!()
      : const [
          TipoAcosoModel(idTipoAcoso: 21, descripcion: 'Acoso verbal'),
          TipoAcosoModel(idTipoAcoso: 35, descripcion: 'Acoso físico'),
          TipoAcosoModel(idTipoAcoso: 48, descripcion: 'Acoso sexual'),
          TipoAcosoModel(idTipoAcoso: 92, descripcion: 'Acoso digital'),
        ];
}

ReportCaseViewModel _report() => ReportCaseViewModel(
  casoRepository: _Cases(),
  evidenciaRepository: _Evidence(),
  driveUploader: const GoogleDriveUploaderStub(),
  authService: const AuthService(FlutterSecureStorage()),
);

class _ConfirmationReport extends ReportCaseViewModel {
  final String code;

  _ConfirmationReport(this.code)
    : super(
        casoRepository: _Cases(),
        evidenciaRepository: _Evidence(),
        driveUploader: const GoogleDriveUploaderStub(),
        authService: const AuthService(FlutterSecureStorage()),
      );

  @override
  String? get generatedCodigoCaso => code;
}

Widget _app(
  Widget page,
  ReportCaseViewModel report,
  TipoAcosoViewModel catalog, {
  GlobalKey? captureKey,
  double textScale = 1,
}) => MultiProvider(
  providers: [
    ChangeNotifierProvider.value(value: report),
    ChangeNotifierProvider.value(value: catalog),
  ],
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: RepaintBoundary(key: captureKey, child: page),
  ),
);

void _size(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _continue(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Continuar'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continuar'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    const fontPath = String.fromEnvironment('REPORT_PREVIEW_FONT');
    if (fontPath.isNotEmpty) {
      final loader = FontLoader('Roboto')
        ..addFont(
          File(
            fontPath,
          ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
        );
      await loader.load();
    }
  });
  testWidgets('Step 1 keeps profile data and opens the situation step', (
    tester,
  ) async {
    _size(tester, const Size(390, 844));
    final report = _report();
    final catalog = TipoAcosoViewModel(_Catalog());
    addTearDown(report.dispose);
    addTearDown(catalog.dispose);
    await tester.pumpWidget(_app(const ReportCaseStep1Page(), report, catalog));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Adulto'));
    await tester.tap(find.text('Adulto'));
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Femenino').last);
    await tester.enterText(find.byType(TextField), 'Bisexual');
    await _continue(tester);
    expect(report.personType, AffectedPersonType.adulto);
    expect(report.sexoBiologico, 'Femenino');
    expect(report.orientacionGenero, 'Bisexual');
    expect(find.byType(ReportCaseStep2Page), findsOneWidget);
  });

  testWidgets(
    'Selections and description survive back navigation; validation gates each step',
    (tester) async {
      _size(tester, const Size(390, 844));
      final report = _report();
      final catalog = TipoAcosoViewModel(_Catalog());
      addTearDown(report.dispose);
      addTearDown(catalog.dispose);
      await tester.pumpWidget(
        _app(const ReportCaseStep2Page(), report, catalog),
      );
      await tester.pumpAndSettle();
      await _continue(tester);
      expect(find.byType(ReportCaseStep3Page), findsNothing);
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.ensureVisible(find.text('Acoso digital'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Acoso digital'));
      expect(report.idTipoAcoso, 92);
      await _continue(tester);
      expect(find.byType(ReportCaseStep3Page), findsOneWidget);
      await _continue(tester);
      expect(find.byType(ReportCaseStep4Page), findsNothing);
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.ensureVisible(find.text('No'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('No'));
      expect(report.pasoInstitucion, false);
      await _continue(tester);
      await tester.enterText(find.byType(TextField), 'Breve');
      await _continue(tester);
      expect(
        find.text('Escribe al menos 10 caracteres para continuar.'),
        findsOneWidget,
      );
      const description = 'Recibí mensajes ofensivos ayer por la tarde.';
      await tester.enterText(find.byType(TextField), description);
      expect(report.descripcion, description);
      await tester.ensureVisible(find.text('Volver'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Volver'));
      await tester.pumpAndSettle();
      await _continue(tester);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        description,
      );
      await _continue(tester);
      expect(find.byType(ReportCaseStep5Page), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Catalog loading, retry, empty response and orientation guide work',
    (tester) async {
      _size(tester, const Size(390, 844));
      final pending = Completer<List<TipoAcosoModel>>();
      final repo = _Catalog()..fetch = () => pending.future;
      final catalog = TipoAcosoViewModel(repo);
      final report = _report();
      addTearDown(report.dispose);
      addTearDown(catalog.dispose);
      await tester.pumpWidget(
        _app(const ReportCaseStep2Page(), report, catalog),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      pending.completeError(Exception('Sin conexión'));
      await tester.pumpAndSettle();
      expect(find.text('Reintentar'), findsOneWidget);
      repo.fetch = () async => [];
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(
        find.text('No hay tipos de situación disponibles en este momento.'),
        findsOneWidget,
      );
      repo.fetch = null;
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(find.text('Acoso verbal'), findsOneWidget);
      await tester.ensureVisible(find.text('Ver guía de orientación'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ver guía de orientación'));
      await tester.pumpAndSettle();
      expect(find.text('Guía de orientación'), findsOneWidget);
      await tester.ensureVisible(find.text('Entendido'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();
      expect(find.text('Guía de orientación'), findsNothing);
    },
  );

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1024, 768),
  ]) {
    for (final entry in [
      (1, const ReportCaseStep1Page(), 'Continuar'),
      (2, const ReportCaseStep2Page(), 'Continuar'),
      (3, const ReportCaseStep3Page(), 'Continuar'),
      (4, const ReportCaseStep4Page(), 'Continuar'),
      (5, const ReportCaseStep5Page(), 'Enviar reporte'),
    ]) {
      testWidgets(
        'Step ${entry.$1} fits $size and keeps actions above media dock',
        (tester) async {
          _size(tester, size);
          final report = _report()
            ..setIdTipoAcoso(21)
            ..setPasoInstitucion(true);
          final catalog = TipoAcosoViewModel(_Catalog());
          final key = GlobalKey();
          addTearDown(report.dispose);
          addTearDown(catalog.dispose);
          await tester.pumpWidget(
            _app(entry.$2, report, catalog, captureKey: key),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          if (size == const Size(390, 844) &&
              const bool.fromEnvironment('CAPTURE_REPORT_SCREENS')) {
            expect(
              tester.getRect(find.text(entry.$3)).bottom,
              lessThan(tester.getRect(find.byType(AppBottomBar)).top),
            );
            if (const bool.fromEnvironment('CAPTURE_REPORT_SCREENS')) {
              final boundary =
                  key.currentContext!.findRenderObject()!
                      as RenderRepaintBoundary;
              await tester.runAsync(() async {
                final screenshot = await boundary.toImage(pixelRatio: 2);
                final bytes = await screenshot.toByteData(
                  format: ui.ImageByteFormat.png,
                );
                final file = File('build/report_previews/step${entry.$1}.png');
                await file.parent.create(recursive: true);
                await file.writeAsBytes(bytes!.buffer.asUint8List());
                screenshot.dispose();
              });
            }
          }
          await tester.ensureVisible(find.text('Volver'));
          await tester.pumpAndSettle();
          expect(
            tester.getRect(find.text(entry.$3)).bottom,
            lessThan(tester.getRect(find.byType(AppBottomBar)).top),
          );
          expect(find.text(entry.$3).hitTestable(), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('Description is usable with large text and keyboard open', (
    tester,
  ) async {
    _size(tester, const Size(390, 844));
    final report = _report();
    final catalog = TipoAcosoViewModel(_Catalog());
    addTearDown(report.dispose);
    addTearDown(catalog.dispose);
    await tester.pumpWidget(
      _app(const ReportCaseStep4Page(), report, catalog, textScale: 1.8),
    );
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.enterText(
      find.byType(TextField),
      'Descripción conservada con el teclado abierto.',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Continuar').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Profile field keeps focus and text while keyboard is open', (
    tester,
  ) async {
    _size(tester, const Size(390, 844));
    final report = _report();
    final catalog = TipoAcosoViewModel(_Catalog());
    addTearDown(report.dispose);
    addTearDown(catalog.dispose);
    await tester.pumpWidget(_app(const ReportCaseStep1Page(), report, catalog));
    await tester.pumpAndSettle();

    final field = find.byType(TextField);
    await tester.ensureVisible(field);
    await tester.pumpAndSettle();
    await tester.tap(field);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await tester.enterText(field, 'Bise');
    await tester.enterText(field, 'Bisexual');
    await tester.pumpAndSettle();

    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isTrue,
    );
    expect(tester.widget<TextField>(field).controller!.text, 'Bisexual');
    expect(report.orientacionGenero, 'Bisexual');
    expect(find.byType(AppBottomBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Description field keeps its size and focus while typing', (
    tester,
  ) async {
    _size(tester, const Size(390, 844));
    final report = _report();
    final catalog = TipoAcosoViewModel(_Catalog());
    addTearDown(report.dispose);
    addTearDown(catalog.dispose);
    await tester.pumpWidget(_app(const ReportCaseStep4Page(), report, catalog));
    await tester.pumpAndSettle();
    final field = find.byType(TextField);
    final initialLines = tester.widget<TextField>(field).maxLines;

    await tester.ensureVisible(field);
    await tester.pumpAndSettle();
    await tester.tap(field);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await tester.enterText(field, 'Primer texto');
    await tester.enterText(field, 'Descripción ampliada sin perder el foco.');
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(field).maxLines, initialLines);
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isTrue,
    );
    expect(report.descripcion, 'Descripción ampliada sin perder el foco.');
    expect(find.byType(AppBottomBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home tracking field stays mounted when keyboard opens', (
    tester,
  ) async {
    _size(tester, const Size(390, 844));
    final report = _report();
    final status = CaseStatusViewModel(
      casoRepository: _Cases(),
      responsableRepository: _Responsibles(),
      evidenciaRepository: _Evidence(),
    );
    addTearDown(report.dispose);
    addTearDown(status.dispose);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: report),
          ChangeNotifierProvider.value(value: status),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pumpAndSettle();

    final field = find.byType(TextField);
    await tester.ensureVisible(field);
    await tester.pumpAndSettle();
    final fieldElement = tester.element(field);
    await tester.tap(field);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await tester.enterText(field, 'LILA-12345');
    await tester.pumpAndSettle();

    expect(tester.element(field), same(fieldElement));
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isTrue,
    );
    expect(tester.widget<TextField>(field).controller!.text, 'LILA-12345');
    expect(find.byType(AppBottomBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(1024, 768),
  ]) {
    testWidgets('Confirmation keeps code and actions accessible at $size', (
      tester,
    ) async {
      _size(tester, size);
      final report = _ConfirmationReport('#AB-12345');
      final captureKey = GlobalKey();
      addTearDown(report.dispose);
      await tester.pumpWidget(
        ChangeNotifierProvider<ReportCaseViewModel>.value(
          value: report,
          child: MaterialApp(
            home: RepaintBoundary(
              key: captureKey,
              child: const ReportFinalPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Reporte recibido'), findsOneWidget);
      expect(find.text('#AB-12345'), findsOneWidget);
      if (size == const Size(390, 844) &&
          const bool.fromEnvironment('CAPTURE_CONFIRMATION')) {
        final boundary =
            captureKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final screenshot = await boundary.toImage(pixelRatio: 2);
          final bytes = await screenshot.toByteData(
            format: ui.ImageByteFormat.png,
          );
          final file = File('build/report_previews/confirmation.png');
          await file.parent.create(recursive: true);
          await file.writeAsBytes(bytes!.buffer.asUint8List());
          screenshot.dispose();
        });
      }
      await tester.ensureVisible(find.text('Consultar estado'));
      await tester.pumpAndSettle();
      expect(find.text('Consultar estado').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Demo confirmation is labeled and code can be copied', (
    tester,
  ) async {
    _size(tester, const Size(390, 844));
    String? copiedCode;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copiedCode = (call.arguments as Map)['text'] as String?;
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );
    final report = _ConfirmationReport('LILA-DEMO-12345');
    addTearDown(report.dispose);
    await tester.pumpWidget(
      ChangeNotifierProvider<ReportCaseViewModel>.value(
        value: report,
        child: const MaterialApp(home: ReportFinalPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Vista de demostración'), findsOneWidget);
    expect(find.text('Consultar estado'), findsNothing);
    await tester.tap(find.text('Copiar código'));
    await tester.pump();
    expect(copiedCode, 'LILA-DEMO-12345');
    expect(tester.takeException(), isNull);
  });
}
