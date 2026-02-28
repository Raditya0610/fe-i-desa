class Villager {
  final String nik;
  final String namaLengkap;
  final String jenisKelamin; // L or P
  final String tempatLahir;
  final DateTime tanggalLahir;
  final String agama;
  final String pendidikan;
  final String pekerjaan;
  final String statusPerkawinan;
  final String statusHubungan;
  final String kewarganegaraan;
  final String? nomorPaspor;
  final String? nomorKitas;
  final String namaAyah;
  final String namaIbu;
  final String? villageId;
  final String? familyCardId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Villager({
    required this.nik,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.agama,
    required this.pendidikan,
    required this.pekerjaan,
    required this.statusPerkawinan,
    required this.statusHubungan,
    required this.kewarganegaraan,
    this.nomorPaspor,
    this.nomorKitas,
    required this.namaAyah,
    required this.namaIbu,
    this.villageId,
    this.familyCardId,
    this.createdAt,
    this.updatedAt,
  });

  factory Villager.fromJson(Map<String, dynamic> json) {
    return Villager(
      nik: json['nik'] as String,
      namaLengkap: json['nama_lengkap'] as String,
      jenisKelamin: json['jenis_kelamin'] as String,
      tempatLahir: json['tempat_lahir'] as String,
      tanggalLahir: DateTime.parse(json['tanggal_lahir'] as String),
      agama: json['agama'] as String,
      pendidikan: json['pendidikan'] as String,
      pekerjaan: json['pekerjaan'] as String,
      statusPerkawinan: json['status_perkawinan'] as String,
      statusHubungan: json['status_hubungan'] as String,
      kewarganegaraan: json['kewarganegaraan'] as String,
      nomorPaspor: json['nomor_paspor'] as String?,
      nomorKitas: json['nomor_kitas'] as String?,
      namaAyah: json['nama_ayah'] as String,
      namaIbu: json['nama_ibu'] as String,
      villageId: json['village_id'] as String?,
      familyCardId: json['family_card_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir.toIso8601String().split('T')[0],
      'agama': agama,
      'pendidikan': pendidikan,
      'pekerjaan': pekerjaan,
      'status_perkawinan': statusPerkawinan,
      'status_hubungan': statusHubungan,
      'kewarganegaraan': kewarganegaraan,
      'nomor_paspor': nomorPaspor,
      'nomor_kitas': nomorKitas,
      'nama_ayah': namaAyah,
      'nama_ibu': namaIbu,
      if (villageId != null) 'village_id': villageId,
      if (familyCardId != null) 'family_card_id': familyCardId,
    };
  }

  /// Converts Villager to a Map format compatible with VillagerFormDialog
  Map<String, dynamic> toEditMap() {
    return {
      'nik': nik,
      'name': namaLengkap,
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': tanggalLahir.toIso8601String().split('T')[0],
      'agama': agama,
      'pendidikan': pendidikan,
      'pekerjaan': pekerjaan,
      'status_perkawinan': statusPerkawinan,
      'status_hubungan': statusHubungan,
      'kewarganegaraan': kewarganegaraan,
      'nomor_paspor': nomorPaspor ?? '',
      'nomor_kitas': nomorKitas ?? '',
      'nama_ayah': namaAyah,
      'nama_ibu': namaIbu,
    };
  }

  // Helper method to calculate age
  int get age {
    final now = DateTime.now();
    int age = now.year - tanggalLahir.year;
    if (now.month < tanggalLahir.month ||
        (now.month == tanggalLahir.month && now.day < tanggalLahir.day)) {
      age--;
    }
    return age;
  }

  // Helper method for gender display
  String get jenisKelaminDisplay =>
      jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan';
}
