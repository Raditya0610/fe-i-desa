import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/form_options.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../data/models/sub_dimensions/fasilitas_masyarakat.dart';
import '../../../providers/fasilitas_masyarakat_provider.dart';
import '../../widgets/common/sub_dimension_dropdown.dart';

class FasilitasMasyarakatFormScreen extends ConsumerStatefulWidget {
  const FasilitasMasyarakatFormScreen({super.key});

  @override
  ConsumerState<FasilitasMasyarakatFormScreen> createState() => _FasilitasMasyarakatFormScreenState();
}

class _FasilitasMasyarakatFormScreenState extends ConsumerState<FasilitasMasyarakatFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _year = DateTime.now().year;

  // Dropdown state variables
  String? _terdapatTamanBacaanMasyarakat;
  String? _hariOperasionalTamanBacaanMasyarakat;
  String? _ketersediaanFasilitasOlahraga;
  String? _keberadaanRuangPublikTerbuka;

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

    final data = FasilitasMasyarakat(
      villageId: '',
      year: _year,
      terdapatTamanBacaanMasyarakat: _terdapatTamanBacaanMasyarakat ?? '',
      hariOperasionalTamanBacaanMasyarakat: _hariOperasionalTamanBacaanMasyarakat ?? '',
      ketersediaanFasilitasOlahraga: _ketersediaanFasilitasOlahraga ?? '',
      keberadaanRuangPublikTerbuka: _keberadaanRuangPublikTerbuka ?? '',
    );

    final result = await ref.read(fasilitasMasyarakatProvider).createFasilitasMasyarakat(data);

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
        title: const Text('Indikator Fasilitas Masyarakat'),
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
                            color: Colors.purple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
                          ),
                          child: const Icon(Icons.apartment, size: 32, color: Colors.purple),
                        ),
                        const SizedBox(width: ForuiThemeConfig.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Fasilitas Masyarakat',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Isi data indikator fasilitas masyarakat desa',
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

                    // Taman Bacaan Masyarakat Section
                    _buildSectionHeader('Taman Bacaan Masyarakat'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Terdapat Taman Bacaan Masyarakat',
                      value: _terdapatTamanBacaanMasyarakat,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.library_books,
                      onChanged: (value) => setState(() => _terdapatTamanBacaanMasyarakat = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Hari Operasional Taman Bacaan Masyarakat',
                      value: _hariOperasionalTamanBacaanMasyarakat,
                      options: FormOptions.hariOperasional,
                      prefixIcon: Icons.calendar_month,
                      onChanged: (value) => setState(() => _hariOperasionalTamanBacaanMasyarakat = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Fasilitas Olahraga Section
                    _buildSectionHeader('Fasilitas Olahraga'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan Fasilitas Olahraga',
                      value: _ketersediaanFasilitasOlahraga,
                      options: FormOptions.ketersediaan,
                      prefixIcon: Icons.sports_basketball,
                      onChanged: (value) => setState(() => _ketersediaanFasilitasOlahraga = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // Ruang Publik Terbuka Section
                    _buildSectionHeader('Ruang Publik Terbuka'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Keberadaan Ruang Publik Terbuka',
                      value: _keberadaanRuangPublikTerbuka,
                      options: FormOptions.keberadaan,
                      prefixIcon: Icons.park,
                      onChanged: (value) => setState(() => _keberadaanRuangPublikTerbuka = value),
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
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
        border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.purple.shade700,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
