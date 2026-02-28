import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sub_dimensions/fasilitas_masyarakat.dart';
import '../data/repositories/fasilitas_masyarakat_repository.dart';

final fasilitasMasyarakatRepositoryProvider = Provider<FasilitasMasyarakatRepository>((ref) {
  return FasilitasMasyarakatRepository();
});

final fasilitasMasyarakatProvider = Provider<FasilitasMasyarakatOperations>((ref) {
  return FasilitasMasyarakatOperations(ref.read(fasilitasMasyarakatRepositoryProvider));
});

class FasilitasMasyarakatOperations {
  final FasilitasMasyarakatRepository _repository;

  FasilitasMasyarakatOperations(this._repository);

  Future<Map<String, dynamic>> createFasilitasMasyarakat(FasilitasMasyarakat data) async {
    return await _repository.createFasilitasMasyarakat(data);
  }
}
