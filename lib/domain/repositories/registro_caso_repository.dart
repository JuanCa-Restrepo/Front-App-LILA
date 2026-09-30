import '../../data/dtos/registro_caso_dto.dart';

abstract class RegistroCasoRepository {
  Future<void> register(RegistroCasoDto dto);
}
