import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/villager.dart';
import '../data/repositories/villager_repository.dart';

// Villager Repository Provider
final villagerRepositoryProvider = Provider<VillagerRepository>((ref) {
  return VillagerRepository();
});

// Villager Operations Provider
final villagerProvider = Provider<VillagerOperations>((ref) {
  return VillagerOperations(ref.read(villagerRepositoryProvider));
});

// Villagers State Notifier
final villagersProvider = StateNotifierProvider<VillagersNotifier, VillagersState>((ref) {
  return VillagersNotifier(ref.read(villagerRepositoryProvider));
});

// Villagers State
class VillagersState {
  final List<Villager> villagers;
  final bool isLoading;
  final String? error;

  VillagersState({
    this.villagers = const [],
    this.isLoading = false,
    this.error,
  });

  VillagersState copyWith({
    List<Villager>? villagers,
    bool? isLoading,
    String? error,
  }) {
    return VillagersState(
      villagers: villagers ?? this.villagers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Villagers Notifier
class VillagersNotifier extends StateNotifier<VillagersState> {
  final VillagerRepository _repository;

  VillagersNotifier(this._repository) : super(VillagersState()) {
    loadVillagers();
  }

  Future<void> loadVillagers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final villagers = await _repository.getAllVillagers();
      state = state.copyWith(villagers: villagers, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Gagal memuat data penduduk: $e',
      );
    }
  }

  Future<void> refresh() async {
    await loadVillagers();
  }
}

// Villager Operations
class VillagerOperations {
  final VillagerRepository _repository;

  VillagerOperations(this._repository);

  Future<List<Villager>> getAllVillagers() async {
    return await _repository.getAllVillagers();
  }

  Future<Map<String, dynamic>> createVillager(Villager villager) async {
    return await _repository.createVillager(villager);
  }

  Future<Map<String, dynamic>> updateVillager(
    String nik,
    Map<String, dynamic> data,
  ) async {
    return await _repository.updateVillager(nik, data);
  }

  Future<Map<String, dynamic>> deleteVillager(String nik) async {
    return await _repository.deleteVillager(nik);
  }
}
