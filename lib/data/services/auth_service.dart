import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/api_constants.dart';
import '../../core/config/app_config.dart';
import 'api_service.dart';
import 'mock_api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final MockApiService _mockApiService = MockApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // In-memory storage for mock mode or when secure storage fails (macOS keychain issues)
  static final Map<String, String> _mockStorage = {};
  static bool _useInMemoryStorage = false;

  // Get the appropriate API service based on config
  dynamic get _api => AppConfig.useMockApi ? _mockApiService : _apiService;

  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'username';
  static const String _villageIdKey = 'village_id';

  // Helper methods for storage abstraction
  Future<void> _write(String key, String value) async {
    if (AppConfig.useMockApi || _useInMemoryStorage) {
      _mockStorage[key] = value;
    } else {
      try {
        await _storage.write(key: key, value: value);
      } catch (e) {
        // Fallback to in-memory storage on macOS keychain error
        print('[AUTH SERVICE] Secure storage failed, using in-memory storage: $e');
        _useInMemoryStorage = true;
        _mockStorage[key] = value;
      }
    }
  }

  Future<String?> _read(String key) async {
    if (AppConfig.useMockApi || _useInMemoryStorage) {
      return _mockStorage[key];
    } else {
      try {
        return await _storage.read(key: key);
      } catch (e) {
        // Fallback to in-memory storage on macOS keychain error
        print('[AUTH SERVICE] Secure storage failed, using in-memory storage: $e');
        _useInMemoryStorage = true;
        return _mockStorage[key];
      }
    }
  }

  Future<void> _deleteAll() async {
    if (AppConfig.useMockApi || _useInMemoryStorage) {
      _mockStorage.clear();
    } else {
      try {
        await _storage.deleteAll();
      } catch (e) {
        // Fallback to in-memory storage on macOS keychain error
        _useInMemoryStorage = true;
        _mockStorage.clear();
      }
    }
  }

  // Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _api.post(
        ApiConstants.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final token = data['token'] as String;

        // Save token and username
        await _write(_tokenKey, token);
        await _write(_usernameKey, username);

        // Extract and save village_id if available in response
        if (data.containsKey('user')) {
          final user = data['user'] as Map<String, dynamic>;
          if (user.containsKey('village_id')) {
            final villageId = user['village_id'] as String;
            await _write(_villageIdKey, villageId);
          }
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Login berhasil',
          'token': token,
        };
      } else {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': false,
          'message': ApiService.getResponseError(data, fallback: 'Login gagal'),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': ApiService.getErrorMessage(e),
      };
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      await _api.post(ApiConstants.logout);

      // Clear storage and cookies
      await _deleteAll();
      if (AppConfig.useMockApi) {
        await _mockApiService.clearAuth();
      } else {
        await _apiService.clearCookies();
      }

      return {
        'success': true,
        'message': 'Logout berhasil',
      };
    } catch (e) {
      // Even if the API call fails, clear local data
      await _deleteAll();
      if (AppConfig.useMockApi) {
        await _mockApiService.clearAuth();
      } else {
        await _apiService.clearCookies();
      }

      return {
        'success': true,
        'message': 'Logout berhasil',
      };
    }
  }

  // Register User
  Future<Map<String, dynamic>> register(
    String username,
    String password,
    String villageId,
  ) async {
    try {
      final response = await _api.post(
        ApiConstants.register,
        data: {
          'username': username,
          'password': password,
          'village_id': villageId,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Registrasi berhasil',
        };
      } else {
        final data = response.data as Map<String, dynamic>;
        return {
          'success': false,
          'message': ApiService.getResponseError(data, fallback: 'Registrasi gagal'),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': ApiService.getErrorMessage(e),
      };
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _read(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Get stored token
  Future<String?> getToken() async {
    return await _read(_tokenKey);
  }

  // Get stored username
  Future<String?> getUsername() async {
    return await _read(_usernameKey);
  }

  // Get stored village ID
  Future<String?> getVillageId() async {
    return await _read(_villageIdKey);
  }

  // Save village ID
  Future<void> saveVillageId(String villageId) async {
    await _write(_villageIdKey, villageId);
  }
}
