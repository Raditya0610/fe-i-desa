import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/produksi_desa.dart';
import '../data/repositories/produksi_desa_repository.dart';

final produksiDesaRepositoryProvider = Provider<ProduksiDesaRepository>((ref) {
  return ProduksiDesaRepository();
});

final produksiDesaProvider = Provider<ProduksiDesaOperations>((ref) {
  return ProduksiDesaOperations(ref.read(produksiDesaRepositoryProvider));
});

class ProduksiDesaOperations {
  final ProduksiDesaRepository _repository;

  ProduksiDesaOperations(this._repository);

  Future<Map<String, dynamic>> createProduksiDesa(ProduksiDesa data) async {
    return await _repository.createProduksiDesa(data);
  }
}
