class PenanggulanganBencana {
  final String? id;
  final String villageId;
  final int year;
  final String aspekInformasiKebencanaan;
  final String fasilitasMitigasiBencana;
  final String aksesMenujuFasilitasMitigasiBencana;
  final String aktivitasMitigasi;
  final String fasilitasTanggapDaruratBencana;

  PenanggulanganBencana({
    this.id,
    required this.villageId,
    required this.year,
    required this.aspekInformasiKebencanaan,
    required this.fasilitasMitigasiBencana,
    required this.aksesMenujuFasilitasMitigasiBencana,
    required this.aktivitasMitigasi,
    required this.fasilitasTanggapDaruratBencana,
  });

  factory PenanggulanganBencana.fromJson(Map<String, dynamic> json) {
    return PenanggulanganBencana(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      aspekInformasiKebencanaan: json['aspek_informasi_kebencanaan'] as String,
      fasilitasMitigasiBencana: json['fasilitas_mitigasi_bencana'] as String,
      aksesMenujuFasilitasMitigasiBencana: json['akses_menuju_fasilitas_mitigasi_bencana'] as String,
      aktivitasMitigasi: json['aktivitas_mitigasi'] as String,
      fasilitasTanggapDaruratBencana: json['fasilitas_tanggap_darurat_bencana'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'aspek_informasi_kebencanaan': aspekInformasiKebencanaan,
      'fasilitas_mitigasi_bencana': fasilitasMitigasiBencana,
      'akses_menuju_fasilitas_mitigasi_bencana': aksesMenujuFasilitasMitigasiBencana,
      'aktivitas_mitigasi': aktivitasMitigasi,
      'fasilitas_tanggap_darurat_bencana': fasilitasTanggapDaruratBencana,
    };
  }
}
