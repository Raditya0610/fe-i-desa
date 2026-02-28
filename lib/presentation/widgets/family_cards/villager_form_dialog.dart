import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/villager.dart';
import '../../../data/repositories/villager_repository.dart';

class VillagerFormDialog extends StatefulWidget {
  final String familyCardId;
  final Map<String, dynamic>? existingMember; // For edit mode
  final VoidCallback onSuccess;

  const VillagerFormDialog({
    super.key,
    required this.familyCardId,
    this.existingMember,
    required this.onSuccess,
  });

  bool get isEditMode => existingMember != null;

  @override
  State<VillagerFormDialog> createState() => _VillagerFormDialogState();
}

class _VillagerFormDialogState extends State<VillagerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _villagerRepository = VillagerRepository();
  bool _isLoading = false;

  // Form controllers
  late TextEditingController _nikController;
  late TextEditingController _namaController;
  late TextEditingController _tempatLahirController;
  late TextEditingController _pekerjaanController;
  late TextEditingController _namaAyahController;
  late TextEditingController _namaIbuController;
  late TextEditingController _nomorPasporController;
  late TextEditingController _nomorKitasController;

  // Dropdown values
  String? _jenisKelamin;
  DateTime? _tanggalLahir;
  String? _agama;
  String? _pendidikan;
  String? _statusPerkawinan;
  String? _statusHubungan;
  String? _kewarganegaraan;

  // Dropdown options
  static const List<String> _jenisKelaminOptions = ['L', 'P'];
  static const List<String> _agamaOptions = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Buddha',
    'Konghucu',
  ];
  static const List<String> _pendidikanOptions = [
    'Tidak/Belum Sekolah',
    'Belum Tamat SD/Sederajat',
    'Tamat SD/Sederajat',
    'SLTP/Sederajat',
    'SLTA/Sederajat',
    'Diploma I/II',
    'Akademi/Diploma III/Sarjana Muda',
    'Diploma IV/Strata I',
    'Strata II',
    'Strata III',
  ];
  static const List<String> _statusPerkawinanOptions = [
    'Belum Kawin',
    'Kawin',
    'Cerai Hidup',
    'Cerai Mati',
  ];
  static const List<String> _statusHubunganOptions = [
    'Kepala Keluarga',
    'Istri',
    'Anak',
    'Menantu',
    'Cucu',
    'Orang Tua',
    'Mertua',
    'Famili Lain',
    'Pembantu',
    'Lainnya',
  ];
  static const List<String> _kewarganegaraanOptions = ['WNI', 'WNA'];

  // Map legacy/short education values to standard format
  String? _mapPendidikanValue(String? value) {
    if (value == null) return null;
    // If value already matches one of the options, return it
    if (_pendidikanOptions.contains(value)) return value;
    // Map short/legacy values to standard format
    const mapping = {
      'SD': 'Tamat SD/Sederajat',
      'SMP': 'SLTP/Sederajat',
      'SMA': 'SLTA/Sederajat',
      'SMK': 'SLTA/Sederajat',
      'D1': 'Diploma I/II',
      'D2': 'Diploma I/II',
      'D3': 'Akademi/Diploma III/Sarjana Muda',
      'S1': 'Diploma IV/Strata I',
      'S2': 'Strata II',
      'S3': 'Strata III',
      'Tidak Sekolah': 'Tidak/Belum Sekolah',
      'TK': 'Belum Tamat SD/Sederajat',
    };
    return mapping[value] ?? value;
  }

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final member = widget.existingMember;

    _nikController = TextEditingController(text: member?['nik'] ?? '');
    _namaController = TextEditingController(text: member?['name'] ?? member?['nama_lengkap'] ?? '');
    _tempatLahirController = TextEditingController(text: member?['tempat_lahir'] ?? '');
    _pekerjaanController = TextEditingController(text: member?['pekerjaan'] ?? '');
    _namaAyahController = TextEditingController(text: member?['nama_ayah'] ?? '');
    _namaIbuController = TextEditingController(text: member?['nama_ibu'] ?? '');
    _nomorPasporController = TextEditingController(text: member?['nomor_paspor'] ?? '');
    _nomorKitasController = TextEditingController(text: member?['nomor_kitas'] ?? '');

    // Initialize dropdown values
    if (member != null) {
      final jk = member['jenis_kelamin'];
      if (jk == 'Laki-laki') {
        _jenisKelamin = 'L';
      } else if (jk == 'Perempuan') {
        _jenisKelamin = 'P';
      } else {
        _jenisKelamin = jk;
      }

      if (member['tanggal_lahir'] != null) {
        try {
          _tanggalLahir = DateTime.parse(member['tanggal_lahir']);
        } catch (_) {}
      }

      _agama = member['agama'];
      _pendidikan = _mapPendidikanValue(member['pendidikan']);
      _statusPerkawinan = member['status_perkawinan'];
      _statusHubungan = member['status_hubungan'];
      _kewarganegaraan = member['kewarganegaraan'];
    }

    // Set defaults for new villager
    _kewarganegaraan ??= 'WNI';
  }

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _tempatLahirController.dispose();
    _pekerjaanController.dispose();
    _namaAyahController.dispose();
    _namaIbuController.dispose();
    _nomorPasporController.dispose();
    _nomorKitasController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Only require tanggal_lahir in create mode; in edit mode it's optional
    // because the family card detail response may not provide it.
    if (_tanggalLahir == null && !widget.isEditMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal lahir harus diisi'),
          backgroundColor: ForuiThemeConfig.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> result;

      if (widget.isEditMode) {
        // Build a partial update map — only include fields that have values.
        final updateData = <String, dynamic>{
          'nama_lengkap': _namaController.text,
          'pekerjaan': _pekerjaanController.text,
        };
        if (_jenisKelamin != null) updateData['jenis_kelamin'] = _jenisKelamin;
        if (_tempatLahirController.text.isNotEmpty) updateData['tempat_lahir'] = _tempatLahirController.text;
        if (_tanggalLahir != null) updateData['tanggal_lahir'] = _tanggalLahir!.toIso8601String().split('T')[0];
        if (_agama != null) updateData['agama'] = _agama;
        if (_pendidikan != null) updateData['pendidikan'] = _pendidikan;
        if (_statusPerkawinan != null) updateData['status_perkawinan'] = _statusPerkawinan;
        if (_statusHubungan != null) updateData['status_hubungan'] = _statusHubungan;
        if (_kewarganegaraan != null) updateData['kewarganegaraan'] = _kewarganegaraan;
        if (_nomorPasporController.text.isNotEmpty) updateData['nomor_paspor'] = _nomorPasporController.text;
        if (_nomorKitasController.text.isNotEmpty) updateData['nomor_kitas'] = _nomorKitasController.text;
        if (_namaAyahController.text.isNotEmpty) updateData['nama_ayah'] = _namaAyahController.text;
        if (_namaIbuController.text.isNotEmpty) updateData['nama_ibu'] = _namaIbuController.text;

        result = await _villagerRepository.updateVillager(
          widget.existingMember!['nik'],
          updateData,
        );
      } else {
        final villager = Villager(
          nik: _nikController.text,
          namaLengkap: _namaController.text,
          jenisKelamin: _jenisKelamin!,
          tempatLahir: _tempatLahirController.text,
          tanggalLahir: _tanggalLahir!,
          agama: _agama!,
          pendidikan: _pendidikan!,
          pekerjaan: _pekerjaanController.text,
          statusPerkawinan: _statusPerkawinan!,
          statusHubungan: _statusHubungan!,
          kewarganegaraan: _kewarganegaraan!,
          nomorPaspor: _nomorPasporController.text.isEmpty ? null : _nomorPasporController.text,
          nomorKitas: _nomorKitasController.text.isEmpty ? null : _nomorKitasController.text,
          namaAyah: _namaAyahController.text,
          namaIbu: _namaIbuController.text,
          familyCardId: widget.familyCardId,
        );
        result = await _villagerRepository.createVillager(villager);
      }

      if (mounted) {
        setState(() => _isLoading = false);

        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Berhasil'),
              backgroundColor: ForuiThemeConfig.successColor,
            ),
          );
          Navigator.of(context).pop();
          widget.onSuccess();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Gagal menyimpan data'),
              backgroundColor: ForuiThemeConfig.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: ForuiThemeConfig.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ForuiThemeConfig.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _tanggalLahir = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusLarge),
      ),
      child: Container(
        width: 700,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
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
                    child: Icon(
                      widget.isEditMode ? Icons.edit : Icons.person_add,
                      size: 24,
                      color: ForuiThemeConfig.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: ForuiThemeConfig.spacingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isEditMode ? 'Edit Anggota Keluarga' : 'Tambah Anggota Keluarga',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ForuiThemeConfig.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.isEditMode
                              ? 'Ubah data anggota keluarga'
                              : 'Lengkapi data anggota keluarga baru',
                          style: const TextStyle(
                            fontSize: 14,
                            color: ForuiThemeConfig.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section: Data Pribadi
                      _buildSectionHeader('Data Pribadi'),
                      const SizedBox(height: ForuiThemeConfig.spacingMedium),

                      // NIK
                      _buildTextField(
                        controller: _nikController,
                        label: 'NIK',
                        hint: 'Masukkan 16 digit NIK',
                        icon: Icons.credit_card,
                        keyboardType: TextInputType.number,
                        maxLength: 16,
                        validator: Validators.validateNIK,
                        enabled: !widget.isEditMode, // NIK cannot be changed in edit mode
                      ),
                      const SizedBox(height: ForuiThemeConfig.spacingMedium),

                      // Nama Lengkap
                      _buildTextField(
                        controller: _namaController,
                        label: 'Nama Lengkap',
                        hint: 'Masukkan nama lengkap',
                        icon: Icons.person,
                        validator: (v) => Validators.required(v, 'Nama'),
                      ),
                      const SizedBox(height: ForuiThemeConfig.spacingMedium),

                      // Row: Jenis Kelamin & Tanggal Lahir
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              label: 'Jenis Kelamin',
                              value: _jenisKelamin,
                              items: _jenisKelaminOptions,
                              displayText: (v) => v == 'L' ? 'Laki-laki' : 'Perempuan',
                              onChanged: (v) => setState(() => _jenisKelamin = v),
                            ),
                          ),
                          const SizedBox(width: ForuiThemeConfig.spacingMedium),
                          Expanded(
                            child: _buildDateField(),
                          ),
                        ],
                      ),
                      const SizedBox(height: ForuiThemeConfig.spacingMedium),

                      // Tempat Lahir
                      _buildTextField(
                        controller: _tempatLahirController,
                        label: 'Tempat Lahir',
                        hint: 'Masukkan tempat lahir',
                        icon: Icons.location_city,
                        validator: widget.isEditMode ? null : (v) => Validators.required(v, 'Tempat lahir'),
                        required: !widget.isEditMode,
                      ),
                      const SizedBox(height: ForuiThemeConfig.spacingLarge),

                      // Section: Status
                      _buildSectionHeader('Status'),
                      const SizedBox(height: ForuiThemeConfig.spacingMedium),

                      // Row: Agama & Status Perkawinan
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              label: 'Agama',
                              value: _agama,
                              items: _agamaOptions,
                              onChanged: (v) => setState(() => _agama = v),
                              required: !widget.isEditMode,
                            ),
                          ),
                          const SizedBox(width: ForuiThemeConfig.spacingMedium),
                          Expanded(
                            child: _buildDropdown(
                              label: 'Status Perkawinan',
                              value: _statusPerkawinan,
                              items: _statusPerkawinanOptions,
                              onChanged: (v) => setState(() => _statusPerkawinan = v),
                              required: !widget.isEditMode,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: ForuiThemeConfig.spacingMedium),

                      // Status Hubungan
                      _buildDropdown(
                        label: 'Status Hubungan dalam Keluarga',
                        value: _statusHubungan,
                        items: _statusHubunganOptions,
                        onChanged: (v) => setState(() => _statusHubungan = v),
                      ),
                      const SizedBox(height: ForuiThemeConfig.spacingLarge),

                      // Section: Pendidikan & Pekerjaan
                      _buildSectionHeader('Pendidikan & Pekerjaan'),
                      const SizedBox(height: ForuiThemeConfig.spacingMedium),

                      // Row: Pendidikan & Pekerjaan
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              label: 'Pendidikan',
                              value: _pendidikan,
                              items: _pendidikanOptions,
                              onChanged: (v) => setState(() => _pendidikan = v),
                            ),
                          ),
                          const SizedBox(width: ForuiThemeConfig.spacingMedium),
                          Expanded(
                            child: _buildTextField(
                              controller: _pekerjaanController,
                              label: 'Pekerjaan',
                              hint: 'Masukkan pekerjaan',
                              icon: Icons.work,
                              validator: (v) => Validators.required(v, 'Pekerjaan'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: ForuiThemeConfig.spacingLarge),

                      // Section: Kewarganegaraan
                      _buildSectionHeader('Kewarganegaraan'),
                      const SizedBox(height: ForuiThemeConfig.spacingMedium),

                      _buildDropdown(
                        label: 'Kewarganegaraan',
                        value: _kewarganegaraan,
                        items: _kewarganegaraanOptions,
                        onChanged: (v) => setState(() => _kewarganegaraan = v),
                      ),
                      const SizedBox(height: ForuiThemeConfig.spacingMedium),

                      // Conditional fields for WNA
                      if (_kewarganegaraan == 'WNA') ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _nomorPasporController,
                                label: 'Nomor Paspor',
                                hint: 'Masukkan nomor paspor',
                                icon: Icons.article,
                                required: false,
                              ),
                            ),
                            const SizedBox(width: ForuiThemeConfig.spacingMedium),
                            Expanded(
                              child: _buildTextField(
                                controller: _nomorKitasController,
                                label: 'Nomor KITAS',
                                hint: 'Masukkan nomor KITAS',
                                icon: Icons.badge,
                                required: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: ForuiThemeConfig.spacingMedium),
                      ],
                      const SizedBox(height: ForuiThemeConfig.spacingLarge),

                      // Section: Data Orang Tua
                      _buildSectionHeader('Data Orang Tua'),
                      const SizedBox(height: ForuiThemeConfig.spacingMedium),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _namaAyahController,
                              label: 'Nama Ayah',
                              hint: 'Masukkan nama ayah',
                              icon: Icons.person_outline,
                              validator: widget.isEditMode ? null : (v) => Validators.required(v, 'Nama ayah'),
                              required: !widget.isEditMode,
                            ),
                          ),
                          const SizedBox(width: ForuiThemeConfig.spacingMedium),
                          Expanded(
                            child: _buildTextField(
                              controller: _namaIbuController,
                              label: 'Nama Ibu',
                              hint: 'Masukkan nama ibu',
                              icon: Icons.person_outline,
                              validator: widget.isEditMode ? null : (v) => Validators.required(v, 'Nama ibu'),
                              required: !widget.isEditMode,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer with buttons
            Container(
              padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
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
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              widget.isEditMode ? 'Simpan Perubahan' : 'Tambah Anggota',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: ForuiThemeConfig.primaryGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: ForuiThemeConfig.spacingSmall),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ForuiThemeConfig.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLength,
    bool enabled = true,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${required ? ' *' : ''}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ForuiThemeConfig.textPrimary,
          ),
        ),
        const SizedBox(height: ForuiThemeConfig.spacingSmall),
        TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            filled: !enabled,
            fillColor: enabled ? null : Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            counterText: '',
          ),
          keyboardType: keyboardType,
          maxLength: maxLength,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String Function(String)? displayText,
    bool required = true,
  }) {
    // Ensure value is valid (exists in items) or null
    final safeValue = (value != null && items.contains(value)) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          required ? '$label *' : label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ForuiThemeConfig.textPrimary,
          ),
        ),
        const SizedBox(height: ForuiThemeConfig.spacingSmall),
        DropdownButtonFormField<String>(
          initialValue: safeValue,
          decoration: InputDecoration(
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
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(displayText?.call(item) ?? item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: required ? (v) => v == null ? '$label harus dipilih' : null : null,
        ),
      ],
    );
  }

  Widget _buildDateField() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Lahir *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ForuiThemeConfig.textPrimary,
          ),
        ),
        const SizedBox(height: ForuiThemeConfig.spacingSmall),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: ForuiThemeConfig.primaryGreen),
                const SizedBox(width: 12),
                Text(
                  _tanggalLahir != null
                      ? dateFormat.format(_tanggalLahir!)
                      : 'Pilih tanggal lahir',
                  style: TextStyle(
                    color: _tanggalLahir != null
                        ? ForuiThemeConfig.textPrimary
                        : ForuiThemeConfig.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
