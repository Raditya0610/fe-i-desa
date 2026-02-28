import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/fasilitas_pendukung_ekonomi.dart';
import '../data/repositories/fasilitas_pendukung_ekonomi_repository.dart';

final fasilitasPendukungEkonomiRepositoryProvider = Provider<FasilitasPendukungEkonomiRepository>((ref) {
  return FasilitasPendukungEkonomiRepository();
});

final fasilitasPendukungEkonomiProvider = Provider<FasilitasPendukungEkonomiOperations>((ref) {
  return FasilitasPendukungEkonomiOperations(ref.read(fasilitasPendukungEkonomiRepositoryProvider));
});

class FasilitasPendukungEkonomiOperations {
  final FasilitasPendukungEkonomiRepository _repository;

  FasilitasPendukungEkonomiOperations(this._repository);

  Future<Map<String, dynamic>> createFasilitasPendukungEkonomi(FasilitasPendukungEkonomi data) async {
    return await _repository.createFasilitasPendukungEkonomi(data);
  }
}
