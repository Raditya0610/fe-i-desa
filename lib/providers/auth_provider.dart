import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/auth_service.dart';
import '../data/services/api_service.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

// Auth State
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? username;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.isLoading = true,  // Start with loading=true so router waits for auth check
    this.username,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? username,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      error: error,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    final isLoggedIn = await _authService.isLoggedIn();
    final username = await _authService.getUsername();

    // Restore the ApiService token cache so the Dio interceptor can attach
    // Authorization: Bearer on all requests after a page refresh.
    if (isLoggedIn) {
      final token = await _authService.getToken();
      if (token != null && token.isNotEmpty) {
        ApiService.setToken(token);
        print('[AUTH PROVIDER] Token cache restored from storage.');
      }
    } else {
      ApiService.clearToken();
    }

    state = state.copyWith(
      isAuthenticated: isLoggedIn,
      username: username,
      isLoading: false,
    );
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    print('[AUTH PROVIDER] Login started for: $username');
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authService.login(username, password);
    print('[AUTH PROVIDER] Login result: ${result['success']}');

    if (result['success']) {
      print('[AUTH PROVIDER] Setting authenticated state to true');
      state = state.copyWith(
        isAuthenticated: true,
        username: username,
        isLoading: false,
      );
      print('[AUTH PROVIDER] State updated - isAuthenticated: ${state.isAuthenticated}');
    } else {
      print('[AUTH PROVIDER] Login failed: ${result['message']}');
      state = state.copyWith(
        isAuthenticated: false,
        isLoading: false,
        error: result['message'],
      );
    }

    return result;
  }

  Future<Map<String, dynamic>> register(
    String username,
    String password,
    String villageId,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authService.register(username, password, villageId);

    state = state.copyWith(isLoading: false);

    return result;
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _authService.logout();
    state = AuthState(isAuthenticated: false, isLoading: false);
  }
}
