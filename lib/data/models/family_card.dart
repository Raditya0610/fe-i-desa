class FamilyCard {
  final String nik;
  final String name;
  final int totalMembers;
  final String? address;
  final List<Map<String, dynamic>>? familyMembers;
  final String? rt;
  final String? rw;
  final String? kelurahan;
  final String? kecamatan;
  final String? kabupatenKota;
  final String? kodePos;
  final String? provinsi;

  FamilyCard({
    required this.nik,
    required this.name,
    required this.totalMembers,
    this.address,
    this.familyMembers,
    this.rt,
    this.rw,
    this.kelurahan,
    this.kecamatan,
    this.kabupatenKota,
    this.kodePos,
    this.provinsi,
  });

  factory FamilyCard.fromJson(Map<String, dynamic> json) {
    return FamilyCard(
      nik: json['nik'] as String,
      name: json['name'] as String? ?? '',
      totalMembers: json['total_members'] as int? ?? 0,
      address: json['address'] as String?,
      familyMembers: json['family_members'] != null
          ? (json['family_members'] as List<dynamic>)
              .map((e) => e as Map<String, dynamic>)
              .toList()
          : null,
      rt: json['rt'] as String?,
      rw: json['rw'] as String?,
      kelurahan: json['kelurahan'] as String?,
      kecamatan: json['kecamatan'] as String?,
      kabupatenKota: json['kabupaten_kota'] as String?,
      kodePos: json['kode_pos'] as String?,
      provinsi: json['provinsi'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'name': name,
      'total_members': totalMembers,
      if (address != null) 'address': address,
      if (familyMembers != null) 'family_members': familyMembers,
    };
  }

  /// Serializes only the fields required by the BE POST /api/family-cards.
  Map<String, dynamic> toCreateJson() {
    return {
      'nik': nik,
      'address': address ?? '',
      'rt': rt ?? '',
      'rw': rw ?? '',
      'kelurahan': kelurahan ?? '',
      'kecamatan': kecamatan ?? '',
      'kabupaten_kota': kabupatenKota ?? '',
      'kode_pos': kodePos ?? '',
      'provinsi': provinsi ?? '',
    };
  }
}
