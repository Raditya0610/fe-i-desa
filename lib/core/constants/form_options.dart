/// Centralized form dropdown options for sub-dimension forms
/// These options must match the backend validation in be-apps-i-desa/constants/form_enums.go
class FormOptions {
  // Ketersediaan - Availability options
  static const List<String> ketersediaan = ['Tersedia', 'Tidak Tersedia'];

  // KemudahanAkses - Accessibility options
  static const List<String> kemudahanAkses = ['Mudah', 'Sedang', 'Sulit'];

  // Keberadaan - Existence options
  static const List<String> keberadaan = ['Ada', 'Tidak Ada'];

  // Frekuensi - Frequency options
  static const List<String> frekuensi = ['Rutin', 'Kadang-kadang', 'Tidak Ada'];

  // Status - Active status options
  static const List<String> status = ['Aktif', 'Tidak Aktif'];

  // Tingkat - Level options
  static const List<String> tingkat = ['Tinggi', 'Sedang', 'Rendah'];

  // Kualitas - Quality options
  static const List<String> kualitas = ['Baik', 'Cukup', 'Buruk'];

  // Keberfungsian - Function options
  static const List<String> keberfungsian = ['Berfungsi', 'Tidak Berfungsi'];

  // YaTidak - Yes/No options
  static const List<String> yaTidak = ['Ya', 'Tidak'];

  // HariOperasional - Operational days options
  static const List<String> hariOperasional = [
    'Setiap Hari',
    'Tertentu',
    'Tidak Ada'
  ];

  // Dipertahankan - Preservation status options
  static const List<String> dipertahankan = [
    'Dipertahankan',
    'Tidak Dipertahankan'
  ];

  // Dilakukan - Activity done options
  static const List<String> dilakukan = ['Dilakukan', 'Tidak Dilakukan'];

  // Keragaman - Diversity options
  static const List<String> keragaman = ['Beragam', 'Tidak Beragam'];

  // Keaktifan - Activeness options
  static const List<String> keaktifan = ['Aktif', 'Cukup Aktif', 'Kurang Aktif'];

  // Kelengkapan - Completeness options
  static const List<String> kelengkapan = ['Lengkap', 'Cukup', 'Kurang'];

  // FrekuensiMusyawarah - Meeting frequency options
  static const List<String> frekuensiMusyawarah = [
    'Rutin',
    'Kadang-kadang',
    'Tidak Ada'
  ];

  // OperasionalAngkutan - Transport operation options
  static const List<String> operasionalAngkutan = [
    'Setiap Hari',
    'Tertentu',
    'Tidak Ada'
  ];

  // DurasiLayanan - Service duration options
  static const List<String> durasiLayanan = [
    '24 Jam',
    'Tertentu',
    'Tidak Ada'
  ];

  // Peningkatan - Increase/improvement options
  static const List<String> peningkatan = ['Meningkat', 'Stabil', 'Menurun'];

  // CakupanPasar - Market coverage options
  static const List<String> cakupanPasar = [
    'Lokal',
    'Regional',
    'Nasional',
    'Internasional'
  ];

  // Cakupan - Coverage/scope options
  static const List<String> cakupan = [
    'Lokal',
    'Regional',
    'Nasional',
    'Internasional'
  ];

  // JenisPermukaan - Road surface type options
  static const List<String> jenisPermukaan = [
    'Aspal',
    'Beton',
    'Tanah',
    'Kerikil'
  ];

  // Penerangan - Lighting options
  static const List<String> penerangan = ['Ada', 'Tidak Ada'];

  // OperasionalPju - Street light operation options
  static const List<String> operasionalPju = [
    'Berfungsi',
    'Tidak Berfungsi',
    'Sebagian'
  ];

  // Pelayanan - Service quality options
  static const List<String> pelayanan = ['Baik', 'Cukup', 'Buruk'];

  // Durasi - Duration options
  static const List<String> durasi = ['24 Jam', 'Sebagian Waktu', 'Tidak Ada'];

  // Akses - Access options
  static const List<String> akses = ['Ada', 'Tidak Ada'];
}
