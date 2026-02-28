class FasilitasPendukungEkonomi {
  final String? id;
  final String villageId;
  final int year;
  final String ketersediaanPendidikanNonFormal;
  final String keterlibatanPendidikanNonFormal;
  final String ketersediaanPasarRakyat;
  final String kemudahanAksesPasarRakyat;
  final String ketersediaanToko;
  final String kemudahanAksesToko;
  final String ketersediaanRumahMakan;
  final String kemudahanAksesRumahMakan;
  final String ketersediaanPenginapan;
  final String kemudahanAksesPenginapan;
  final String ketersediaanLogistik;
  final String kemudahanAksesLogistik;
  final String terdapatBumd;
  final String bumdBerbadanHukum;
  final String hariOperasionalLembagaEkonomi;
  final String ketersediaanLembagaEkonomiLainnya;
  final String ketersediaanKud;
  final String ketersediaanUmkm;
  final String layananPerbankan;
  final String hariOperasionalKeuangan;
  final String layananFasilitasKreditKur;
  final String layananFasilitasKreditKkpE;
  final String layananFasilitasKreditKuk;
  final String statusLayananFasilitasKredit;

  FasilitasPendukungEkonomi({
    this.id,
    required this.villageId,
    required this.year,
    required this.ketersediaanPendidikanNonFormal,
    required this.keterlibatanPendidikanNonFormal,
    required this.ketersediaanPasarRakyat,
    required this.kemudahanAksesPasarRakyat,
    required this.ketersediaanToko,
    required this.kemudahanAksesToko,
    required this.ketersediaanRumahMakan,
    required this.kemudahanAksesRumahMakan,
    required this.ketersediaanPenginapan,
    required this.kemudahanAksesPenginapan,
    required this.ketersediaanLogistik,
    required this.kemudahanAksesLogistik,
    required this.terdapatBumd,
    required this.bumdBerbadanHukum,
    required this.hariOperasionalLembagaEkonomi,
    required this.ketersediaanLembagaEkonomiLainnya,
    required this.ketersediaanKud,
    required this.ketersediaanUmkm,
    required this.layananPerbankan,
    required this.hariOperasionalKeuangan,
    required this.layananFasilitasKreditKur,
    required this.layananFasilitasKreditKkpE,
    required this.layananFasilitasKreditKuk,
    required this.statusLayananFasilitasKredit,
  });

  factory FasilitasPendukungEkonomi.fromJson(Map<String, dynamic> json) {
    return FasilitasPendukungEkonomi(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      ketersediaanPendidikanNonFormal: json['ketersediaan_pendidikan_non_formal'] as String,
      keterlibatanPendidikanNonFormal: json['keterlibatan_pendidikan_non_formal'] as String,
      ketersediaanPasarRakyat: json['ketersediaan_pasar_rakyat'] as String,
      kemudahanAksesPasarRakyat: json['kemudahan_akses_pasar_rakyat'] as String,
      ketersediaanToko: json['ketersediaan_toko'] as String,
      kemudahanAksesToko: json['kemudahan_akses_toko'] as String,
      ketersediaanRumahMakan: json['ketersediaan_rumah_makan'] as String,
      kemudahanAksesRumahMakan: json['kemudahan_akses_rumah_makan'] as String,
      ketersediaanPenginapan: json['ketersediaan_penginapan'] as String,
      kemudahanAksesPenginapan: json['kemudahan_akses_penginapan'] as String,
      ketersediaanLogistik: json['ketersediaan_logistik'] as String,
      kemudahanAksesLogistik: json['kemudahan_akses_logistik'] as String,
      terdapatBumd: json['terdapat_bumd'] as String,
      bumdBerbadanHukum: json['bumd_berbadan_hukum'] as String,
      hariOperasionalLembagaEkonomi: json['hari_operasional_lembaga_ekonomi'] as String,
      ketersediaanLembagaEkonomiLainnya: json['ketersediaan_lembaga_ekonomi_lainnya'] as String,
      ketersediaanKud: json['ketersediaan_kud'] as String,
      ketersediaanUmkm: json['ketersediaan_umkm'] as String,
      layananPerbankan: json['layanan_perbankan'] as String,
      hariOperasionalKeuangan: json['hari_operasional_keuangan'] as String,
      layananFasilitasKreditKur: json['layanan_fasilitas_kredit_kur'] as String,
      layananFasilitasKreditKkpE: json['layanan_fasilitas_kredit_kkp_e'] as String,
      layananFasilitasKreditKuk: json['layanan_fasilitas_kredit_kuk'] as String,
      statusLayananFasilitasKredit: json['status_layanan_fasilitas_kredit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'ketersediaan_pendidikan_non_formal': ketersediaanPendidikanNonFormal,
      'keterlibatan_pendidikan_non_formal': keterlibatanPendidikanNonFormal,
      'ketersediaan_pasar_rakyat': ketersediaanPasarRakyat,
      'kemudahan_akses_pasar_rakyat': kemudahanAksesPasarRakyat,
      'ketersediaan_toko': ketersediaanToko,
      'kemudahan_akses_toko': kemudahanAksesToko,
      'ketersediaan_rumah_makan': ketersediaanRumahMakan,
      'kemudahan_akses_rumah_makan': kemudahanAksesRumahMakan,
      'ketersediaan_penginapan': ketersediaanPenginapan,
      'kemudahan_akses_penginapan': kemudahanAksesPenginapan,
      'ketersediaan_logistik': ketersediaanLogistik,
      'kemudahan_akses_logistik': kemudahanAksesLogistik,
      'terdapat_bumd': terdapatBumd,
      'bumd_berbadan_hukum': bumdBerbadanHukum,
      'hari_operasional_lembaga_ekonomi': hariOperasionalLembagaEkonomi,
      'ketersediaan_lembaga_ekonomi_lainnya': ketersediaanLembagaEkonomiLainnya,
      'ketersediaan_kud': ketersediaanKud,
      'ketersediaan_umkm': ketersediaanUmkm,
      'layanan_perbankan': layananPerbankan,
      'hari_operasional_keuangan': hariOperasionalKeuangan,
      'layanan_fasilitas_kredit_kur': layananFasilitasKreditKur,
      'layanan_fasilitas_kredit_kkp_e': layananFasilitasKreditKkpE,
      'layanan_fasilitas_kredit_kuk': layananFasilitasKreditKuk,
      'status_layanan_fasilitas_kredit': statusLayananFasilitasKredit,
    };
  }
}
