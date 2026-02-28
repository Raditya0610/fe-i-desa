import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/aktivitas.dart';
import '../data/repositories/aktivitas_repository.dart';

final aktivitasRepositoryProvider = Provider<AktivitasRepository>((ref) {
  return AktivitasRepository();
});

final aktivitasProvider = Provider<AktivitasOperations>((ref) {
  return AktivitasOperations(ref.read(aktivitasRepositoryProvider));
});

class AktivitasOperations {
  final AktivitasRepository _repository;

  AktivitasOperations(this._repository);

  Future<Map<String, dynamic>> createAktivitas(Aktivitas data) async {
    return await _repository.createAktivitas(data);
  }
}
