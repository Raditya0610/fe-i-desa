import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import '../../core/constants/api_constants.dart';
import 'auth_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  late final CookieJar _cookieJar;

  ApiService._internal() {
    _cookieJar = CookieJar();

    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: ApiConstants.defaultHeaders,
      validateStatus: (status) {
        // Accept all status codes to handle errors manually
        return status != null && status < 500;
      },
    ));

    // Add cookie manager interceptor (still useful for native platforms)
    _dio.interceptors.add(CookieManager(_cookieJar));

    // Add Bearer token interceptor — attaches the stored JWT as Authorization header.
    // This is required for cross-origin deployments (e.g., Flutter web on Vercel
    // calling a backend on Railway) where SameSite cookie policies block cookies.
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Read token via AuthService so we use the same storage layer
        // (including the in-memory fallback) that the login flow writes to.
        final token = await AuthService.getStoredToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('[REQUEST] ${options.method} ${options.uri}');
        print('[REQUEST HEADERS] ${options.headers}');
        if (options.data != null) {
          print('[REQUEST BODY] ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('[RESPONSE] ${response.statusCode} ${response.requestOptions.uri}');
        print('[RESPONSE DATA] ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        print('[ERROR] ${error.requestOptions.uri}');
        print('[ERROR MESSAGE] ${error.message}');
        if (error.response != null) {
          print('[ERROR RESPONSE] ${error.response?.data}');
        }
        return handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;
  CookieJar get cookieJar => _cookieJar;

  // Clear cookies (for logout)
  Future<void> clearCookies() async {
    await _cookieJar.deleteAll();
  }

  // Generic GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Generic POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Generic PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Generic DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Extract error message from a response map, checking both lowercase and
  // capitalized keys (BE villager controller returns "Message"/"Error").
  static String getResponseError(Map<String, dynamic> data, {String fallback = 'Terjadi kesalahan'}) {
    return data['message'] ?? data['Message'] ?? data['error'] ?? data['Error'] ?? fallback;
  }

  // Handle API errors
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      if (error.response?.data != null) {
        if (error.response!.data is Map) {
          final data = error.response!.data as Map<String, dynamic>;
          return getResponseError(data);
        }
        return error.response!.data.toString();
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Koneksi timeout. Periksa koneksi internet Anda.';
        case DioExceptionType.badResponse:
          return 'Server error. Silakan coba lagi nanti.';
        case DioExceptionType.cancel:
          return 'Permintaan dibatalkan.';
        default:
          return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
      }
    }
    return error.toString();
  }
}
