import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/penanggulangan_bencana.dart';
import '../data/repositories/penanggulangan_bencana_repository.dart';

final penanggulanganBencanaRepositoryProvider = Provider<PenanggulanganBencanaRepository>((ref) {
  return PenanggulanganBencanaRepository();
});

final penanggulanganBencanaProvider = Provider<PenanggulanganBencanaOperations>((ref) {
  return PenanggulanganBencanaOperations(ref.read(penanggulanganBencanaRepositoryProvider));
});

class PenanggulanganBencanaOperations {
  final PenanggulanganBencanaRepository _repository;

  PenanggulanganBencanaOperations(this._repository);

  Future<Map<String, dynamic>> createPenanggulanganBencana(PenanggulanganBencana data) async {
    return await _repository.createPenanggulanganBencana(data);
  }
}
