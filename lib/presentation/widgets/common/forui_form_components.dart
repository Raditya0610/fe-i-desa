import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/forui_theme.dart';

/// Form field wrapper for text input with validation
class ForuiTextField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final bool enabled;
  final bool required;
  final FocusNode? focusNode;

  const ForuiTextField({
    super.key,
    required this.label,
    this.placeholder,
    this.initialValue,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.enabled = true,
    this.required = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          required ? '$label *' : label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ForuiThemeConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          validator: validator,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          enabled: enabled,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: placeholder,
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

/// Date picker form field
class ForuiDatePicker extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(DateTime?)? validator;
  final void Function(DateTime?)? onChanged;
  final bool required;

  const ForuiDatePicker({
    super.key,
    required this.label,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.onChanged,
    this.required = false,
  });

  @override
  State<ForuiDatePicker> createState() => _ForuiDatePickerState();
}

class _ForuiDatePickerState extends State<ForuiDatePicker> {
  DateTime? _selectedDate;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ForuiThemeConfig.primaryGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: ForuiThemeConfig.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        if (widget.validator != null) {
          _errorText = widget.validator!(picked);
        }
      });
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.required ? '${widget.label} *' : widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ForuiThemeConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => _selectDate(context),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            alignment: Alignment.centerLeft,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  formattedDate ?? 'Select date',
                  style: TextStyle(
                    color: formattedDate != null
                        ? ForuiThemeConfig.textPrimary
                        : ForuiThemeConfig.textHint,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            _errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: ForuiThemeConfig.errorColor,
            ),
          ),
        ],
      ],
    );
  }
}

/// Select/Dropdown form field option
class ForuiSelectOption<T> {
  final T value;
  final String label;
  final Widget? child;

  const ForuiSelectOption({
    required this.value,
    required this.label,
    this.child,
  });
}

/// Select/Dropdown form field
class ForuiSelect<T> extends StatefulWidget {
  final String label;
  final String? placeholder;
  final T? initialValue;
  final List<ForuiSelectOption<T>> options;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final bool required;

  const ForuiSelect({
    super.key,
    required this.label,
    this.placeholder,
    this.initialValue,
    required this.options,
    this.validator,
    this.onChanged,
    this.required = false,
  });

  @override
  State<ForuiSelect<T>> createState() => _ForuiSelectState<T>();
}

class _ForuiSelectState<T> extends State<ForuiSelect<T>> {
  T? _selectedValue;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.required ? '${widget.label} *' : widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ForuiThemeConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: _selectedValue,
          hint: Text(widget.placeholder ?? 'Select option'),
          items: widget.options.map((option) {
            return DropdownMenuItem<T>(
              value: option.value,
              child: Text(option.label),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
              if (widget.validator != null) {
                _errorText = widget.validator!(value);
              }
            });
            widget.onChanged?.call(value);
          },
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(value);
            }
            return null;
          },
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            _errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: ForuiThemeConfig.errorColor,
            ),
          ),
        ],
      ],
    );
  }
}

/// Form section header
class ForuiFormSection extends StatelessWidget {
  final String title;
  final String? description;
  final List<Widget> children;

  const ForuiFormSection({
    super.key,
    required this.title,
    this.description,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ForuiThemeConfig.textPrimary,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: const TextStyle(
              fontSize: 14,
              color: ForuiThemeConfig.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

/// Toast/Alert helper for showing notifications
class ForuiAlertHelper {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ForuiThemeConfig.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
        ),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ForuiThemeConfig.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
        ),
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ForuiThemeConfig.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
        ),
      ),
    );
  }

  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: ForuiThemeConfig.warningColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
        ),
      ),
    );
  }
}
