import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/form_options.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/sub_dimensions/kesehatan.dart';
import '../../../providers/kesehatan_provider.dart';
import '../../widgets/common/sub_dimension_dropdown.dart';
import '../../widgets/common/percentage_input.dart';

class KesehatanFormScreen extends ConsumerStatefulWidget {
  const KesehatanFormScreen({super.key});

  @override
  ConsumerState<KesehatanFormScreen> createState() => _KesehatanFormScreenState();
}

class _KesehatanFormScreenState extends ConsumerState<KesehatanFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _year = DateTime.now().year;

  // Dropdown state variables
  String? _kemudahanAksesSaranaKesehatan;
  String? _ketersediaanFasilitasKesehatan;
  String? _kemudahanAksesFasilitasKesehatan;
  String? _ketersediaanPosyandu;
  String? _kemudahanAksesPosyandu;
  String? _ketersediaanLayananDokter;
  String? _hariOperasionalLayananDokter;
  String? _penyediaTransportasiLayananDokter;
  String? _ketersediaanLayananBidan;
  String? _hariOperasionalLayananBidan;
  String? _penyediaTransportasiLayananBidan;
  String? _ketersediaanLayananTenagaKesehatan;
  String? _hariOperasionalLayananTenagaKesehatan;
  String? _penyediaTransportasiLayananTenagaKesehatan;
  String? _kegiatanSosialisasiJaminanKesehatan;

  // Controllers for text and percentage fields
  final _jumlahAktivitasPosyanduController = TextEditingController();
  final _penyediaLayananDokterController = TextEditingController();
  final _penyediaLayananBidanController = TextEditingController();
  final _penyediaLayananTenagaKesehatanController = TextEditingController();
  final _persentasePesertaJaminanKesehatanController = TextEditingController();

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
    _jumlahAktivitasPosyanduController.dispose();
    _penyediaLayananDokterController.dispose();
    _penyediaLayananBidanController.dispose();
    _penyediaLayananTenagaKesehatanController.dispose();
    _persentasePesertaJaminanKesehatanController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final data = Kesehatan(
      villageId: '',
      year: _year,
      kemudahanAksesSaranaKesehatan: _kemudahanAksesSaranaKesehatan ?? '',
      ketersediaanFasilitasKesehatan: _ketersediaanFasilitasKesehatan ?? '',
      kemudahanAksesFasilitasKesehatan: _kemudahanAksesFasilitasKesehatan ?? '',
      ketersediaanPosyandu: _ketersediaanPosyandu ?? '',
      jumlahAktivitasPosyandu: _jumlahAktivitasPosyanduController.text,
      kemudahanAksesPosyandu: _kemudahanAksesPosyandu ?? '',
      ketersediaanLayananDokter: _ketersediaanLayananDokter ?? '',
      hariOperasionalLayananDokter: _hariOperasionalLayananDokter ?? '',
      penyediaLayananDokter: _penyediaLayananDokterController.text,
      penyediaTransportasiLayananDokter: _penyediaTransportasiLayananDokter ?? '',
      ketersediaanLayananBidan: _ketersediaanLayananBidan ?? '',
      hariOperasionalLayananBidan: _hariOperasionalLayananBidan ?? '',
      penyediaLayananBidan: _penyediaLayananBidanController.text,
      penyediaTransportasiLayananBidan: _penyediaTransportasiLayananBidan ?? '',
      ketersediaanLayananTenagaKesehatan: _ketersediaanLayananTenagaKesehatan ?? '',
      hariOperasionalLayananTenagaKesehatan: _hariOperasionalLayananTenagaKesehatan ?? '',
      penyediaLayananTenagaKesehatan: _penyediaLayananTenagaKesehatanController.text,
      penyediaTransportasiLayananTenagaKesehatan: _penyediaTransportasiLayananTenagaKesehatan ?? '',
      persentasePesertaJaminanKesehatan: _persentasePesertaJaminanKesehatanController.text,
      kegiatanSosialisasiJaminanKesehatan: _kegiatanSosialisasiJaminanKesehatan ?? '',
    );

    final result = await ref.read(kesehatanProvider).createKesehatan(data);

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
        title: const Text('Indikator Kesehatan'),
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
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
                          ),
                          child: const Icon(Icons.local_hospital, size: 32, color: Colors.red),
                        ),
                        const SizedBox(width: ForuiThemeConfig.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Kesehatan',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Isi data indikator kesehatan desa',
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

                    // Sarana Kesehatan Section
                    _buildSectionHeader('Sarana Kesehatan'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses Sarana Kesehatan',
                      value: _kemudahanAksesSaranaKesehatan,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.accessibility,
                      onChanged: (value) => setState(() => _kemudahanAksesSaranaKesehatan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Fasilitas Kesehatan Section
                    _buildSectionHeader('Fasilitas Kesehatan'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Fasilitas Kesehatan',
                      value: _ketersediaanFasilitasKesehatan,
                      options: FormOptions.ketersediaan,
                      prefixIcon: Icons.local_hospital_outlined,
                      onChanged: (value) => setState(() => _ketersediaanFasilitasKesehatan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses Fasilitas Kesehatan',
                      value: _kemudahanAksesFasilitasKesehatan,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.directions_walk,
                      onChanged: (value) => setState(() => _kemudahanAksesFasilitasKesehatan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Posyandu Section
                    _buildSectionHeader('Posyandu'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Posyandu',
                      value: _ketersediaanPosyandu,
                      options: FormOptions.ketersediaan,
                      prefixIcon: Icons.health_and_safety,
                      onChanged: (value) => setState(() => _ketersediaanPosyandu = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    TextFormField(
                      controller: _jumlahAktivitasPosyanduController,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Aktivitas Posyandu *',
                        hintText: 'Jumlah aktivitas per bulan',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => Validators.required(value, 'Jumlah Aktivitas Posyandu'),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses Posyandu',
                      value: _kemudahanAksesPosyandu,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.directions_walk,
                      onChanged: (value) => setState(() => _kemudahanAksesPosyandu = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Layanan Dokter Section
                    _buildSectionHeader('Layanan Dokter'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Layanan Dokter',
                      value: _ketersediaanLayananDokter,
                      options: FormOptions.ketersediaan,
                      prefixIcon: Icons.person_outline,
                      onChanged: (value) => setState(() => _ketersediaanLayananDokter = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Hari Operasional Layanan Dokter',
                      value: _hariOperasionalLayananDokter,
                      options: FormOptions.hariOperasional,
                      prefixIcon: Icons.calendar_month,
                      onChanged: (value) => setState(() => _hariOperasionalLayananDokter = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    TextFormField(
                      controller: _penyediaLayananDokterController,
                      decoration: const InputDecoration(
                        labelText: 'Penyedia Layanan Dokter *',
                        hintText: 'Contoh: Puskesmas, Rumah Sakit',
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) => Validators.required(value, 'Penyedia Layanan Dokter'),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Penyedia Transportasi Layanan Dokter',
                      value: _penyediaTransportasiLayananDokter,
                      options: FormOptions.ketersediaan,
                      prefixIcon: Icons.directions_car,
                      onChanged: (value) => setState(() => _penyediaTransportasiLayananDokter = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Layanan Bidan Section
                    _buildSectionHeader('Layanan Bidan'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Layanan Bidan',
                      value: _ketersediaanLayananBidan,
                      options: FormOptions.ketersediaan,
                      prefixIcon: Icons.person_outline,
                      onChanged: (value) => setState(() => _ketersediaanLayananBidan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Hari Operasional Layanan Bidan',
                      value: _hariOperasionalLayananBidan,
                      options: FormOptions.hariOperasional,
                      prefixIcon: Icons.calendar_month,
                      onChanged: (value) => setState(() => _hariOperasionalLayananBidan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    TextFormField(
                      controller: _penyediaLayananBidanController,
                      decoration: const InputDecoration(
                        labelText: 'Penyedia Layanan Bidan *',
                        hintText: 'Contoh: Puskesmas, Klinik',
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) => Validators.required(value, 'Penyedia Layanan Bidan'),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Penyedia Transportasi Layanan Bidan',
                      value: _penyediaTransportasiLayananBidan,
                      options: FormOptions.ketersediaan,
                      prefixIcon: Icons.directions_car,
                      onChanged: (value) => setState(() => _penyediaTransportasiLayananBidan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Layanan Tenaga Kesehatan Section
                    _buildSectionHeader('Layanan Tenaga Kesehatan'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Layanan Tenaga Kesehatan',
                      value: _ketersediaanLayananTenagaKesehatan,
                      options: FormOptions.ketersediaan,
                      prefixIcon: Icons.person_outline,
                      onChanged: (value) => setState(() => _ketersediaanLayananTenagaKesehatan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Hari Operasional Layanan Tenaga Kesehatan',
                      value: _hariOperasionalLayananTenagaKesehatan,
                      options: FormOptions.hariOperasional,
                      prefixIcon: Icons.calendar_month,
                      onChanged: (value) => setState(() => _hariOperasionalLayananTenagaKesehatan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    TextFormField(
                      controller: _penyediaLayananTenagaKesehatanController,
                      decoration: const InputDecoration(
                        labelText: 'Penyedia Layanan Tenaga Kesehatan *',
                        hintText: 'Contoh: Puskesmas, Klinik',
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) => Validators.required(value, 'Penyedia Layanan Tenaga Kesehatan'),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Penyedia Transportasi Layanan Tenaga Kesehatan',
                      value: _penyediaTransportasiLayananTenagaKesehatan,
                      options: FormOptions.ketersediaan,
                      prefixIcon: Icons.directions_car,
                      onChanged: (value) => setState(() => _penyediaTransportasiLayananTenagaKesehatan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Jaminan Kesehatan Section
                    _buildSectionHeader('Jaminan Kesehatan'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    PercentageInput(
                      label: 'Persentase Peserta Jaminan Kesehatan',
                      controller: _persentasePesertaJaminanKesehatanController,
                      hintText: 'Masukkan persentase (0-100)',
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kegiatan Sosialisasi Jaminan Kesehatan',
                      value: _kegiatanSosialisasiJaminanKesehatan,
                      options: FormOptions.dilakukan,
                      prefixIcon: Icons.campaign,
                      onChanged: (value) => setState(() => _kegiatanSosialisasiJaminanKesehatan = value),
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
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
