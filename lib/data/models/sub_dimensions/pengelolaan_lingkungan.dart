class PengelolaanLingkungan {
  final String? id;
  final String villageId;
  final int year;
  final String upayaMenjagaKelestarianLingkungan;
  final String regulasiPelestarianLingkungan;
  final String kegiatanPelestarianLingkungan;
  final String pemanfaatanEnergiTerbarukan;
  final String tempatPembuananganSampah;
  final String pengelolaanSampah;
  final String pemanfaatanSampah;
  final String kejadianPencemaranLingkungan;
  final String ketersediaanJamban;
  final String keberfungsianJamban;
  final String ketersediaanSepticTank;
  final String pembuanganAirLimbahCairRumah;

  PengelolaanLingkungan({
    this.id,
    required this.villageId,
    required this.year,
    required this.upayaMenjagaKelestarianLingkungan,
    required this.regulasiPelestarianLingkungan,
    required this.kegiatanPelestarianLingkungan,
    required this.pemanfaatanEnergiTerbarukan,
    required this.tempatPembuananganSampah,
    required this.pengelolaanSampah,
    required this.pemanfaatanSampah,
    required this.kejadianPencemaranLingkungan,
    required this.ketersediaanJamban,
    required this.keberfungsianJamban,
    required this.ketersediaanSepticTank,
    required this.pembuanganAirLimbahCairRumah,
  });

  factory PengelolaanLingkungan.fromJson(Map<String, dynamic> json) {
    return PengelolaanLingkungan(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      upayaMenjagaKelestarianLingkungan: json['upaya_menjaga_kelestarian_lingkungan'] as String,
      regulasiPelestarianLingkungan: json['regulasi_pelestarian_lingkungan'] as String,
      kegiatanPelestarianLingkungan: json['kegiatan_pelestarian_lingkungan'] as String,
      pemanfaatanEnergiTerbarukan: json['pemanfaatan_energi_terbarukan'] as String,
      tempatPembuananganSampah: json['tempat_pembuanangan_sampah'] as String,
      pengelolaanSampah: json['pengelolaan_sampah'] as String,
      pemanfaatanSampah: json['pemanfaatan_sampah'] as String,
      kejadianPencemaranLingkungan: json['kejadian_pencemaran_lingkungan'] as String,
      ketersediaanJamban: json['ketersediaan_jamban'] as String,
      keberfungsianJamban: json['keberfungsian_jamban'] as String,
      ketersediaanSepticTank: json['ketersediaan_septic_tank'] as String,
      pembuanganAirLimbahCairRumah: json['pembuangan_air_limbah_cair_rumah'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'upaya_menjaga_kelestarian_lingkungan': upayaMenjagaKelestarianLingkungan,
      'regulasi_pelestarian_lingkungan': regulasiPelestarianLingkungan,
      'kegiatan_pelestarian_lingkungan': kegiatanPelestarianLingkungan,
      'pemanfaatan_energi_terbarukan': pemanfaatanEnergiTerbarukan,
      'tempat_pembuanangan_sampah': tempatPembuananganSampah,
      'pengelolaan_sampah': pengelolaanSampah,
      'pemanfaatan_sampah': pemanfaatanSampah,
      'kejadian_pencemaran_lingkungan': kejadianPencemaranLingkungan,
      'ketersediaan_jamban': ketersediaanJamban,
      'keberfungsian_jamban': keberfungsianJamban,
      'ketersediaan_septic_tank': ketersediaanSepticTank,
      'pembuangan_air_limbah_cair_rumah': pembuanganAirLimbahCairRumah,
    };
  }
}
