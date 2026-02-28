class KelembagaanPelayananDesa {
  final String? id;
  final String villageId;
  final int year;
  final String layananDiberikan;
  final String publikasiInformasiPelayanan;
  final String pelayananAdministrasi;
  final String pelayananPengaduan;
  final String pelayananLainnya;
  final String musyawarahDesa;
  final String musyawarahDesaDidatangiUnsurMasyarakat;

  KelembagaanPelayananDesa({
    this.id,
    required this.villageId,
    required this.year,
    required this.layananDiberikan,
    required this.publikasiInformasiPelayanan,
    required this.pelayananAdministrasi,
    required this.pelayananPengaduan,
    required this.pelayananLainnya,
    required this.musyawarahDesa,
    required this.musyawarahDesaDidatangiUnsurMasyarakat,
  });

  factory KelembagaanPelayananDesa.fromJson(Map<String, dynamic> json) {
    return KelembagaanPelayananDesa(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      layananDiberikan: json['layanan_diberikan'] as String,
      publikasiInformasiPelayanan: json['publikasi_informasi_pelayanan'] as String,
      pelayananAdministrasi: json['pelayanan_administrasi'] as String,
      pelayananPengaduan: json['pelayanan_pengaduan'] as String,
      pelayananLainnya: json['pelayanan_lainnya'] as String,
      musyawarahDesa: json['musyawarah_desa'] as String,
      musyawarahDesaDidatangiUnsurMasyarakat: json['musyawarah_desa_didatangi_unsur_masyarakat'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'layanan_diberikan': layananDiberikan,
      'publikasi_informasi_pelayanan': publikasiInformasiPelayanan,
      'pelayanan_administrasi': pelayananAdministrasi,
      'pelayanan_pengaduan': pelayananPengaduan,
      'pelayanan_lainnya': pelayananLainnya,
      'musyawarah_desa': musyawarahDesa,
      'musyawarah_desa_didatangi_unsur_masyarakat': musyawarahDesaDidatangiUnsurMasyarakat,
    };
  }
}
