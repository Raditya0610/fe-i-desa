import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/form_options.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../data/models/sub_dimensions/pendidikan.dart';
import '../../../providers/pendidikan_provider.dart';
import '../../widgets/common/sub_dimension_dropdown.dart';
import '../../widgets/common/percentage_input.dart';

class PendidikanFormScreen extends ConsumerStatefulWidget {
  const PendidikanFormScreen({super.key});

  @override
  ConsumerState<PendidikanFormScreen> createState() =>
      _PendidikanFormScreenState();
}

class _PendidikanFormScreenState extends ConsumerState<PendidikanFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _year = DateTime.now().year;

  // Dropdown state variables
  String? _ketersediaanPaud;
  String? _kemudahanAksesPaud;
  String? _kemudahanAksesSd;
  String? _kemudahanAksesSmp;
  String? _kemudahanAksesSma;

  // Controllers for percentage fields
  final _apmPaudController = TextEditingController();
  final _apmSdController = TextEditingController();
  final _apmSmpController = TextEditingController();
  final _apmSmaController = TextEditingController();

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
    _apmPaudController.dispose();
    _apmSdController.dispose();
    _apmSmpController.dispose();
    _apmSmaController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final data = Pendidikan(
      villageId: '',
      year: _year,
      ketersediaanPaud: _ketersediaanPaud ?? '',
      kemudahanAksesPaud: _kemudahanAksesPaud ?? '',
      apmPaud: _apmPaudController.text,
      kemudahanAksesSd: _kemudahanAksesSd ?? '',
      apmSd: _apmSdController.text,
      kemudahanAksesSmp: _kemudahanAksesSmp ?? '',
      apmSmp: _apmSmpController.text,
      kemudahanAksesSma: _kemudahanAksesSma ?? '',
      apmSma: _apmSmaController.text,
    );

    final result = await ref.read(pendidikanProvider).createPendidikan(data);

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
        title: const Text('Indikator Pendidikan'),
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
              borderRadius:
                  BorderRadius.circular(ForuiThemeConfig.borderRadiusLarge),
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
                          padding:
                              const EdgeInsets.all(ForuiThemeConfig.spacingMedium),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                                ForuiThemeConfig.borderRadiusMedium),
                          ),
                          child: const Icon(Icons.school,
                              size: 32, color: Colors.blue),
                        ),
                        const SizedBox(width: ForuiThemeConfig.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Pendidikan',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                'Isi data indikator pendidikan desa',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
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

                    // PAUD Section
                    _buildSectionHeader('Pendidikan Anak Usia Dini (PAUD)'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Ketersediaan PAUD',
                      value: _ketersediaanPaud,
                      options: FormOptions.ketersediaan,
                      prefixIcon: Icons.school_outlined,
                      onChanged: (value) =>
                          setState(() => _ketersediaanPaud = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses PAUD',
                      value: _kemudahanAksesPaud,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.directions_walk,
                      onChanged: (value) =>
                          setState(() => _kemudahanAksesPaud = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    PercentageInput(
                      label: 'APM PAUD',
                      controller: _apmPaudController,
                      hintText: 'Angka Partisipasi Murni (0-100)',
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // SD Section
                    _buildSectionHeader('Sekolah Dasar (SD)'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses SD',
                      value: _kemudahanAksesSd,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.directions_walk,
                      onChanged: (value) =>
                          setState(() => _kemudahanAksesSd = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    PercentageInput(
                      label: 'APM SD',
                      controller: _apmSdController,
                      hintText: 'Angka Partisipasi Murni (0-100)',
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // SMP Section
                    _buildSectionHeader('Sekolah Menengah Pertama (SMP)'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses SMP',
                      value: _kemudahanAksesSmp,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.directions_walk,
                      onChanged: (value) =>
                          setState(() => _kemudahanAksesSmp = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    PercentageInput(
                      label: 'APM SMP',
                      controller: _apmSmpController,
                      hintText: 'Angka Partisipasi Murni (0-100)',
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                    // SMA Section
                    _buildSectionHeader('Sekolah Menengah Atas (SMA)'),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    SubDimensionDropdown(
                      label: 'Kemudahan Akses SMA',
                      value: _kemudahanAksesSma,
                      options: FormOptions.kemudahanAkses,
                      prefixIcon: Icons.directions_walk,
                      onChanged: (value) =>
                          setState(() => _kemudahanAksesSma = value),
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),

                    PercentageInput(
                      label: 'APM SMA',
                      controller: _apmSmaController,
                      hintText: 'Angka Partisipasi Murni (0-100)',
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                                _isLoading ? 'Menyimpan...' : 'Simpan Data'),
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
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius:
            BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
