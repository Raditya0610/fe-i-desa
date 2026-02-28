import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/form_options.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../data/models/sub_dimensions/produksi_desa.dart';
import '../../../providers/produksi_desa_provider.dart';
import '../../widgets/common/sub_dimension_dropdown.dart';

class ProduksiDesaFormScreen extends ConsumerStatefulWidget {
  const ProduksiDesaFormScreen({super.key});

  @override
  ConsumerState<ProduksiDesaFormScreen> createState() => _ProduksiDesaFormScreenState();
}

class _ProduksiDesaFormScreenState extends ConsumerState<ProduksiDesaFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _year = DateTime.now().year;

  // Dropdown state variables
  String? _keragamanAktivitasEkonomi;
  String? _keaktifanAktivitasEkonomi;
  String? _ketersediaanProdukUnggulanDesa;
  String? _cakupanPasarProdukUnggulan;
  String? _ketersediaanMerekDagang;
  String? _terdapatKearibanLokalEkonomi;
  String? _telahDilakukanKerjaSamaDenganDesaLainnya;
  String? _telahDilakukanKerjaSamaDenganPihakKetiga;

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

    final data = ProduksiDesa(
      villageId: '',
      year: _year,
      keragamanAktivitasEkonomi: _keragamanAktivitasEkonomi ?? '',
      keaktifanAktivitasEkonomi: _keaktifanAktivitasEkonomi ?? '',
      ketersediaanProdukUnggulanDesa: _ketersediaanProdukUnggulanDesa ?? '',
      cakupanPasarProdukUnggulan: _cakupanPasarProdukUnggulan ?? '',
      ketersediaanMerekDagang: _ketersediaanMerekDagang ?? '',
      terdapatKearibanLokalEkonomi: _terdapatKearibanLokalEkonomi ?? '',
      telahDilakukanKerjaSamaDenganDesaLainnya: _telahDilakukanKerjaSamaDenganDesaLainnya ?? '',
      telahDilakukanKerjaSamaDenganPihakKetiga: _telahDilakukanKerjaSamaDenganPihakKetiga ?? '',
    );

    final result = await ref.read(produksiDesaProvider).createProduksiDesa(data);

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
        title: const Text('Indikator Produksi Desa'),
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
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
                          ),
                          child: const Icon(Icons.agriculture, size: 32, color: Colors.green),
                        ),
                        const SizedBox(width: ForuiThemeConfig.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Produksi Desa',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Isi data indikator produksi desa',
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

                    // Aktivitas Ekonomi Section
                    _buildSectionHeader('Aktivitas Ekonomi'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Keragaman Aktivitas Ekonomi',
                      value: _keragamanAktivitasEkonomi,
                      options: FormOptions.keragaman,
                      prefixIcon: Icons.trending_up,
                      onChanged: (value) => setState(() => _keragamanAktivitasEkonomi = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Keaktifan Aktivitas Ekonomi',
                      value: _keaktifanAktivitasEkonomi,
                      options: FormOptions.keaktifan,
                      prefixIcon: Icons.verified,
                      onChanged: (value) => setState(() => _keaktifanAktivitasEkonomi = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Produk Unggulan Section
                    _buildSectionHeader('Produk Unggulan'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Produk Unggulan Desa',
                      value: _ketersediaanProdukUnggulanDesa,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.card_giftcard,
                      onChanged: (value) => setState(() => _ketersediaanProdukUnggulanDesa = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Cakupan Pasar Produk Unggulan',
                      value: _cakupanPasarProdukUnggulan,
                      options: FormOptions.cakupanPasar,
                      prefixIcon: Icons.public,
                      onChanged: (value) => setState(() => _cakupanPasarProdukUnggulan = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Merek Dagang Section
                    _buildSectionHeader('Merek Dagang'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Merek Dagang',
                      value: _ketersediaanMerekDagang,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.business,
                      onChanged: (value) => setState(() => _ketersediaanMerekDagang = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Kearifan Lokal Section
                    _buildSectionHeader('Kearifan Lokal'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Terdapat Kearifan Lokal Ekonomi',
                      value: _terdapatKearibanLokalEkonomi,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.history,
                      onChanged: (value) => setState(() => _terdapatKearibanLokalEkonomi = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Kerja Sama Section
                    _buildSectionHeader('Kerja Sama'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kerja Sama Dengan Desa Lainnya',
                      value: _telahDilakukanKerjaSamaDenganDesaLainnya,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.handshake,
                      onChanged: (value) => setState(() => _telahDilakukanKerjaSamaDenganDesaLainnya = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kerja Sama Dengan Pihak Ketiga',
                      value: _telahDilakukanKerjaSamaDenganPihakKetiga,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.groups,
                      onChanged: (value) => setState(() => _telahDilakukanKerjaSamaDenganPihakKetiga = value),
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
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
