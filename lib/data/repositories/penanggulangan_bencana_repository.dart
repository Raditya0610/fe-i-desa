import '../models/sub_dimensions/penanggulangan_bencana.dart';
import '../services/api_service.dart';
import '../../core/constants/api_constants.dart';

class PenanggulanganBencanaRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> createPenanggulanganBencana(PenanggulanganBencana data) async {
    try {
      final response = await _apiService.post(
        ApiConstants.subDimensionPenanggulanganBencana,
        data: data.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Data penanggulangan bencana berhasil disimpan',
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
