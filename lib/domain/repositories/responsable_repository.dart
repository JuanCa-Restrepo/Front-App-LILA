import '../entities/responsable.dart';

abstract class ResponsableRepository {
  Future<List<Responsable>> fetchAll();
  Future<Responsable> fetchById(String idResponsable);
}
