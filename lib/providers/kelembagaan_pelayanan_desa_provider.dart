import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/kelembagaan_pelayanan_desa.dart';
import '../data/repositories/kelembagaan_pelayanan_desa_repository.dart';

final kelembagaanPelayananDesaRepositoryProvider = Provider<KelembagaanPelayananDesaRepository>((ref) {
  return KelembagaanPelayananDesaRepository();
});

final kelembagaanPelayananDesaProvider = Provider<KelembagaanPelayananDesaOperations>((ref) {
  return KelembagaanPelayananDesaOperations(ref.read(kelembagaanPelayananDesaRepositoryProvider));
});

class KelembagaanPelayananDesaOperations {
  final KelembagaanPelayananDesaRepository _repository;

  KelembagaanPelayananDesaOperations(this._repository);

  Future<Map<String, dynamic>> createKelembagaanPelayananDesa(KelembagaanPelayananDesa data) async {
    return await _repository.createKelembagaanPelayananDesa(data);
  }
}
