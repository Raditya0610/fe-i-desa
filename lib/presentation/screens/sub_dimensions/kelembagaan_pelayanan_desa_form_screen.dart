import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/form_options.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../data/models/sub_dimensions/kelembagaan_pelayanan_desa.dart';
import '../../../providers/kelembagaan_pelayanan_desa_provider.dart';
import '../../widgets/common/sub_dimension_dropdown.dart';

class KelembagaanPelayananDesaFormScreen extends ConsumerStatefulWidget {
  const KelembagaanPelayananDesaFormScreen({super.key});

  @override
  ConsumerState<KelembagaanPelayananDesaFormScreen> createState() => _KelembagaanPelayananDesaFormScreenState();
}

class _KelembagaanPelayananDesaFormScreenState extends ConsumerState<KelembagaanPelayananDesaFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _year = DateTime.now().year;

  // Dropdown state variables
  String? _layananDiberikan;
  String? _publikasiInformasiPelayanan;
  String? _pelayananAdministrasi;
  String? _pelayananPengaduan;
  String? _pelayananLainnya;
  String? _musyawarahDesa;
  String? _musyawarahDesaDidatangiUnsurMasyarakat;

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

    final data = KelembagaanPelayananDesa(
      villageId: '',
      year: _year,
      layananDiberikan: _layananDiberikan ?? '',
      publikasiInformasiPelayanan: _publikasiInformasiPelayanan ?? '',
      pelayananAdministrasi: _pelayananAdministrasi ?? '',
      pelayananPengaduan: _pelayananPengaduan ?? '',
      pelayananLainnya: _pelayananLainnya ?? '',
      musyawarahDesa: _musyawarahDesa ?? '',
      musyawarahDesaDidatangiUnsurMasyarakat: _musyawarahDesaDidatangiUnsurMasyarakat ?? '',
    );

    final result = await ref.read(kelembagaanPelayananDesaProvider).createKelembagaanPelayananDesa(data);

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
        title: const Text('Indikator Kelembagaan Pelayanan'),
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
                            color: Colors.blueGrey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
                          ),
                          child: const Icon(Icons.business, size: 32, color: Colors.blueGrey),
                        ),
                        const SizedBox(width: ForuiThemeConfig.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Kelembagaan Pelayanan',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Isi data indikator kelembagaan pelayanan desa',
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

                    // Layanan Diberikan Section
                    _buildSectionHeader('Layanan Diberikan'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Layanan Diberikan',
                      value: _layananDiberikan,
                      options: FormOptions.kelengkapan,
                      prefixIcon: Icons.assignment,
                      onChanged: (value) => setState(() => _layananDiberikan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Publikasi Informasi Pelayanan',
                      value: _publikasiInformasiPelayanan,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.announcement,
                      onChanged: (value) => setState(() => _publikasiInformasiPelayanan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Jenis Pelayanan Section
                    _buildSectionHeader('Jenis Pelayanan'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Pelayanan Administrasi',
                      value: _pelayananAdministrasi,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.folder,
                      onChanged: (value) => setState(() => _pelayananAdministrasi = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Pelayanan Pengaduan',
                      value: _pelayananPengaduan,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.report_problem,
                      onChanged: (value) => setState(() => _pelayananPengaduan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Pelayanan Lainnya',
                      value: _pelayananLainnya,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.more_horiz,
                      onChanged: (value) => setState(() => _pelayananLainnya = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Musyawarah Desa Section
                    _buildSectionHeader('Musyawarah Desa'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Musyawarah Desa',
                      value: _musyawarahDesa,
                      options: FormOptions.frekuensiMusyawarah,
                      prefixIcon: Icons.people,
                      onChanged: (value) => setState(() => _musyawarahDesa = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Musyawarah Desa Didatangi Unsur Masyarakat',
                      value: _musyawarahDesaDidatangiUnsurMasyarakat,
                      options: FormOptions.yaTidak,
                      prefixIcon: Icons.verified,
                      onChanged: (value) => setState(() => _musyawarahDesaDidatangiUnsurMasyarakat = value),
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
        color: Colors.blueGrey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
        border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.3)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.blueGrey.shade700,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
