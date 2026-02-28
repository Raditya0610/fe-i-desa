class UtilitasDasar {
  final String? id;
  final String villageId;
  final int year;
  final String operasionalAirMinum;
  final String ketersediaanAirMinum;
  final String kemudahanAksesAirMinum;
  final String kualitasAirMinum;
  final String persentaseRumahTidakLayakHuni;

  UtilitasDasar({
    this.id,
    required this.villageId,
    required this.year,
    required this.operasionalAirMinum,
    required this.ketersediaanAirMinum,
    required this.kemudahanAksesAirMinum,
    required this.kualitasAirMinum,
    required this.persentaseRumahTidakLayakHuni,
  });

  factory UtilitasDasar.fromJson(Map<String, dynamic> json) {
    return UtilitasDasar(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      operasionalAirMinum: json['operasional_air_minum'] as String,
      ketersediaanAirMinum: json['ketersediaan_air_minum'] as String,
      kemudahanAksesAirMinum: json['kemudahan_akses_air_minum'] as String,
      kualitasAirMinum: json['kualitas_air_minum'] as String,
      persentaseRumahTidakLayakHuni: json['persentase_rumah_tidak_layak_huni'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'operasional_air_minum': operasionalAirMinum,
      'ketersediaan_air_minum': ketersediaanAirMinum,
      'kemudahan_akses_air_minum': kemudahanAksesAirMinum,
      'kualitas_air_minum': kualitasAirMinum,
      'persentase_rumah_tidak_layak_huni': persentaseRumahTidakLayakHuni,
    };
  }
}
