import '../models/dashboard.dart';

/// Dummy dashboard data for testing and development
///
/// Contains sample statistics for three villages:
/// - Iso
/// - Wain Baru
/// - Disuk
class DummyDashboardData {
  /// Dashboard data for Iso village
  static final Dashboard isoData = Dashboard(
    totalKeluarga: 145,
    totalPenduduk: 612,
    rerataKeluarga: 4.2,
    lakiLaki: 308,
    perempuan: 304,
    kepalaKeluarga: 145,
    rerataUmur: 31.5,
    rt: 7,
    rw: 3,
    kelurahan: 1,
    kecamatan: 1,
  );

  /// Dashboard data for Wain Baru village
  static final Dashboard wainBaruData = Dashboard(
    totalKeluarga: 187,
    totalPenduduk: 823,
    rerataKeluarga: 4.4,
    lakiLaki: 415,
    perempuan: 408,
    kepalaKeluarga: 187,
    rerataUmur: 33.2,
    rt: 9,
    rw: 4,
    kelurahan: 1,
    kecamatan: 1,
  );

  /// Dashboard data for Disuk village
  static final Dashboard disukData = Dashboard(
    totalKeluarga: 163,
    totalPenduduk: 701,
    rerataKeluarga: 4.3,
    lakiLaki: 352,
    perempuan: 349,
    kepalaKeluarga: 163,
    rerataUmur: 32.8,
    rt: 8,
    rw: 3,
    kelurahan: 1,
    kecamatan: 1,
  );

  /// Get dashboard data by village ID
  static Dashboard getDashboardByVillageId(String villageId) {
    switch (villageId) {
      case '550e8400-e29b-41d4-a716-446655440001': // Iso
        return isoData;
      case '550e8400-e29b-41d4-a716-446655440002': // Wain Baru
        return wainBaruData;
      case '550e8400-e29b-41d4-a716-446655440003': // Disuk
        return disukData;
      default:
        // Return default data if village not found
        return isoData;
    }
  }

  /// Get dashboard data as JSON by village ID
  static Map<String, dynamic> getDashboardJsonByVillageId(String villageId) {
    final dashboard = getDashboardByVillageId(villageId);
    return {
      'totalKeluarga': dashboard.totalKeluarga,
      'totalPenduduk': dashboard.totalPenduduk,
      'rerataKeluarga': dashboard.rerataKeluarga,
      'lakiLaki': dashboard.lakiLaki,
      'perempuan': dashboard.perempuan,
      'kepalaKeluarga': dashboard.kepalaKeluarga,
      'rerataUmur': dashboard.rerataUmur,
      'rt': dashboard.rt,
      'rw': dashboard.rw,
      'kelurahan': dashboard.kelurahan,
      'kecamatan': dashboard.kecamatan,
    };
  }

  /// Get all dashboard data as a map (village_id -> Dashboard)
  static Map<String, Dashboard> getAllDashboardData() {
    return {
      '550e8400-e29b-41d4-a716-446655440001': isoData,
      '550e8400-e29b-41d4-a716-446655440002': wainBaruData,
      '550e8400-e29b-41d4-a716-446655440003': disukData,
    };
  }
}
