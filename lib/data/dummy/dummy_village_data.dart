import '../models/village.dart';

/// Dummy village data for testing and development
///
/// Contains three villages:
/// - Iso
/// - Wain Baru
/// - Disuk
class DummyVillageData {
  static final List<Village> villages = [
    Village(
      id: '550e8400-e29b-41d4-a716-446655440001',
      name: 'Iso',
    ),
    Village(
      id: '550e8400-e29b-41d4-a716-446655440002',
      name: 'Wain Baru',
    ),
    Village(
      id: '550e8400-e29b-41d4-a716-446655440003',
      name: 'Disuk',
    ),
  ];

  /// Get village by ID
  static Village? getVillageById(String id) {
    try {
      return villages.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get village by name
  static Village? getVillageByName(String name) {
    try {
      return villages.firstWhere(
        (v) => v.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get all villages as JSON
  static List<Map<String, dynamic>> getVillagesJson() {
    return villages.map((v) => v.toJson()).toList();
  }
}
