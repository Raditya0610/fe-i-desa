class TataKelolaKeuanganDesa {
  final String? id;
  final String villageId;
  final int year;
  final String pendapatanAsliDesa;
  final String peningkatanPades;
  final String penyertaanModalDdBumd;
  final String asetTanahDesa;
  final String asetKantorDesa;
  final String asetPasarDesa;
  final String asetLainnya;
  final String produktivitasAsetDesa;
  final String inventarisasiAsetDesa;

  TataKelolaKeuanganDesa({
    this.id,
    required this.villageId,
    required this.year,
    required this.pendapatanAsliDesa,
    required this.peningkatanPades,
    required this.penyertaanModalDdBumd,
    required this.asetTanahDesa,
    required this.asetKantorDesa,
    required this.asetPasarDesa,
    required this.asetLainnya,
    required this.produktivitasAsetDesa,
    required this.inventarisasiAsetDesa,
  });

  factory TataKelolaKeuanganDesa.fromJson(Map<String, dynamic> json) {
    return TataKelolaKeuanganDesa(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      pendapatanAsliDesa: json['pendapatan_asli_desa'] as String,
      peningkatanPades: json['peningkatan_pades'] as String,
      penyertaanModalDdBumd: json['penyertaan_modal_dd_bumd'] as String,
      asetTanahDesa: json['aset_tanah_desa'] as String,
      asetKantorDesa: json['aset_kantor_desa'] as String,
      asetPasarDesa: json['aset_pasar_desa'] as String,
      asetLainnya: json['aset_lainnya'] as String,
      produktivitasAsetDesa: json['produktivitas_aset_desa'] as String,
      inventarisasiAsetDesa: json['inventarisasi_aset_desa'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'pendapatan_asli_desa': pendapatanAsliDesa,
      'peningkatan_pades': peningkatanPades,
      'penyertaan_modal_dd_bumd': penyertaanModalDdBumd,
      'aset_tanah_desa': asetTanahDesa,
      'aset_kantor_desa': asetKantorDesa,
      'aset_pasar_desa': asetPasarDesa,
      'aset_lainnya': asetLainnya,
      'produktivitas_aset_desa': produktivitasAsetDesa,
      'inventarisasi_aset_desa': inventarisasiAsetDesa,
    };
  }
}
