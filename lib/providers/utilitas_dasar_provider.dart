import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/utilitas_dasar.dart';
import '../data/repositories/utilitas_dasar_repository.dart';

final utilitasDasarRepositoryProvider = Provider<UtilitasDasarRepository>((ref) {
  return UtilitasDasarRepository();
});

final utilitasDasarProvider = Provider<UtilitasDasarOperations>((ref) {
  return UtilitasDasarOperations(ref.read(utilitasDasarRepositoryProvider));
});

class UtilitasDasarOperations {
  final UtilitasDasarRepository _repository;

  UtilitasDasarOperations(this._repository);

  Future<Map<String, dynamic>> createUtilitasDasar(UtilitasDasar data) async {
    return await _repository.createUtilitasDasar(data);
  }
}
