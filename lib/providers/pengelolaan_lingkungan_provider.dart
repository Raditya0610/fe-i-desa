import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/pengelolaan_lingkungan.dart';
import '../data/repositories/pengelolaan_lingkungan_repository.dart';

final pengelolaanLingkunganRepositoryProvider = Provider<PengelolaanLingkunganRepository>((ref) {
  return PengelolaanLingkunganRepository();
});

final pengelolaanLingkunganProvider = Provider<PengelolaanLingkunganOperations>((ref) {
  return PengelolaanLingkunganOperations(ref.read(pengelolaanLingkunganRepositoryProvider));
});

class PengelolaanLingkunganOperations {
  final PengelolaanLingkunganRepository _repository;

  PengelolaanLingkunganOperations(this._repository);

  Future<Map<String, dynamic>> createPengelolaanLingkungan(PengelolaanLingkungan data) async {
    return await _repository.createPengelolaanLingkungan(data);
  }
}
