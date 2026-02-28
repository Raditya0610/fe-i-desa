import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/forui_theme.dart';

/// A text input widget for percentage values (0-100) with validation
class PercentageInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final bool isRequired;
  final String? hintText;

  const PercentageInput({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.prefixIcon,
    this.isRequired = true,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        _PercentageRangeFormatter(),
      ],
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        hintText: hintText ?? 'Masukkan nilai 0-100',
        prefixIcon: Icon(prefixIcon ?? Icons.percent),
        suffixText: '%',
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
          borderSide: const BorderSide(color: ForuiThemeConfig.textHint),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
          borderSide:
              const BorderSide(color: ForuiThemeConfig.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
          borderSide: const BorderSide(color: ForuiThemeConfig.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
          borderSide: const BorderSide(color: ForuiThemeConfig.errorColor, width: 2),
        ),
      ),
      validator: validator ??
          (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return '$label harus diisi';
            }
            if (value != null && value.isNotEmpty) {
              final number = double.tryParse(value);
              if (number == null) {
                return '$label harus berupa angka';
              }
              if (number < 0 || number > 100) {
                return '$label harus antara 0-100';
              }
            }
            return null;
          },
    );
  }
}

/// Input formatter that restricts values to 0-100 range
class _PercentageRangeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final number = double.tryParse(newValue.text);
    if (number != null && number > 100) {
      return oldValue;
    }

    return newValue;
  }
}
