class FasilitasMasyarakat {
  final String? id;
  final String villageId;
  final int year;
  final String terdapatTamanBacaanMasyarakat;
  final String hariOperasionalTamanBacaanMasyarakat;
  final String ketersediaanFasilitasOlahraga;
  final String keberadaanRuangPublikTerbuka;

  FasilitasMasyarakat({
    this.id,
    required this.villageId,
    required this.year,
    required this.terdapatTamanBacaanMasyarakat,
    required this.hariOperasionalTamanBacaanMasyarakat,
    required this.ketersediaanFasilitasOlahraga,
    required this.keberadaanRuangPublikTerbuka,
  });

  factory FasilitasMasyarakat.fromJson(Map<String, dynamic> json) {
    return FasilitasMasyarakat(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      terdapatTamanBacaanMasyarakat: json['terdapat_taman_bacaan_masyarakat'] as String,
      hariOperasionalTamanBacaanMasyarakat: json['hari_operasional_taman_bacaan_masyarakat'] as String,
      ketersediaanFasilitasOlahraga: json['ketersediaan_fasilitas_olahraga'] as String,
      keberadaanRuangPublikTerbuka: json['keberadaan_ruang_publik_terbuka'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'terdapat_taman_bacaan_masyarakat': terdapatTamanBacaanMasyarakat,
      'hari_operasional_taman_bacaan_masyarakat': hariOperasionalTamanBacaanMasyarakat,
      'ketersediaan_fasilitas_olahraga': ketersediaanFasilitasOlahraga,
      'keberadaan_ruang_publik_terbuka': keberadaanRuangPublikTerbuka,
    };
  }
}
