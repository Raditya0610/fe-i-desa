import '../models/sub_dimensions/kondisi_akses_jalan.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class KondisiAksesJalanRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> createKondisiAksesJalan(KondisiAksesJalan data) async {
    try {
      final response = await _apiService.post(
        ApiConstants.subDimensionKondisiAksesJalan,
        data: data.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Data kondisi akses jalan berhasil disimpan',
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
