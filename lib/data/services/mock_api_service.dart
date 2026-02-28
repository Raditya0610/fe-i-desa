import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../dummy/dummy_auth_data.dart';
import '../dummy/dummy_village_data.dart';
import '../dummy/dummy_dashboard_data.dart';
import '../dummy/dummy_villager_data.dart';

/// Mock API Service for testing and offline development
///
/// Returns dummy data without requiring the backend to be running.
/// Simulates realistic API delays (200-500ms) and responses.
class MockApiService {
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;

  MockApiService._internal();

  // Simulated authenticated user (set after login)
  String? _currentUsername;
  String? _currentVillageId;
  bool _isAuthenticated = false;

  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Helper method to get village name
  String _getVillageName(String villageId) {
    final villageNames = {
      '550e8400-e29b-41d4-a716-446655440001': 'Iso',
      '550e8400-e29b-41d4-a716-446655440002': 'Wain Baru',
      '550e8400-e29b-41d4-a716-446655440003': 'Disuk',
    };
    return villageNames[villageId] ?? 'Unknown';
  }

  // Check if user is authenticated
  bool get isAuthenticated => _isAuthenticated;
  String? get currentUsername => _currentUsername;
  String? get currentVillageId => _currentVillageId;

  // Clear authentication (for logout)
  Future<void> clearAuth() async {
    _currentUsername = null;
    _currentVillageId = null;
    _isAuthenticated = false;
  }

  // Generic GET request handler
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    print('[MOCK REQUEST] GET $path');
    await _simulateDelay();

    try {
      final data = _handleGetRequest(path, queryParameters);
      print('[MOCK RESPONSE] 200 $path');
      print('[MOCK RESPONSE DATA] $data');

      return Response(
        requestOptions: RequestOptions(path: path),
        data: data,
        statusCode: 200,
      );
    } catch (e) {
      print('[MOCK ERROR] $path: $e');
      return Response(
        requestOptions: RequestOptions(path: path),
        data: {'message': e.toString()},
        statusCode: 400,
      );
    }
  }

  // Generic POST request handler
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    print('[MOCK REQUEST] POST $path');
    print('[MOCK REQUEST BODY] $data');
    await _simulateDelay();

    try {
      final responseData = _handlePostRequest(path, data);
      final statusCode = path == ApiConstants.login ? 200 : 201;

      print('[MOCK RESPONSE] $statusCode $path');
      print('[MOCK RESPONSE DATA] $responseData');

      return Response(
        requestOptions: RequestOptions(path: path),
        data: responseData,
        statusCode: statusCode,
      );
    } catch (e) {
      print('[MOCK ERROR] $path: $e');
      return Response(
        requestOptions: RequestOptions(path: path),
        data: {'message': e.toString()},
        statusCode: 400,
      );
    }
  }

  // Handle GET requests
  dynamic _handleGetRequest(
    String path,
    Map<String, dynamic>? queryParameters,
  ) {
    // Dashboard
    if (path == ApiConstants.dashboard) {
      if (!_isAuthenticated || _currentVillageId == null) {
        throw Exception('Unauthorized');
      }
      return DummyDashboardData.getDashboardJsonByVillageId(_currentVillageId!);
    }

    // Villages
    if (path == ApiConstants.villages) {
      return DummyVillageData.getVillagesJson();
    }

    // Family Cards
    if (path == ApiConstants.familyCards) {
      if (!_isAuthenticated || _currentVillageId == null) {
        throw Exception('Unauthorized');
      }

      // Get all villagers for current village
      final villagers = DummyVillagerData.getVillagersByVillageId(_currentVillageId!);

      // Group villagers by family card ID
      final Map<String, List<dynamic>> familyGroups = {};
      for (var villager in villagers) {
        final fkId = villager.familyCardId;
        if (fkId == null) continue;
        if (!familyGroups.containsKey(fkId)) {
          familyGroups[fkId] = [];
        }
        familyGroups[fkId]!.add({
          'nik': villager.nik,
          'nama_lengkap': villager.namaLengkap,
          'jenis_kelamin': villager.jenisKelamin,
          'tempat_lahir': villager.tempatLahir,
          'tanggal_lahir': villager.tanggalLahir.toIso8601String(),
          'agama': villager.agama,
          'pendidikan': villager.pendidikan,
          'pekerjaan': villager.pekerjaan,
          'status_perkawinan': villager.statusPerkawinan,
          'status_hubungan': villager.statusHubungan,
          'kewarganegaraan': villager.kewarganegaraan,
          'nama_ayah': villager.namaAyah,
          'nama_ibu': villager.namaIbu,
        });
      }

      // Build family cards array
      final familyCards = familyGroups.entries.map((entry) {
        final familyCardId = entry.key;
        final members = entry.value;

        // Get head of family for address details
        final headOfFamily = villagers.firstWhere(
          (v) => v.familyCardId == familyCardId && v.statusHubungan == 'Kepala Keluarga',
          orElse: () => villagers.first,
        );

        return {
          'nik': familyCardId,
          'name': headOfFamily.namaLengkap,
          'address': 'Jl. ${headOfFamily.namaLengkap}, RT 001/RW 002, Desa ${_getVillageName(_currentVillageId!)}',
          'total_members': members.length,
          'family_members': members,
        };
      }).toList();

      return {
        'family_cards': familyCards,
      };
    }

    // Family Card by NIK
    if (path.startsWith('${ApiConstants.familyCards}/')) {
      final nik = path.split('/').last;
      return {
        'nik': nik,
        'address': 'Mock Address',
        'family_members': [
          {
            'name': 'Mock Family Head',
            'status_hubungan': 'Kepala Keluarga',
            'age': 40,
            'jenis_kelamin': 'Laki-laki',
            'pendidikan': 'SLTA/Sederajat',
            'pekerjaan': 'PNS',
          },
        ],
      };
    }

    // Villagers
    if (path == ApiConstants.villagers) {
      if (!_isAuthenticated || _currentVillageId == null) {
        throw Exception('Unauthorized');
      }
      return DummyVillagerData.getVillagersJsonByVillageId(_currentVillageId!);
    }

    // Villager by NIK
    if (path.startsWith('${ApiConstants.villagers}/')) {
      final nik = path.split('/').last;
      final villager = DummyVillagerData.getVillagerByNik(nik);
      if (villager == null) {
        throw Exception('Villager not found');
      }
      return villager.toJson();
    }

    throw Exception('Mock endpoint not implemented: $path');
  }

  // Handle POST requests
  dynamic _handlePostRequest(String path, dynamic data) {
    // Login
    if (path == ApiConstants.login) {
      final Map<String, dynamic> loginData = data as Map<String, dynamic>;
      final username = loginData['username'] as String;
      final password = loginData['password'] as String;

      final response = DummyAuthData.mockLoginResponse(username, password);

      // Set authenticated state
      _currentUsername = username;
      final user = DummyAuthData.getUserByUsername(username);
      _currentVillageId = user?['village_id'] as String?;
      _isAuthenticated = true;

      return response;
    }

    // Logout
    if (path == ApiConstants.logout) {
      clearAuth();
      return {'message': 'Logout berhasil'};
    }

    // Register
    if (path == ApiConstants.register) {
      final Map<String, dynamic> registerData = data as Map<String, dynamic>;
      final username = registerData['username'] as String;
      final password = registerData['password'] as String;
      final villageId = registerData['village_id'] as String;

      return DummyAuthData.mockRegisterResponse(username, password, villageId);
    }

    // Create Family Card
    if (path == ApiConstants.familyCards) {
      if (!_isAuthenticated) {
        throw Exception('Unauthorized');
      }
      return {
        'message': 'Family card created successfully (mock)',
        'data': data,
      };
    }

    // Create Villager
    if (path == ApiConstants.villagers) {
      if (!_isAuthenticated) {
        throw Exception('Unauthorized');
      }
      return {
        'message': 'Villager created successfully (mock)',
        'data': data,
      };
    }

    throw Exception('Mock endpoint not implemented: $path');
  }

  // Handle API errors (compatibility with real ApiService)
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null) {
        if (error.response!.data is Map) {
          final data = error.response!.data as Map<String, dynamic>;
          return data['message'] ?? data['error'] ?? 'Terjadi kesalahan';
        }
        return error.response!.data.toString();
      }
      return 'Terjadi kesalahan koneksi';
    }
    return error.toString();
  }
}
