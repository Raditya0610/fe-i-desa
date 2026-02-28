class Dashboard {
  final int totalKeluarga;
  final int totalPenduduk;
  final double rerataKeluarga;
  final int lakiLaki;
  final int perempuan;
  final int kepalaKeluarga;
  final double rerataUmur;
  final int rt;
  final int rw;
  final int kelurahan;
  final int kecamatan;

  Dashboard({
    required this.totalKeluarga,
    required this.totalPenduduk,
    required this.rerataKeluarga,
    required this.lakiLaki,
    required this.perempuan,
    required this.kepalaKeluarga,
    required this.rerataUmur,
    required this.rt,
    required this.rw,
    required this.kelurahan,
    required this.kecamatan,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      totalKeluarga: json['totalKeluarga'] as int? ?? 0,
      totalPenduduk: json['totalPenduduk'] as int? ?? 0,
      rerataKeluarga: (json['rerataKeluarga'] as num?)?.toDouble() ?? 0.0,
      lakiLaki: json['lakiLaki'] as int? ?? 0,
      perempuan: json['perempuan'] as int? ?? 0,
      kepalaKeluarga: json['kepalaKeluarga'] as int? ?? 0,
      rerataUmur: (json['rerataUmur'] as num?)?.toDouble() ?? 0.0,
      rt: json['rt'] as int? ?? 0,
      rw: json['rw'] as int? ?? 0,
      kelurahan: json['kelurahan'] as int? ?? 0,
      kecamatan: json['kecamatan'] as int? ?? 0,
    );
  }

  // Gender ratio calculation
  double get genderRatioMale {
    if (totalPenduduk == 0) return 0;
    return (lakiLaki / totalPenduduk) * 100;
  }

  double get genderRatioFemale {
    if (totalPenduduk == 0) return 0;
    return (perempuan / totalPenduduk) * 100;
  }

  // Rasio Keluarga calculation (population density index)
  double get rasioKeluarga {
    if (totalKeluarga == 0) return 0;
    return totalPenduduk / totalKeluarga;
  }
}
