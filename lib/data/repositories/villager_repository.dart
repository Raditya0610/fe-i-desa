import '../models/villager.dart';
import '../services/api_service.dart';
import '../services/mock_api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../core/config/app_config.dart';

class VillagerRepository {
  final ApiService _apiService = ApiService();
  final MockApiService _mockApiService = MockApiService();

  // Get the appropriate API service based on config
  dynamic get _api => AppConfig.useMockApi ? _mockApiService : _apiService;

  Future<List<Villager>> getAllVillagers({int page = 1, int limit = 100}) async {
    try {
      final response = await _api.get(
        ApiConstants.villagers,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final villagers = (data['data'] ?? data['villagers']) as List;
        return villagers
            .map((json) => Villager.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching villagers: ${ApiService.getErrorMessage(e)}');
      return [];
    }
  }

  Future<Map<String, dynamic>> createVillager(Villager villager) async {
    try {
      final response = await _api.post(
        ApiConstants.villagers,
        data: villager.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Penduduk berhasil ditambahkan',
        };
      } else {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': false,
          'message': ApiService.getResponseError(data, fallback: 'Gagal menambahkan penduduk'),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': ApiService.getErrorMessage(e),
      };
    }
  }

  Future<Map<String, dynamic>> updateVillager(
    String nik,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _api.put(
        ApiConstants.villagerByNik(nik),
        data: data,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Penduduk berhasil diperbarui',
        };
      } else {
        final responseData = response.data as Map<String, dynamic>;
        return {
          'success': false,
          'message': ApiService.getResponseError(responseData, fallback: 'Gagal memperbarui penduduk'),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': ApiService.getErrorMessage(e),
      };
    }
  }

  Future<Map<String, dynamic>> deleteVillager(String nik) async {
    try {
      final response = await _api.delete(
        ApiConstants.villagerByNik(nik),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Penduduk berhasil dihapus',
        };
      } else {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': false,
          'message': ApiService.getResponseError(data, fallback: 'Gagal menghapus penduduk'),
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
