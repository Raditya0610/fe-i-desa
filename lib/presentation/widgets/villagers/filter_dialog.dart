import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/forui_theme.dart';

class FilterDialog extends ConsumerStatefulWidget {
  final String? initialJenisKelamin;
  final String? initialPendidikan;
  final String? initialPekerjaan;
  final String? initialStatusPerkawinan;
  final int? initialMinAge;
  final int? initialMaxAge;

  const FilterDialog({
    super.key,
    this.initialJenisKelamin,
    this.initialPendidikan,
    this.initialPekerjaan,
    this.initialStatusPerkawinan,
    this.initialMinAge,
    this.initialMaxAge,
  });

  @override
  ConsumerState<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends ConsumerState<FilterDialog> {
  String? selectedJenisKelamin;
  String? selectedPendidikan;
  String? selectedPekerjaan;
  String? selectedStatusPerkawinan;
  TextEditingController minAgeController = TextEditingController();
  TextEditingController maxAgeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedJenisKelamin = widget.initialJenisKelamin;
    selectedPendidikan = widget.initialPendidikan;
    selectedPekerjaan = widget.initialPekerjaan;
    selectedStatusPerkawinan = widget.initialStatusPerkawinan;
    if (widget.initialMinAge != null) {
      minAgeController.text = widget.initialMinAge.toString();
    }
    if (widget.initialMaxAge != null) {
      maxAgeController.text = widget.initialMaxAge.toString();
    }
  }

  @override
  void dispose() {
    minAgeController.dispose();
    maxAgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
      ),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Data Penduduk',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: ForuiThemeConfig.spacingLarge),

            // Gender Filter
            const Text(
              'Jenis Kelamin',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ForuiThemeConfig.spacingSmall),
            Wrap(
              spacing: ForuiThemeConfig.spacingSmall,
              children: [
                _buildChip(
                  label: 'Semua',
                  isSelected: selectedJenisKelamin == null,
                  onTap: () => setState(() => selectedJenisKelamin = null),
                ),
                _buildChip(
                  label: 'Laki-Laki',
                  isSelected: selectedJenisKelamin == 'Laki-laki',
                  onTap: () => setState(() => selectedJenisKelamin = 'Laki-laki'),
                ),
                _buildChip(
                  label: 'Perempuan',
                  isSelected: selectedJenisKelamin == 'Perempuan',
                  onTap: () => setState(() => selectedJenisKelamin = 'Perempuan'),
                ),
              ],
            ),
            const SizedBox(height: ForuiThemeConfig.spacingMedium),

            // Age Range Filter
            const Text(
              'Rentang Umur',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ForuiThemeConfig.spacingSmall),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minAgeController,
                    decoration: const InputDecoration(
                      labelText: 'Min',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: ForuiThemeConfig.spacingMedium),
                Expanded(
                  child: TextField(
                    controller: maxAgeController,
                    decoration: const InputDecoration(
                      labelText: 'Max',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ForuiThemeConfig.spacingMedium),

            // Education Filter
            const Text(
              'Pendidikan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ForuiThemeConfig.spacingSmall),
            DropdownButtonFormField<String>(
              initialValue: selectedPendidikan,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              hint: const Text('Pilih Pendidikan'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Semua')),
                ..._educationOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))),
              ],
              onChanged: (value) => setState(() => selectedPendidikan = value),
            ),
            const SizedBox(height: ForuiThemeConfig.spacingMedium),

            // Occupation Filter
            const Text(
              'Pekerjaan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ForuiThemeConfig.spacingSmall),
            DropdownButtonFormField<String>(
              initialValue: selectedPekerjaan,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              hint: const Text('Pilih Pekerjaan'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Semua')),
                ..._occupationOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))),
              ],
              onChanged: (value) => setState(() => selectedPekerjaan = value),
            ),
            const SizedBox(height: ForuiThemeConfig.spacingMedium),

            // Marital Status Filter
            const Text(
              'Status Perkawinan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: ForuiThemeConfig.spacingSmall),
            Wrap(
              spacing: ForuiThemeConfig.spacingSmall,
              children: [
                _buildChip(
                  label: 'Semua',
                  isSelected: selectedStatusPerkawinan == null,
                  onTap: () => setState(() => selectedStatusPerkawinan = null),
                ),
                ..._maritalStatusOptions.map((status) => _buildChip(
                  label: status,
                  isSelected: selectedStatusPerkawinan == status,
                  onTap: () => setState(() => selectedStatusPerkawinan = status),
                )),
              ],
            ),
            const SizedBox(height: ForuiThemeConfig.spacingLarge),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedJenisKelamin = null;
                        selectedPendidikan = null;
                        selectedPekerjaan = null;
                        selectedStatusPerkawinan = null;
                        minAgeController.clear();
                        maxAgeController.clear();
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: ForuiThemeConfig.spacingMedium),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop({
                        'jenisKelamin': selectedJenisKelamin,
                        'pendidikan': selectedPendidikan,
                        'pekerjaan': selectedPekerjaan,
                        'statusPerkawinan': selectedStatusPerkawinan,
                        'minAge': minAgeController.text.isEmpty
                            ? null
                            : int.tryParse(minAgeController.text),
                        'maxAge': maxAgeController.text.isEmpty
                            ? null
                            : int.tryParse(maxAgeController.text),
                      });
                    },
                    child: const Text('Terapkan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: ForuiThemeConfig.primaryGreen.withValues(alpha: 0.2),
      checkmarkColor: ForuiThemeConfig.primaryGreen,
    );
  }

  static const List<String> _educationOptions = [
    'Tidak Sekolah',
    'SD',
    'SMP',
    'SMA',
    'D3',
    'S1',
    'S2',
    'S3',
  ];

  static const List<String> _occupationOptions = [
    'Petani',
    'Buruh',
    'Wiraswasta',
    'PNS',
    'Guru',
    'Dokter',
    'Pedagang',
    'Lainnya',
  ];

  static const List<String> _maritalStatusOptions = [
    'Belum Menikah',
    'Menikah',
    'Cerai',
  ];
}
