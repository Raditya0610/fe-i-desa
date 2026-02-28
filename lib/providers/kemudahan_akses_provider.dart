import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/kemudahan_akses.dart';
import '../data/repositories/kemudahan_akses_repository.dart';

final kemudahanAksesRepositoryProvider = Provider<KemudahanAksesRepository>((ref) {
  return KemudahanAksesRepository();
});

final kemudahanAksesProvider = Provider<KemudahanAksesOperations>((ref) {
  return KemudahanAksesOperations(ref.read(kemudahanAksesRepositoryProvider));
});

class KemudahanAksesOperations {
  final KemudahanAksesRepository _repository;

  KemudahanAksesOperations(this._repository);

  Future<Map<String, dynamic>> createKemudahanAkses(KemudahanAkses data) async {
    return await _repository.createKemudahanAkses(data);
  }
}
