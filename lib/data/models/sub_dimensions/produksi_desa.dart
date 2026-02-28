class ProduksiDesa {
  final String? id;
  final String villageId;
  final int year;
  final String keragamanAktivitasEkonomi;
  final String keaktifanAktivitasEkonomi;
  final String ketersediaanProdukUnggulanDesa;
  final String cakupanPasarProdukUnggulan;
  final String ketersediaanMerekDagang;
  final String terdapatKearibanLokalEkonomi;
  final String telahDilakukanKerjaSamaDenganDesaLainnya;
  final String telahDilakukanKerjaSamaDenganPihakKetiga;

  ProduksiDesa({
    this.id,
    required this.villageId,
    required this.year,
    required this.keragamanAktivitasEkonomi,
    required this.keaktifanAktivitasEkonomi,
    required this.ketersediaanProdukUnggulanDesa,
    required this.cakupanPasarProdukUnggulan,
    required this.ketersediaanMerekDagang,
    required this.terdapatKearibanLokalEkonomi,
    required this.telahDilakukanKerjaSamaDenganDesaLainnya,
    required this.telahDilakukanKerjaSamaDenganPihakKetiga,
  });

  factory ProduksiDesa.fromJson(Map<String, dynamic> json) {
    return ProduksiDesa(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      keragamanAktivitasEkonomi: json['keragaman_aktivitas_ekonomi'] as String,
      keaktifanAktivitasEkonomi: json['keaktifan_aktivitas_ekonomi'] as String,
      ketersediaanProdukUnggulanDesa: json['ketersediaan_produk_unggulan_desa'] as String,
      cakupanPasarProdukUnggulan: json['cakupan_pasar_produk_unggulan'] as String,
      ketersediaanMerekDagang: json['ketersediaan_merek_dagang'] as String,
      terdapatKearibanLokalEkonomi: json['terdapat_kearifan_lokal_ekonomi'] as String,
      telahDilakukanKerjaSamaDenganDesaLainnya: json['telah_dilakukan_kerja_sama_dengan_desa_lainnya'] as String,
      telahDilakukanKerjaSamaDenganPihakKetiga: json['telah_dilakukan_kerja_sama_dengan_pihak_ketiga'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'keragaman_aktivitas_ekonomi': keragamanAktivitasEkonomi,
      'keaktifan_aktivitas_ekonomi': keaktifanAktivitasEkonomi,
      'ketersediaan_produk_unggulan_desa': ketersediaanProdukUnggulanDesa,
      'cakupan_pasar_produk_unggulan': cakupanPasarProdukUnggulan,
      'ketersediaan_merek_dagang': ketersediaanMerekDagang,
      'terdapat_kearifan_lokal_ekonomi': terdapatKearibanLokalEkonomi,
      'telah_dilakukan_kerja_sama_dengan_desa_lainnya': telahDilakukanKerjaSamaDenganDesaLainnya,
      'telah_dilakukan_kerja_sama_dengan_pihak_ketiga': telahDilakukanKerjaSamaDenganPihakKetiga,
    };
  }
}
