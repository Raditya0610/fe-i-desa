import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/kondisi_akses_jalan.dart';
import '../data/repositories/kondisi_akses_jalan_repository.dart';

final kondisiAksesJalanRepositoryProvider = Provider<KondisiAksesJalanRepository>((ref) {
  return KondisiAksesJalanRepository();
});

final kondisiAksesJalanProvider = Provider<KondisiAksesJalanOperations>((ref) {
  return KondisiAksesJalanOperations(ref.read(kondisiAksesJalanRepositoryProvider));
});

class KondisiAksesJalanOperations {
  final KondisiAksesJalanRepository _repository;

  KondisiAksesJalanOperations(this._repository);

  Future<Map<String, dynamic>> createKondisiAksesJalan(KondisiAksesJalan data) async {
    return await _repository.createKondisiAksesJalan(data);
  }
}
