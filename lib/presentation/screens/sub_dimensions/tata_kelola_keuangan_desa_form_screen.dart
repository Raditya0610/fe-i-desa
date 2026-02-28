import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/form_options.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../data/models/sub_dimensions/tata_kelola_keuangan_desa.dart';
import '../../../providers/tata_kelola_keuangan_desa_provider.dart';
import '../../widgets/common/sub_dimension_dropdown.dart';

class TataKelolaKeuanganDesaFormScreen extends ConsumerStatefulWidget {
  const TataKelolaKeuanganDesaFormScreen({super.key});

  @override
  ConsumerState<TataKelolaKeuanganDesaFormScreen> createState() => _TataKelolaKeuanganDesaFormScreenState();
}

class _TataKelolaKeuanganDesaFormScreenState extends ConsumerState<TataKelolaKeuanganDesaFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _year = DateTime.now().year;

  // Dropdown state variables
  String? _pendapatanAsliDesa;
  String? _peningkatanPades;
  String? _penyertaanModalDdBumd;
  String? _asetTanahDesa;
  String? _asetKantorDesa;
  String? _asetPasarDesa;
  String? _asetLainnya;
  String? _produktivitasAsetDesa;
  String? _inventarisasiAsetDesa;

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

    final data = TataKelolaKeuanganDesa(
      villageId: '',
      year: _year,
      pendapatanAsliDesa: _pendapatanAsliDesa ?? '',
      peningkatanPades: _peningkatanPades ?? '',
      penyertaanModalDdBumd: _penyertaanModalDdBumd ?? '',
      asetTanahDesa: _asetTanahDesa ?? '',
      asetKantorDesa: _asetKantorDesa ?? '',
      asetPasarDesa: _asetPasarDesa ?? '',
      asetLainnya: _asetLainnya ?? '',
      produktivitasAsetDesa: _produktivitasAsetDesa ?? '',
      inventarisasiAsetDesa: _inventarisasiAsetDesa ?? '',
    );

    final result = await ref.read(tataKelolaKeuanganDesaProvider).createTataKelolaKeuanganDesa(data);

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
        title: const Text('Indikator Tata Kelola Keuangan'),
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
                            color: Colors.pink.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
                          ),
                          child: const Icon(Icons.account_balance, size: 32, color: Colors.pink),
                        ),
                        const SizedBox(width: ForuiThemeConfig.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Tata Kelola Keuangan',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Isi data indikator tata kelola keuangan desa',
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

                    // Pendapatan Desa Section
                    _buildSectionHeader('Pendapatan Desa'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Pendapatan Asli Desa',
                      value: _pendapatanAsliDesa,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.money,
                      onChanged: (value) => setState(() => _pendapatanAsliDesa = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Peningkatan PADES',
                      value: _peningkatanPades,
                      options: FormOptions.peningkatan,
                      prefixIcon: Icons.trending_up,
                      onChanged: (value) => setState(() => _peningkatanPades = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Penyertaan Modal DD BUMD',
                      value: _penyertaanModalDdBumd,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.business,
                      onChanged: (value) => setState(() => _penyertaanModalDdBumd = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Aset Desa Section
                    _buildSectionHeader('Aset Desa'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Aset Tanah Desa',
                      value: _asetTanahDesa,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.landscape,
                      onChanged: (value) => setState(() => _asetTanahDesa = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Aset Kantor Desa',
                      value: _asetKantorDesa,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.apartment,
                      onChanged: (value) => setState(() => _asetKantorDesa = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Aset Pasar Desa',
                      value: _asetPasarDesa,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.shopping_cart,
                      onChanged: (value) => setState(() => _asetPasarDesa = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Aset Lainnya',
                      value: _asetLainnya,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.layers,
                      onChanged: (value) => setState(() => _asetLainnya = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Pengelolaan Aset Section
                    _buildSectionHeader('Pengelolaan Aset'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Produktivitas Aset Desa',
                      value: _produktivitasAsetDesa,
                      options: FormOptions.tingkat,
                      prefixIcon: Icons.assessment,
                      onChanged: (value) => setState(() => _produktivitasAsetDesa = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Inventarisasi Aset Desa',
                      value: _inventarisasiAsetDesa,
                      options: FormOptions.kelengkapan,
                      prefixIcon: Icons.assignment,
                      onChanged: (value) => setState(() => _inventarisasiAsetDesa = value),
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
        color: Colors.pink.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
        border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.pink.shade700,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
