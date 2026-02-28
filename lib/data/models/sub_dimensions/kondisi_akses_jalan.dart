class KondisiAksesJalan {
  final String? id;
  final String villageId;
  final int year;
  final String jenisPermukaanJalan;
  final String kualitasJalan;
  final String peneranganJalanUtama;
  final String operasionalPju;

  KondisiAksesJalan({
    this.id,
    required this.villageId,
    required this.year,
    required this.jenisPermukaanJalan,
    required this.kualitasJalan,
    required this.peneranganJalanUtama,
    required this.operasionalPju,
  });

  factory KondisiAksesJalan.fromJson(Map<String, dynamic> json) {
    return KondisiAksesJalan(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      jenisPermukaanJalan: json['jenis_permukaan_jalan'] as String,
      kualitasJalan: json['kualitas_jalan'] as String,
      peneranganJalanUtama: json['penerangan_jalan_utama'] as String,
      operasionalPju: json['operasional_pju'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'jenis_permukaan_jalan': jenisPermukaanJalan,
      'kualitas_jalan': kualitasJalan,
      'penerangan_jalan_utama': peneranganJalanUtama,
      'operasional_pju': operasionalPju,
    };
  }
}
