import '../models/sub_dimensions/utilitas_dasar.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class UtilitasDasarRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> createUtilitasDasar(UtilitasDasar data) async {
    try {
      final response = await _apiService.post(
        ApiConstants.subDimensionUtilitasDasar,
        data: data.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Data utilitas dasar berhasil disimpan',
        };
      } else {
        final responseData = response.data as Map<String, dynamic>;
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal menyimpan data',
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
