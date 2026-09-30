import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockups/core/constants/api_constants.dart';
import 'package:mockups/core/services/auth_service.dart';
import 'package:mockups/core/services/device_service.dart';
import 'package:mockups/core/services/google_drive_uploader.dart';
import 'package:mockups/data/dtos/registro_caso_dto.dart';
import 'package:mockups/data/models/caso_model.dart';
import 'package:mockups/domain/repositories/caso_repository.dart';
import 'package:mockups/domain/repositories/evidencia_repository.dart';
import 'package:mockups/domain/repositories/registro_caso_repository.dart';
import 'package:mockups/presentation/viewmodels/report_case_viewmodel.dart';

class _CaseRepository implements CasoRepository {
  int createCalls = 0;

  @override
  Future<CreatedCaseInfo> createCase({
    required String idUsuario,
    required int idTipoAcoso,
    String? idResponsable,
    required bool pasoInstitucion,
    String? descripcion,
  }) async {
    createCalls++;
    expect(idUsuario, 'user-1');
    expect(idTipoAcoso, 21);
    expect(pasoInstitucion, isTrue);
    expect(descripcion, 'Descripción suficientemente larga');
    return const CreatedCaseInfo(
      codigoCaso: '#AB-12345',
      mensaje: 'Caso creado',
    );
  }

  @override
  Future<CasoModel?> findByCodigo(String codigoCaso) async => const CasoModel(
    idCaso: '32d51340-e274-4d7e-bf3f-87ee8bfe8264',
    idUsuario: 'user-1',
    idTipoAcoso: 21,
    codigoCaso: '#AB-12345',
    pasoInstitucion: true,
  );

  @override
  Future<CasoModel?> findById(String idCaso) async => null;

  @override
  Future<List<CasoModel>> fetchAll() async => const [];
}

class _EvidenceRepository extends Fake implements EvidenciaRepository {}

class _RegistrationRepository implements RegistroCasoRepository {
  RegistroCasoDto? received;
  int calls = 0;

  @override
  Future<void> register(RegistroCasoDto dto) async {
    calls++;
    received = dto;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      StorageKeys.userId: 'user-1',
      StorageKeys.deviceId: 'device-stable-1',
    });
  });

  test(
    'RegistroCasoDto genera exactamente el contrato anidado del backend',
    () {
      const dto = RegistroCasoDto(
        deviceId: 'device-1',
        idCaso: '32d51340-e274-4d7e-bf3f-87ee8bfe8264',
        sexoBiologico: 'Femenino',
        orientacionGenero: 'Bisexual',
        tipoUsuario: 'adulto',
      );

      expect(dto.toJson(), {
        'usuario': {'deviceId': 'device-1'},
        'infoAfectado': {
          'idCaso': '32d51340-e274-4d7e-bf3f-87ee8bfe8264',
          'sexoBiologico': 'Femenino',
          'orientacionGenero': 'Bisexual',
          'tipoUsuario': 'adulto',
        },
      });
    },
  );

  test(
    'DeviceService conserva el mismo identificador de instalación',
    () async {
      FlutterSecureStorage.setMockInitialValues({});
      const service = DeviceService(FlutterSecureStorage());

      final first = await service.getOrCreateDeviceId();
      final second = await service.getOrCreateDeviceId();

      expect(first, hasLength(32));
      expect(second, first);
    },
  );

  test(
    'submit envía un solo RegistroCasoDto con deviceId e info afectada',
    () async {
      const storage = FlutterSecureStorage();
      final cases = _CaseRepository();
      final registrations = _RegistrationRepository();
      final viewModel =
          ReportCaseViewModel(
              casoRepository: cases,
              evidenciaRepository: _EvidenceRepository(),
              registroCasoRepository: registrations,
              driveUploader: const GoogleDriveUploaderStub(),
              authService: const AuthService(storage),
              deviceService: const DeviceService(storage),
            )
            ..setPersonType(AffectedPersonType.adulto)
            ..setSexoBiologico('Femenino')
            ..setOrientacionGenero('Bisexual')
            ..setIdTipoAcoso(21)
            ..setPasoInstitucion(true)
            ..setDescripcion('Descripción suficientemente larga');
      addTearDown(viewModel.dispose);

      expect(await viewModel.submit(), isTrue);
      expect(await viewModel.submit(), isTrue);
      expect(cases.createCalls, 1);
      expect(registrations.calls, 1);
      expect(registrations.received?.toJson(), {
        'usuario': {'deviceId': 'device-stable-1'},
        'infoAfectado': {
          'idCaso': '32d51340-e274-4d7e-bf3f-87ee8bfe8264',
          'sexoBiologico': 'Femenino',
          'orientacionGenero': 'Bisexual',
          'tipoUsuario': 'adulto',
        },
      });
      expect(viewModel.generatedCodigoCaso, '#AB-12345');
    },
  );
}
