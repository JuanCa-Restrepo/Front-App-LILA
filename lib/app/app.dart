import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../core/network/api_client.dart';
import '../core/services/auth_service.dart';
import '../core/services/device_service.dart';
import '../core/services/google_drive_uploader.dart';
import '../data/datasources/caso_remote_datasource.dart';
import '../data/datasources/evidencia_remote_datasource.dart';
import '../data/datasources/responsable_remote_datasource.dart';
import '../data/datasources/tipo_acoso_remote_datasource.dart';
import '../data/datasources/usuario_remote_datasource.dart';
import '../data/repositories/caso_repository_impl.dart';
import '../data/repositories/evidencia_repository_impl.dart';
import '../data/repositories/responsable_repository_impl.dart';
import '../data/repositories/tipo_acoso_repository_impl.dart';
import '../data/repositories/usuario_repository_impl.dart';
import '../domain/repositories/caso_repository.dart';
import '../domain/repositories/evidencia_repository.dart';
import '../domain/repositories/responsable_repository.dart';
import '../domain/repositories/tipo_acoso_repository.dart';
import '../domain/repositories/usuario_repository.dart';
import '../presentation/viewmodels/auth_viewmodel.dart';
import '../presentation/viewmodels/case_status_viewmodel.dart';
import '../presentation/viewmodels/evidencia_viewmodel.dart';
import '../presentation/viewmodels/report_case_viewmodel.dart';
import '../presentation/viewmodels/tipo_acoso_viewmodel.dart';
import '../presentation/views/splash/splash_page.dart';

/// Raíz de la aplicación.
///
/// Aquí cableamos toda la inyección de dependencias con `MultiProvider`.
/// El orden de los providers IMPORTA: cada nivel solo puede leer providers
/// declarados antes que él.
///
/// Capas (de arriba abajo):
/// 1. Infraestructura: `FlutterSecureStorage`, `ApiClient`.
/// 2. Datasources HTTP.
/// 3. Repositorios concretos, expuestos como sus interfaces de dominio.
/// 4. Servicios (`DeviceService`, `AuthService`, `GoogleDriveUploader`).
/// 5. ViewModels (todos `ChangeNotifier`).
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ==================================================
        // 1) Infraestructura
        // ==================================================
        Provider<FlutterSecureStorage>(
          create: (_) => const FlutterSecureStorage(),
        ),
        Provider<ApiClient>(
          create: (_) => ApiClient.create(),
        ),

        // ==================================================
        // 2) Datasources
        // ==================================================
        Provider<UsuarioRemoteDatasource>(
          create: (ctx) => UsuarioRemoteDatasource(ctx.read<ApiClient>()),
        ),
        Provider<TipoAcosoRemoteDatasource>(
          create: (ctx) => TipoAcosoRemoteDatasource(ctx.read<ApiClient>()),
        ),
        Provider<ResponsableRemoteDatasource>(
          create: (ctx) =>
              ResponsableRemoteDatasource(ctx.read<ApiClient>()),
        ),
        Provider<CasoRemoteDatasource>(
          create: (ctx) => CasoRemoteDatasource(ctx.read<ApiClient>()),
        ),
        Provider<EvidenciaRemoteDatasource>(
          create: (ctx) => EvidenciaRemoteDatasource(ctx.read<ApiClient>()),
        ),

        // ==================================================
        // 3) Repositorios — expuestos como interface
        // ==================================================
        Provider<UsuarioRepository>(
          create: (ctx) => UsuarioRepositoryImpl(
            ctx.read<UsuarioRemoteDatasource>(),
          ),
        ),
        Provider<TipoAcosoRepository>(
          create: (ctx) => TipoAcosoRepositoryImpl(
            ctx.read<TipoAcosoRemoteDatasource>(),
          ),
        ),
        Provider<ResponsableRepository>(
          create: (ctx) => ResponsableRepositoryImpl(
            ctx.read<ResponsableRemoteDatasource>(),
          ),
        ),
        Provider<CasoRepository>(
          create: (ctx) => CasoRepositoryImpl(
            ctx.read<CasoRemoteDatasource>(),
          ),
        ),
        Provider<EvidenciaRepository>(
          create: (ctx) => EvidenciaRepositoryImpl(
            ctx.read<EvidenciaRemoteDatasource>(),
          ),
        ),

        // ==================================================
        // 4) Servicios
        // ==================================================
        Provider<DeviceService>(
          create: (ctx) => DeviceService(ctx.read<FlutterSecureStorage>()),
        ),
        Provider<AuthService>(
          create: (ctx) => AuthService(ctx.read<FlutterSecureStorage>()),
        ),
        Provider<GoogleDriveUploader>(
          create: (_) => GoogleDriveUploaderImpl(
            folderId: const String.fromEnvironment(
              'DRIVE_FOLDER_ID',
              defaultValue: 'TU_FOLDER_ID_AQUI',
            ),
          ),
        ),

        // ==================================================
        // 5) ViewModels
        // ==================================================
        ChangeNotifierProvider(
          create: (ctx) => AuthViewModel(
            authService: ctx.read<AuthService>(),
            deviceService: ctx.read<DeviceService>(),
            usuarioRepository: ctx.read<UsuarioRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TipoAcosoViewModel(
            ctx.read<TipoAcosoRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReportCaseViewModel(
            casoRepository: ctx.read<CasoRepository>(),
            evidenciaRepository: ctx.read<EvidenciaRepository>(),
            driveUploader: ctx.read<GoogleDriveUploader>(),
            authService: ctx.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CaseStatusViewModel(
            casoRepository: ctx.read<CasoRepository>(),
            responsableRepository: ctx.read<ResponsableRepository>(),
            evidenciaRepository: ctx.read<EvidenciaRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => EvidenciaViewModel(
            repository: ctx.read<EvidenciaRepository>(),
            driveUploader: ctx.read<GoogleDriveUploader>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LILA',
        theme: ThemeData(
          fontFamily: 'Roboto',
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        ),
        home: const SplashPage(),
      ),
    );
  }
}
