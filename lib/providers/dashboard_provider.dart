import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/dashboard.dart';
import '../data/repositories/dashboard_repository.dart';

// Dashboard Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

// Dashboard Provider
final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(ref.read(dashboardRepositoryProvider));
});

// Dashboard State
class DashboardState {
  final Dashboard? dashboard;
  final bool isLoading;
  final String? error;

  DashboardState({
    this.dashboard,
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    Dashboard? dashboard,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      dashboard: dashboard ?? this.dashboard,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Dashboard Notifier
class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardRepository _repository;

  DashboardNotifier(this._repository) : super(DashboardState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final dashboard = await _repository.getDashboard();

      if (dashboard != null) {
        state = state.copyWith(dashboard: dashboard, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Gagal memuat data dashboard',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Terjadi kesalahan: $e',
      );
    }
  }

  Future<void> refresh() async {
    await loadDashboard();
  }
}
