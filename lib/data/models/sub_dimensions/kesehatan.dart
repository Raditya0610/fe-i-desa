class Kesehatan {
  final String? id;
  final String villageId;
  final int year;
  final String kemudahanAksesSaranaKesehatan;
  final String ketersediaanFasilitasKesehatan;
  final String kemudahanAksesFasilitasKesehatan;
  final String ketersediaanPosyandu;
  final String jumlahAktivitasPosyandu;
  final String kemudahanAksesPosyandu;
  final String ketersediaanLayananDokter;
  final String hariOperasionalLayananDokter;
  final String penyediaLayananDokter;
  final String penyediaTransportasiLayananDokter;
  final String ketersediaanLayananBidan;
  final String hariOperasionalLayananBidan;
  final String penyediaLayananBidan;
  final String penyediaTransportasiLayananBidan;
  final String ketersediaanLayananTenagaKesehatan;
  final String hariOperasionalLayananTenagaKesehatan;
  final String penyediaLayananTenagaKesehatan;
  final String penyediaTransportasiLayananTenagaKesehatan;
  final String persentasePesertaJaminanKesehatan;
  final String kegiatanSosialisasiJaminanKesehatan;

  Kesehatan({
    this.id,
    required this.villageId,
    required this.year,
    required this.kemudahanAksesSaranaKesehatan,
    required this.ketersediaanFasilitasKesehatan,
    required this.kemudahanAksesFasilitasKesehatan,
    required this.ketersediaanPosyandu,
    required this.jumlahAktivitasPosyandu,
    required this.kemudahanAksesPosyandu,
    required this.ketersediaanLayananDokter,
    required this.hariOperasionalLayananDokter,
    required this.penyediaLayananDokter,
    required this.penyediaTransportasiLayananDokter,
    required this.ketersediaanLayananBidan,
    required this.hariOperasionalLayananBidan,
    required this.penyediaLayananBidan,
    required this.penyediaTransportasiLayananBidan,
    required this.ketersediaanLayananTenagaKesehatan,
    required this.hariOperasionalLayananTenagaKesehatan,
    required this.penyediaLayananTenagaKesehatan,
    required this.penyediaTransportasiLayananTenagaKesehatan,
    required this.persentasePesertaJaminanKesehatan,
    required this.kegiatanSosialisasiJaminanKesehatan,
  });

  factory Kesehatan.fromJson(Map<String, dynamic> json) {
    return Kesehatan(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      kemudahanAksesSaranaKesehatan: json['kemudahan_akses_sarana_kesehatan'] as String,
      ketersediaanFasilitasKesehatan: json['ketersediaan_fasilitas_kesehatan'] as String,
      kemudahanAksesFasilitasKesehatan: json['kemudahan_akses_fasilitas_kesehatan'] as String,
      ketersediaanPosyandu: json['ketersediaan_posyandu'] as String,
      jumlahAktivitasPosyandu: json['jumlah_aktivitas_posyandu'] as String,
      kemudahanAksesPosyandu: json['kemudahan_akses_posyandu'] as String,
      ketersediaanLayananDokter: json['ketersediaan_layanan_dokter'] as String,
      hariOperasionalLayananDokter: json['hari_operasional_layanan_dokter'] as String,
      penyediaLayananDokter: json['penyedia_layanan_dokter'] as String,
      penyediaTransportasiLayananDokter: json['penyedia_transportasi_layanan_dokter'] as String,
      ketersediaanLayananBidan: json['ketersediaan_layanan_bidan'] as String,
      hariOperasionalLayananBidan: json['hari_operasional_layanan_bidan'] as String,
      penyediaLayananBidan: json['penyedia_layanan_bidan'] as String,
      penyediaTransportasiLayananBidan: json['penyedia_transportasi_layanan_bidan'] as String,
      ketersediaanLayananTenagaKesehatan: json['ketersediaan_layanan_tenaga_kesehatan'] as String,
      hariOperasionalLayananTenagaKesehatan: json['hari_operasional_layanan_tenaga_kesehatan'] as String,
      penyediaLayananTenagaKesehatan: json['penyedia_layanan_tenaga_kesehatan'] as String,
      penyediaTransportasiLayananTenagaKesehatan: json['penyedia_transportasi_layanan_tenaga_kesehatan'] as String,
      persentasePesertaJaminanKesehatan: json['persentase_peserta_jaminan_kesehatan'] as String,
      kegiatanSosialisasiJaminanKesehatan: json['kegiatan_sosialisasi_jaminan_kesehatan'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'kemudahan_akses_sarana_kesehatan': kemudahanAksesSaranaKesehatan,
      'ketersediaan_fasilitas_kesehatan': ketersediaanFasilitasKesehatan,
      'kemudahan_akses_fasilitas_kesehatan': kemudahanAksesFasilitasKesehatan,
      'ketersediaan_posyandu': ketersediaanPosyandu,
      'jumlah_aktivitas_posyandu': jumlahAktivitasPosyandu,
      'kemudahan_akses_posyandu': kemudahanAksesPosyandu,
      'ketersediaan_layanan_dokter': ketersediaanLayananDokter,
      'hari_operasional_layanan_dokter': hariOperasionalLayananDokter,
      'penyedia_layanan_dokter': penyediaLayananDokter,
      'penyedia_transportasi_layanan_dokter': penyediaTransportasiLayananDokter,
      'ketersediaan_layanan_bidan': ketersediaanLayananBidan,
      'hari_operasional_layanan_bidan': hariOperasionalLayananBidan,
      'penyedia_layanan_bidan': penyediaLayananBidan,
      'penyedia_transportasi_layanan_bidan': penyediaTransportasiLayananBidan,
      'ketersediaan_layanan_tenaga_kesehatan': ketersediaanLayananTenagaKesehatan,
      'hari_operasional_layanan_tenaga_kesehatan': hariOperasionalLayananTenagaKesehatan,
      'penyedia_layanan_tenaga_kesehatan': penyediaLayananTenagaKesehatan,
      'penyedia_transportasi_layanan_tenaga_kesehatan': penyediaTransportasiLayananTenagaKesehatan,
      'persentase_peserta_jaminan_kesehatan': persentasePesertaJaminanKesehatan,
      'kegiatan_sosialisasi_jaminan_kesehatan': kegiatanSosialisasiJaminanKesehatan,
    };
  }
}
