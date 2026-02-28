import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/tata_kelola_keuangan_desa.dart';
import '../data/repositories/tata_kelola_keuangan_desa_repository.dart';

final tataKelolaKeuanganDesaRepositoryProvider = Provider<TataKelolaKeuanganDesaRepository>((ref) {
  return TataKelolaKeuanganDesaRepository();
});

final tataKelolaKeuanganDesaProvider = Provider<TataKelolaKeuanganDesaOperations>((ref) {
  return TataKelolaKeuanganDesaOperations(ref.read(tataKelolaKeuanganDesaRepositoryProvider));
});

class TataKelolaKeuanganDesaOperations {
  final TataKelolaKeuanganDesaRepository _repository;

  TataKelolaKeuanganDesaOperations(this._repository);

  Future<Map<String, dynamic>> createTataKelolaKeuanganDesa(TataKelolaKeuanganDesa data) async {
    return await _repository.createTataKelolaKeuanganDesa(data);
  }
}
