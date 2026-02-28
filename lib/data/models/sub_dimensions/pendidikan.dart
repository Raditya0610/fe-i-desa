class Pendidikan {
  final String? id;
  final String villageId;
  final int year;
  final String ketersediaanPaud;
  final String kemudahanAksesPaud;
  final String apmPaud;
  final String kemudahanAksesSd;
  final String apmSd;
  final String kemudahanAksesSmp;
  final String apmSmp;
  final String kemudahanAksesSma;
  final String apmSma;

  Pendidikan({
    this.id,
    required this.villageId,
    required this.year,
    required this.ketersediaanPaud,
    required this.kemudahanAksesPaud,
    required this.apmPaud,
    required this.kemudahanAksesSd,
    required this.apmSd,
    required this.kemudahanAksesSmp,
    required this.apmSmp,
    required this.kemudahanAksesSma,
    required this.apmSma,
  });

  factory Pendidikan.fromJson(Map<String, dynamic> json) {
    return Pendidikan(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      ketersediaanPaud: json['ketersediaan_paud'] as String,
      kemudahanAksesPaud: json['kemudahan_akses_paud'] as String,
      apmPaud: json['apm_paud'] as String,
      kemudahanAksesSd: json['kemudahan_akses_sd'] as String,
      apmSd: json['apm_sd'] as String,
      kemudahanAksesSmp: json['kemudahan_akses_smp'] as String,
      apmSmp: json['apm_smp'] as String,
      kemudahanAksesSma: json['kemudahan_akses_sma'] as String,
      apmSma: json['apm_sma'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'ketersediaan_paud': ketersediaanPaud,
      'kemudahan_akses_paud': kemudahanAksesPaud,
      'apm_paud': apmPaud,
      'kemudahan_akses_sd': kemudahanAksesSd,
      'apm_sd': apmSd,
      'kemudahan_akses_smp': kemudahanAksesSmp,
      'apm_smp': apmSmp,
      'kemudahan_akses_sma': kemudahanAksesSma,
      'apm_sma': apmSma,
    };
  }
}
