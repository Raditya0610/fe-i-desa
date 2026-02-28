import '../models/sub_dimensions/tata_kelola_keuangan_desa.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class TataKelolaKeuanganDesaRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> createTataKelolaKeuanganDesa(TataKelolaKeuanganDesa data) async {
    try {
      final response = await _apiService.post(
        ApiConstants.subDimensionTataKelolaKeuanganDesa,
        data: data.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Data tata kelola keuangan desa berhasil disimpan',
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
