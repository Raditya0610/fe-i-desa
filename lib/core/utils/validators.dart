class Validators {
  // NIK Validation (16 digits)
  static String? validateNIK(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIK harus diisi';
    }
    if (value.length != 16) {
      return 'NIK harus 16 digit';
    }
    if (!RegExp(r'^\d{16}$').hasMatch(value)) {
      return 'NIK hanya boleh berisi angka';
    }
    return null;
  }

  // Required Field
  static String? required(String? value, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName harus diisi';
    }
    return null;
  }

  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  // Username Validation
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username harus diisi';
    }
    if (value.length < 3) {
      return 'Username minimal 3 karakter';
    }
    return null;
  }

  // Year Validation (2000-2100)
  static String? validateYear(int? value) {
    if (value == null) {
      return 'Tahun harus diisi';
    }
    if (value < 2000 || value > 2100) {
      return 'Tahun harus antara 2000-2100';
    }
    return null;
  }

  // Gender Validation (L or P)
  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jenis kelamin harus dipilih';
    }
    if (value != 'L' && value != 'P') {
      return 'Jenis kelamin harus L atau P';
    }
    return null;
  }

  // Date Validation
  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal harus diisi';
    }
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Format tanggal tidak valid (YYYY-MM-DD)';
    }
  }

  // Positive Number Validation
  static String? validatePositiveNumber(String? value, [String fieldName = 'Nilai']) {
    if (value == null || value.isEmpty) {
      return '$fieldName harus diisi';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return '$fieldName harus berupa angka';
    }
    if (number < 0) {
      return '$fieldName harus lebih dari 0';
    }
    return null;
  }

  // Phone Number Validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
      return 'Nomor telepon tidak valid';
    }
    return null;
  }

  // Max Length Validation
  static String? validateMaxLength(String? value, int maxLength, [String fieldName = 'Field']) {
    if (value != null && value.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter';
    }
    return null;
  }

  // Min Length Validation
  static String? validateMinLength(String? value, int minLength, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName harus diisi';
    }
    if (value.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }
    return null;
  }

  // Dropdown Required Validation
  static String? requiredDropdown(String? value, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName harus dipilih';
    }
    return null;
  }

  // Percentage Validation (0-100)
  static String? validatePercentage(String? value, [String fieldName = 'Persentase']) {
    if (value == null || value.isEmpty) {
      return '$fieldName harus diisi';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return '$fieldName harus berupa angka';
    }
    if (number < 0 || number > 100) {
      return '$fieldName harus antara 0-100';
    }
    return null;
  }

  // Option List Validation
  static String? validateOption(String? value, List<String> validOptions, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName harus dipilih';
    }
    if (!validOptions.contains(value)) {
      return '$fieldName tidak valid';
    }
    return null;
  }
}
