class Aktivitas {
  final String? id;
  final String villageId;
  final int year;
  final String kearibanBudayaSosial;
  final String kearibanBudayaSosialDipertahankan;
  final String kegiatanGotongRoyong;
  final String frekuensiGotongRoyong;
  final String keterlibatanWargaGotongRoyong;
  final String frekuensiKegiatanOlahraga;
  final String penyelesaianKonflikSecaraDamai;
  final String peranAparatKeamananMediator;
  final String peranAparatPemerintah;
  final String peranTokohMasyarakat;
  final String peranTokohAgama;
  final String satuanKeamananLingkungan;
  final String aktivitasSatuanKeamananLingkungan;

  Aktivitas({
    this.id,
    required this.villageId,
    required this.year,
    required this.kearibanBudayaSosial,
    required this.kearibanBudayaSosialDipertahankan,
    required this.kegiatanGotongRoyong,
    required this.frekuensiGotongRoyong,
    required this.keterlibatanWargaGotongRoyong,
    required this.frekuensiKegiatanOlahraga,
    required this.penyelesaianKonflikSecaraDamai,
    required this.peranAparatKeamananMediator,
    required this.peranAparatPemerintah,
    required this.peranTokohMasyarakat,
    required this.peranTokohAgama,
    required this.satuanKeamananLingkungan,
    required this.aktivitasSatuanKeamananLingkungan,
  });

  factory Aktivitas.fromJson(Map<String, dynamic> json) {
    return Aktivitas(
      id: json['id'] as String?,
      villageId: json['village_id'] as String,
      year: json['year'] as int,
      kearibanBudayaSosial: json['kearifan_budaya_sosial'] as String,
      kearibanBudayaSosialDipertahankan: json['kearifan_budaya_sosial_dipertahankan'] as String,
      kegiatanGotongRoyong: json['kegiatan_gotong_royong'] as String,
      frekuensiGotongRoyong: json['frekuensi_gotong_royong'] as String,
      keterlibatanWargaGotongRoyong: json['keterlibatan_warga_gotong_royong'] as String,
      frekuensiKegiatanOlahraga: json['frekuensi_kegiatan_olahraga'] as String,
      penyelesaianKonflikSecaraDamai: json['penyelesaian_konflik_secara_damai'] as String,
      peranAparatKeamananMediator: json['peran_aparat_keamanan_mediator'] as String,
      peranAparatPemerintah: json['peran_aparat_pemerintah'] as String,
      peranTokohMasyarakat: json['peran_tokoh_masyarakat'] as String,
      peranTokohAgama: json['peran_tokoh_agama'] as String,
      satuanKeamananLingkungan: json['satuan_keamanan_lingkungan'] as String,
      aktivitasSatuanKeamananLingkungan: json['aktivitas_satuan_keamanan_lingkungan'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'village_id': villageId,
      'year': year,
      'kearifan_budaya_sosial': kearibanBudayaSosial,
      'kearifan_budaya_sosial_dipertahankan': kearibanBudayaSosialDipertahankan,
      'kegiatan_gotong_royong': kegiatanGotongRoyong,
      'frekuensi_gotong_royong': frekuensiGotongRoyong,
      'keterlibatan_warga_gotong_royong': keterlibatanWargaGotongRoyong,
      'frekuensi_kegiatan_olahraga': frekuensiKegiatanOlahraga,
      'penyelesaian_konflik_secara_damai': penyelesaianKonflikSecaraDamai,
      'peran_aparat_keamanan_mediator': peranAparatKeamananMediator,
      'peran_aparat_pemerintah': peranAparatPemerintah,
      'peran_tokoh_masyarakat': peranTokohMasyarakat,
      'peran_tokoh_agama': peranTokohAgama,
      'satuan_keamanan_lingkungan': satuanKeamananLingkungan,
      'aktivitas_satuan_keamanan_lingkungan': aktivitasSatuanKeamananLingkungan,
    };
  }
}
