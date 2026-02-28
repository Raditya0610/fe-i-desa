import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/family_card.dart';
import '../../../providers/family_card_provider.dart';
import '../../widgets/common/app_sidebar.dart';

class AddFamilyCardScreen extends ConsumerStatefulWidget {
  const AddFamilyCardScreen({super.key});

  @override
  ConsumerState<AddFamilyCardScreen> createState() =>
      _AddFamilyCardScreenState();
}

class _AddFamilyCardScreenState extends ConsumerState<AddFamilyCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _addressController = TextEditingController();
  final _rtController = TextEditingController();
  final _rwController = TextEditingController();
  final _kelurahanController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kabupatenKotaController = TextEditingController();
  final _kodePosController = TextEditingController();
  final _provinsiController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nikController.dispose();
    _addressController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _kelurahanController.dispose();
    _kecamatanController.dispose();
    _kabupatenKotaController.dispose();
    _kodePosController.dispose();
    _provinsiController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final familyCard = FamilyCard(
      nik: _nikController.text,
      name: '',
      totalMembers: 0,
      address: _addressController.text,
      rt: _rtController.text,
      rw: _rwController.text,
      kelurahan: _kelurahanController.text,
      kecamatan: _kecamatanController.text,
      kabupatenKota: _kabupatenKotaController.text,
      kodePos: _kodePosController.text,
      provinsi: _provinsiController.text,
    );

    final result = await ref
        .read(familyCardsProvider.notifier)
        .addFamilyCard(familyCard);

    setState(() {
      _isLoading = false;
    });

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
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar
          const AppSidebar(),

          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
                    child: _buildFormCard(context),
                  ),
                ),

                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: ForuiThemeConfig.spacingSmall),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tambah Kartu Keluarga',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ForuiThemeConfig.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tambahkan data kartu keluarga baru',
                  style: TextStyle(
                    fontSize: 14,
                    color: ForuiThemeConfig.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusLarge),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Form Header
          Container(
            padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(ForuiThemeConfig.borderRadiusLarge),
                topRight: Radius.circular(ForuiThemeConfig.borderRadiusLarge),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: ForuiThemeConfig.surfaceGreen,
                    borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
                  ),
                  child: const Icon(
                    Icons.family_restroom,
                    size: 24,
                    color: ForuiThemeConfig.primaryGreen,
                  ),
                ),
                const SizedBox(width: ForuiThemeConfig.spacingMedium),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Kartu Keluarga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ForuiThemeConfig.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Lengkapi data kartu keluarga di bawah ini',
                      style: TextStyle(
                        fontSize: 14,
                        color: ForuiThemeConfig.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Form Content
          Padding(
            padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // NIK Field
                  _buildFieldLabel('Nomor Kartu Keluarga *'),
                  const SizedBox(height: ForuiThemeConfig.spacingSmall),
                  TextFormField(
                    controller: _nikController,
                    decoration: _inputDecoration(
                      hint: 'Masukkan 16 digit nomor KK',
                      icon: Icons.credit_card,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    validator: Validators.validateNIK,
                  ),
                  const SizedBox(height: ForuiThemeConfig.spacingMedium),

                  // Address Field (full-width)
                  _buildFieldLabel('Alamat *'),
                  const SizedBox(height: ForuiThemeConfig.spacingSmall),
                  TextFormField(
                    controller: _addressController,
                    decoration: _inputDecoration(
                      hint: 'Masukkan alamat lengkap',
                      icon: Icons.location_on,
                    ),
                    validator: (value) => Validators.required(value, 'Alamat'),
                  ),
                  const SizedBox(height: ForuiThemeConfig.spacingMedium),

                  // RT / RW row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('RT *'),
                            const SizedBox(height: ForuiThemeConfig.spacingSmall),
                            TextFormField(
                              controller: _rtController,
                              decoration: _inputDecoration(
                                hint: 'RT',
                                icon: Icons.home,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) => Validators.required(value, 'RT'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: ForuiThemeConfig.spacingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('RW *'),
                            const SizedBox(height: ForuiThemeConfig.spacingSmall),
                            TextFormField(
                              controller: _rwController,
                              decoration: _inputDecoration(
                                hint: 'RW',
                                icon: Icons.home_work,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) => Validators.required(value, 'RW'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ForuiThemeConfig.spacingMedium),

                  // Kelurahan / Kecamatan row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Kelurahan *'),
                            const SizedBox(height: ForuiThemeConfig.spacingSmall),
                            TextFormField(
                              controller: _kelurahanController,
                              decoration: _inputDecoration(
                                hint: 'Masukkan kelurahan',
                                icon: Icons.location_city,
                              ),
                              validator: (value) => Validators.required(value, 'Kelurahan'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: ForuiThemeConfig.spacingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Kecamatan *'),
                            const SizedBox(height: ForuiThemeConfig.spacingSmall),
                            TextFormField(
                              controller: _kecamatanController,
                              decoration: _inputDecoration(
                                hint: 'Masukkan kecamatan',
                                icon: Icons.location_city,
                              ),
                              validator: (value) => Validators.required(value, 'Kecamatan'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ForuiThemeConfig.spacingMedium),

                  // Kabupaten/Kota / Kode Pos row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Kabupaten/Kota *'),
                            const SizedBox(height: ForuiThemeConfig.spacingSmall),
                            TextFormField(
                              controller: _kabupatenKotaController,
                              decoration: _inputDecoration(
                                hint: 'Masukkan kabupaten/kota',
                                icon: Icons.apartment,
                              ),
                              validator: (value) => Validators.required(value, 'Kabupaten/Kota'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: ForuiThemeConfig.spacingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Kode Pos *'),
                            const SizedBox(height: ForuiThemeConfig.spacingSmall),
                            TextFormField(
                              controller: _kodePosController,
                              decoration: _inputDecoration(
                                hint: 'Masukkan kode pos',
                                icon: Icons.markunread_mailbox,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) => Validators.required(value, 'Kode Pos'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ForuiThemeConfig.spacingMedium),

                  // Provinsi (full-width)
                  _buildFieldLabel('Provinsi *'),
                  const SizedBox(height: ForuiThemeConfig.spacingSmall),
                  TextFormField(
                    controller: _provinsiController,
                    decoration: _inputDecoration(
                      hint: 'Masukkan provinsi',
                      icon: Icons.map,
                    ),
                    validator: (value) => Validators.required(value, 'Provinsi'),
                  ),
                  const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
                            ),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: ForuiThemeConfig.spacingMedium),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ForuiThemeConfig.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: ForuiThemeConfig.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: ForuiThemeConfig.primaryGreen),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
        borderSide: const BorderSide(color: ForuiThemeConfig.primaryGreen, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      counterText: '',
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        '© 2025 Apps I-Desa. Hak Cipta Dilindungi.',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
