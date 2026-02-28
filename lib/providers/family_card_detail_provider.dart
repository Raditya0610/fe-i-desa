import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/family_card_detail.dart';
import '../data/repositories/family_card_repository.dart';

// Family Card Detail Provider
final familyCardDetailProvider =
    FutureProvider.family<FamilyCardDetail?, String>((ref, nik) async {
  final repository = FamilyCardRepository();
  return await repository.getFamilyCardDetail(nik);
});
