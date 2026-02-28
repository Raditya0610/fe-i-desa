import '../models/family_card.dart';
import '../models/family_card_detail.dart';
import '../services/api_service.dart';
import '../services/mock_api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../core/config/app_config.dart';

class FamilyCardRepository {
  final ApiService _apiService = ApiService();
  final MockApiService _mockApiService = MockApiService();

  // Get the appropriate API service based on config
  dynamic get _api => AppConfig.useMockApi ? _mockApiService : _apiService;

  Future<List<FamilyCard>> getAllFamilyCards() async {
    try {
      final response = await _api.get(ApiConstants.familyCards);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final familyCards = data['family_cards'] as List;
        return familyCards
            .map((json) => FamilyCard.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching family cards: ${ApiService.getErrorMessage(e)}');
      return [];
    }
  }

  Future<FamilyCard?> getFamilyCardById(String nik) async {
    try {
      final response = await _api.get(
        ApiConstants.familyCardById(nik),
      );

      if (response.statusCode == 200) {
        return FamilyCard.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching family card: ${ApiService.getErrorMessage(e)}');
      return null;
    }
  }

  Future<FamilyCardDetail?> getFamilyCardDetail(String nik) async {
    try {
      final response = await _api.get(
        ApiConstants.familyCardById(nik),
      );

      if (response.statusCode == 200) {
        return FamilyCardDetail.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching family card detail: ${ApiService.getErrorMessage(e)}');
      return null;
    }
  }

  Future<Map<String, dynamic>> createFamilyCard(FamilyCard familyCard) async {
    try {
      final response = await _api.post(
        ApiConstants.familyCards,
        data: familyCard.toCreateJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Kartu keluarga berhasil ditambahkan',
        };
      } else {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': false,
          'message': ApiService.getResponseError(data, fallback: 'Gagal menambahkan kartu keluarga'),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': ApiService.getErrorMessage(e),
      };
    }
  }
}
