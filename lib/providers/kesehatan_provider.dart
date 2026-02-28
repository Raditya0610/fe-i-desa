import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/kesehatan.dart';
import '../data/repositories/kesehatan_repository.dart';

final kesehatanRepositoryProvider = Provider<KesehatanRepository>((ref) {
  return KesehatanRepository();
});

final kesehatanProvider = Provider<KesehatanOperations>((ref) {
  return KesehatanOperations(ref.read(kesehatanRepositoryProvider));
});

class KesehatanOperations {
  final KesehatanRepository _repository;

  KesehatanOperations(this._repository);

  Future<Map<String, dynamic>> createKesehatan(Kesehatan data) async {
    return await _repository.createKesehatan(data);
  }
}
