import 'package:flutter/material.dart';
import '../../../core/theme/forui_theme.dart';

/// A reusable dropdown widget for sub-dimension form fields with fixed options
class SubDimensionDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool isRequired;
  final String? hintText;

  const SubDimensionDropdown({
    super.key,
    required this.label,
    this.value,
    required this.options,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.isRequired = true,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        hintText: hintText ?? 'Pilih $label',
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
          borderSide: const BorderSide(color: ForuiThemeConfig.textHint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
          borderSide: const BorderSide(color: ForuiThemeConfig.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
          borderSide: const BorderSide(color: ForuiThemeConfig.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
          borderSide: const BorderSide(color: ForuiThemeConfig.errorColor, width: 2),
        ),
      ),
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator ??
          (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return '$label harus dipilih';
            }
            return null;
          },
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
      dropdownColor: Colors.white,
    );
  }
}
