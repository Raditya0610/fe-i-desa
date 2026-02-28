import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/pendidikan.dart';
import '../data/repositories/pendidikan_repository.dart';

final pendidikanRepositoryProvider = Provider<PendidikanRepository>((ref) {
  return PendidikanRepository();
});

final pendidikanProvider = Provider<PendidikanOperations>((ref) {
  return PendidikanOperations(ref.read(pendidikanRepositoryProvider));
});

class PendidikanOperations {
  final PendidikanRepository _repository;

  PendidikanOperations(this._repository);

  Future<Map<String, dynamic>> createPendidikan(Pendidikan data) async {
    return await _repository.createPendidikan(data);
  }
}
