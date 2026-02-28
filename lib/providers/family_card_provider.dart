import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/family_card.dart';
import '../data/repositories/family_card_repository.dart';

// Family Card Repository Provider
final familyCardRepositoryProvider = Provider<FamilyCardRepository>((ref) {
  return FamilyCardRepository();
});

// Family Cards Provider
final familyCardsProvider = StateNotifierProvider<FamilyCardsNotifier, FamilyCardsState>((ref) {
  return FamilyCardsNotifier(ref.read(familyCardRepositoryProvider));
});

// Family Cards State
class FamilyCardsState {
  final List<FamilyCard> familyCards;
  final bool isLoading;
  final String? error;

  FamilyCardsState({
    this.familyCards = const [],
    this.isLoading = false,
    this.error,
  });

  FamilyCardsState copyWith({
    List<FamilyCard>? familyCards,
    bool? isLoading,
    String? error,
  }) {
    return FamilyCardsState(
      familyCards: familyCards ?? this.familyCards,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Family Cards Notifier
class FamilyCardsNotifier extends StateNotifier<FamilyCardsState> {
  final FamilyCardRepository _repository;

  FamilyCardsNotifier(this._repository) : super(FamilyCardsState()) {
    loadFamilyCards();
  }

  Future<void> loadFamilyCards() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final familyCards = await _repository.getAllFamilyCards();
      state = state.copyWith(familyCards: familyCards, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Gagal memuat data kartu keluarga: $e',
      );
    }
  }

  Future<Map<String, dynamic>> addFamilyCard(FamilyCard familyCard) async {
    final result = await _repository.createFamilyCard(familyCard);

    if (result['success']) {
      await loadFamilyCards(); // Refresh the list
    }

    return result;
  }

  Future<void> refresh() async {
    await loadFamilyCards();
  }
}
