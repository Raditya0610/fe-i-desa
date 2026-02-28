import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/form_options.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../data/models/sub_dimensions/fasilitas_pendukung_ekonomi.dart';
import '../../../providers/fasilitas_pendukung_ekonomi_provider.dart';
import '../../widgets/common/sub_dimension_dropdown.dart';

class FasilitasPendukungEkonomiFormScreen extends ConsumerStatefulWidget {
  const FasilitasPendukungEkonomiFormScreen({super.key});

  @override
  ConsumerState<FasilitasPendukungEkonomiFormScreen> createState() => _FasilitasPendukungEkonomiFormScreenState();
}

class _FasilitasPendukungEkonomiFormScreenState extends ConsumerState<FasilitasPendukungEkonomiFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _year = DateTime.now().year;

  // Dropdown state variables
  String? _ketersediaanPendidikanNonFormal;
  String? _keterlibatanPendidikanNonFormal;
  String? _ketersediaanPasarRakyat;
  String? _kemudahanAksesPasarRakyat;
  String? _ketersediaanToko;
  String? _kemudahanAksesToko;
  String? _ketersediaanRumahMakan;
  String? _kemudahanAksesRumahMakan;
  String? _ketersediaanPenginapan;
  String? _kemudahanAksesPenginapan;
  String? _ketersediaanLogistik;
  String? _kemudahanAksesLogistik;
  String? _terdapatBumd;
  String? _bumdBerbadanHukum;
  String? _hariOperasionalLembagaEkonomi;
  String? _ketersediaanLembagaEkonomiLainnya;
  String? _ketersediaanKud;
  String? _ketersediaanUmkm;
  String? _layananPerbankan;
  String? _hariOperasionalKeuangan;
  String? _layananFasilitasKreditKur;
  String? _layananFasilitasKreditKkpE;
  String? _layananFasilitasKreditKuk;
  String? _statusLayananFasilitasKredit;

  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: ForuiThemeConfig.animationMedium,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final data = FasilitasPendukungEkonomi(
      villageId: '',
      year: _year,
      ketersediaanPendidikanNonFormal: _ketersediaanPendidikanNonFormal ?? '',
      keterlibatanPendidikanNonFormal: _keterlibatanPendidikanNonFormal ?? '',
      ketersediaanPasarRakyat: _ketersediaanPasarRakyat ?? '',
      kemudahanAksesPasarRakyat: _kemudahanAksesPasarRakyat ?? '',
      ketersediaanToko: _ketersediaanToko ?? '',
      kemudahanAksesToko: _kemudahanAksesToko ?? '',
      ketersediaanRumahMakan: _ketersediaanRumahMakan ?? '',
      kemudahanAksesRumahMakan: _kemudahanAksesRumahMakan ?? '',
      ketersediaanPenginapan: _ketersediaanPenginapan ?? '',
      kemudahanAksesPenginapan: _kemudahanAksesPenginapan ?? '',
      ketersediaanLogistik: _ketersediaanLogistik ?? '',
      kemudahanAksesLogistik: _kemudahanAksesLogistik ?? '',
      terdapatBumd: _terdapatBumd ?? '',
      bumdBerbadanHukum: _bumdBerbadanHukum ?? '',
      hariOperasionalLembagaEkonomi: _hariOperasionalLembagaEkonomi ?? '',
      ketersediaanLembagaEkonomiLainnya: _ketersediaanLembagaEkonomiLainnya ?? '',
      ketersediaanKud: _ketersediaanKud ?? '',
      ketersediaanUmkm: _ketersediaanUmkm ?? '',
      layananPerbankan: _layananPerbankan ?? '',
      hariOperasionalKeuangan: _hariOperasionalKeuangan ?? '',
      layananFasilitasKreditKur: _layananFasilitasKreditKur ?? '',
      layananFasilitasKreditKkpE: _layananFasilitasKreditKkpE ?? '',
      layananFasilitasKreditKuk: _layananFasilitasKreditKuk ?? '',
      statusLayananFasilitasKredit: _statusLayananFasilitasKredit ?? '',
    );

    final result = await ref.read(fasilitasPendukungEkonomiProvider).createFasilitasPendukungEkonomi(data);

    setState(() => _isLoading = false);

    if (mounted) {
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: ForuiThemeConfig.successColor,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: ForuiThemeConfig.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indikator Fasilitas Pendukung Ekonomi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
          child: Card(
            elevation: ForuiThemeConfig.elevationMedium,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusLarge),
            ),
            child: Padding(
              padding: const EdgeInsets.all(ForuiThemeConfig.spacingXLarge),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(ForuiThemeConfig.spacingMedium),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
                          ),
                          child: const Icon(Icons.storefront, size: 32, color: Colors.amber),
                        ),
                        const SizedBox(width: ForuiThemeConfig.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Fasilitas Pendukung Ekonomi',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Isi data indikator fasilitas pendukung ekonomi desa',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: ForuiThemeConfig.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Year Selector
                    DropdownButtonFormField<int>(
                      initialValue: _year,
                      decoration: const InputDecoration(
                        labelText: 'Tahun *',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      items: List.generate(
                        101,
                        (index) => DropdownMenuItem(
                          value: 2000 + index,
                          child: Text('${2000 + index}'),
                        ),
                      ),
                      onChanged: (value) => setState(() => _year = value!),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Pendidikan Non Formal Section
                    _buildSectionHeader('Pendidikan Non Formal'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Pendidikan Non Formal',
                      value: _ketersediaanPendidikanNonFormal,
                      options: FormOptions.ketersediaan,
                      prefixIcon: Icons.school,
                      onChanged: (value) => setState(() => _ketersediaanPendidikanNonFormal = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Keterlibatan Pendidikan Non Formal',
                      value: _keterlibatanPendidikanNonFormal,
                      options: FormOptions.tingkat,
                      prefixIcon: Icons.people,
                      onChanged: (value) => setState(() => _keterlibatanPendidikanNonFormal = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Pasar Rakyat Section
                    _buildSectionHeader('Pasar Rakyat'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Pasar Rakyat',
                      value: _ketersediaanPasarRakyat,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.shopping_cart,
                      onChanged: (value) => setState(() => _ketersediaanPasarRakyat = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses Pasar Rakyat',
                      value: _kemudahanAksesPasarRakyat,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.accessibility,
                      onChanged: (value) => setState(() => _kemudahanAksesPasarRakyat = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Toko Section
                    _buildSectionHeader('Toko'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Toko',
                      value: _ketersediaanToko,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.storefront,
                      onChanged: (value) => setState(() => _ketersediaanToko = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses Toko',
                      value: _kemudahanAksesToko,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.accessibility,
                      onChanged: (value) => setState(() => _kemudahanAksesToko = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Rumah Makan Section
                    _buildSectionHeader('Rumah Makan'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Rumah Makan',
                      value: _ketersediaanRumahMakan,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.restaurant,
                      onChanged: (value) => setState(() => _ketersediaanRumahMakan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses Rumah Makan',
                      value: _kemudahanAksesRumahMakan,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.accessibility,
                      onChanged: (value) => setState(() => _kemudahanAksesRumahMakan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Penginapan Section
                    _buildSectionHeader('Penginapan'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Penginapan',
                      value: _ketersediaanPenginapan,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.hotel,
                      onChanged: (value) => setState(() => _ketersediaanPenginapan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses Penginapan',
                      value: _kemudahanAksesPenginapan,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.accessibility,
                      onChanged: (value) => setState(() => _kemudahanAksesPenginapan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Logistik Section
                    _buildSectionHeader('Logistik'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Logistik',
                      value: _ketersediaanLogistik,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.local_shipping,
                      onChanged: (value) => setState(() => _ketersediaanLogistik = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses Logistik',
                      value: _kemudahanAksesLogistik,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.accessibility,
                      onChanged: (value) => setState(() => _kemudahanAksesLogistik = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // BUMD Section
                    _buildSectionHeader('BUMD'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Terdapat BUMD',
                      value: _terdapatBumd,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.business,
                      onChanged: (value) => setState(() => _terdapatBumd = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'BUMD Berbadan Hukum',
                      value: _bumdBerbadanHukum,
                      options: FormOptions.yaTidak,
                      prefixIcon: Icons.verified,
                      onChanged: (value) => setState(() => _bumdBerbadanHukum = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Lembaga Ekonomi Section
                    _buildSectionHeader('Lembaga Ekonomi'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Hari Operasional Lembaga Ekonomi',
                      value: _hariOperasionalLembagaEkonomi,
                      options: FormOptions.hariOperasional,
                      prefixIcon: Icons.calendar_month,
                      onChanged: (value) => setState(() => _hariOperasionalLembagaEkonomi = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Lembaga Ekonomi Lainnya',
                      value: _ketersediaanLembagaEkonomiLainnya,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.business,
                      onChanged: (value) => setState(() => _ketersediaanLembagaEkonomiLainnya = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan KUD',
                      value: _ketersediaanKud,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.agriculture,
                      onChanged: (value) => setState(() => _ketersediaanKud = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan UMKM',
                      value: _ketersediaanUmkm,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.work,
                      onChanged: (value) => setState(() => _ketersediaanUmkm = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Layanan Keuangan Section
                    _buildSectionHeader('Layanan Keuangan'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Layanan Perbankan',
                      value: _layananPerbankan,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.account_balance,
                      onChanged: (value) => setState(() => _layananPerbankan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Hari Operasional Keuangan',
                      value: _hariOperasionalKeuangan,
                      options: FormOptions.hariOperasional,
                      prefixIcon: Icons.calendar_month,
                      onChanged: (value) => setState(() => _hariOperasionalKeuangan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Layanan Fasilitas Kredit KUR',
                      value: _layananFasilitasKreditKur,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.money,
                      onChanged: (value) => setState(() => _layananFasilitasKreditKur = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Layanan Fasilitas Kredit KKP-E',
                      value: _layananFasilitasKreditKkpE,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.money,
                      onChanged: (value) => setState(() => _layananFasilitasKreditKkpE = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Layanan Fasilitas Kredit KUK',
                      value: _layananFasilitasKreditKuk,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.money,
                      onChanged: (value) => setState(() => _layananFasilitasKreditKuk = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Status Layanan Fasilitas Kredit',
                      value: _statusLayananFasilitasKredit,
                      options: FormOptions.status,
                      prefixIcon: Icons.verified,
                      onChanged: (value) => setState(() => _statusLayananFasilitasKredit = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : () => context.pop(),
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text('Batal'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: ForuiThemeConfig.spacingMedium + 4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: ForuiThemeConfig.spacingMedium),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _handleSubmit,
                            icon: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(_isLoading ? 'Menyimpan...' : 'Simpan Data'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: ForuiThemeConfig.spacingMedium + 4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ForuiThemeConfig.spacingMedium,
        vertical: ForuiThemeConfig.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.amber.shade700,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
