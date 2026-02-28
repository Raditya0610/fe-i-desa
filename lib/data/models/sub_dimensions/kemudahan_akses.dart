class KemudahanAkses {
  final String? id;
  final String villageId;
  final int year;
  final String angkutanPerdesaan;
  final String operasionalAngkutanPerdesaan;
  final String pelayananListrik;
  final String durasiLayananListrik;
  final String aksesTelepon;
  final String aksesInternet;

  KemudahanAkses({
    this.id,
    required this.villageId,
    required this.year,
    required this.angkutanPerdesaan,
    required this.operasionalAngkutanPerdesaan,
    required this.pelayananListrik,
    required this.durasiLayananListrik,
    required this.aksesTelepon,
    required this.aksesInternet,
  });

  factory KemudahanAkses.fromJson(Map<String, dynamic> json) {
    return KemudahanAkses(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      angkutanPerdesaan: json['angkutan_perdesaan'] as String,
      operasionalAngkutanPerdesaan: json['operasional_angkutan_perdesaan'] as String,
      pelayananListrik: json['pelayanan_listrik'] as String,
      durasiLayananListrik: json['durasi_layanan_listrik'] as String,
      aksesTelepon: json['akses_telepon'] as String,
      aksesInternet: json['akses_internet'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'angkutan_perdesaan': angkutanPerdesaan,
      'operasional_angkutan_perdesaan': operasionalAngkutanPerdesaan,
      'pelayanan_listrik': pelayananListrik,
      'durasi_layanan_listrik': durasiLayananListrik,
      'akses_telepon': aksesTelepon,
      'akses_internet': aksesInternet,
    };
  }
}
