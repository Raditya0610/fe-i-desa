class FamilyCardDetail {
  final String nik;
  final String address;
  final List<Map<String, dynamic>> familyMembers;

  FamilyCardDetail({
    required this.nik,
    required this.address,
    required this.familyMembers,
  });

  int get totalMembers => familyMembers.length;

  String get name {
    // Get the name of the head of family (Kepala Keluarga)
    final head = familyMembers.firstWhere(
      (member) =>
          member['status_hubungan'] == 'Kepala Keluarga',
      orElse: () => {},
    );
    return head['name'] as String? ?? 'Tidak ada kepala keluarga';
  }

  factory FamilyCardDetail.fromJson(Map<String, dynamic> json) {
    return FamilyCardDetail(
      nik: json['nik'] as String,
      address: json['address'] as String? ?? '',
      familyMembers: (json['family_members'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }
}
