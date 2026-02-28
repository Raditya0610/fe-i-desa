import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedVillageId;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Available villages
  final List<Map<String, String>> _villages = [
    {
      'id': '83eb95cc-e9ac-425f-8cef-2c3db0e0c24a',
      'name': 'Ohoi Iso',
    },
    {
      'id': '9caa4ba3-3d4a-4fad-a5a0-6ca8ebc41ef7',
      'name': 'Ohoi Disuk',
    },
    {
      'id': 'ce964e83-4a13-45eb-a2e5-9b903b0c9033',
      'name': 'Ohoi Wain Baru',
    },
  ];

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
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await ref.read(authStateProvider.notifier).register(
          _usernameController.text,
          _passwordController.text,
          _selectedVillageId!,
        );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Pendaftaran berhasil! Silakan login.'),
          backgroundColor: ForuiThemeConfig.successColor,
        ),
      );
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Pendaftaran gagal'),
          backgroundColor: ForuiThemeConfig.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ForuiThemeConfig.primaryGreen,
              ForuiThemeConfig.darkGreen,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: FCard(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(ForuiThemeConfig.spacingXLarge),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo and Title
                          Container(
                            padding: const EdgeInsets.all(ForuiThemeConfig.spacingMedium),
                            decoration: BoxDecoration(
                              color: ForuiThemeConfig.primaryGreen.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_add_rounded,
                              size: 64,
                              color: ForuiThemeConfig.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: ForuiThemeConfig.spacingLarge),
                          Text(
                            'Daftar Akun Baru',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: ForuiThemeConfig.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: ForuiThemeConfig.spacingSmall),
                          Text(
                            'Buat akun untuk mengakses sistem',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: ForuiThemeConfig.textSecondary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                          // Username Field
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username *',
                              hintText: 'Masukkan username',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username harus diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: ForuiThemeConfig.spacingMedium),

                          // Village Dropdown
                          DropdownButtonFormField<String>(
                            initialValue: _selectedVillageId,
                            decoration: const InputDecoration(
                              labelText: 'Desa *',
                              hintText: 'Pilih desa',
                              prefixIcon: Icon(Icons.location_city),
                            ),
                            items: _villages.map((village) {
                              return DropdownMenuItem<String>(
                                value: village['id'],
                                child: Text(village['name']!),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedVillageId = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Desa harus dipilih';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: ForuiThemeConfig.spacingMedium),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password *',
                              hintText: 'Minimal 6 karakter',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password harus diisi';
                              }
                              if (value.length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: ForuiThemeConfig.spacingMedium),

                          // Confirm Password Field
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Konfirmasi Password *',
                              hintText: 'Masukkan password lagi',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi password harus diisi';
                              }
                              if (value != _passwordController.text) {
                                return 'Password tidak cocok';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: ForuiThemeConfig.spacingXLarge),

                          // Register Button
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ForuiThemeConfig.primaryGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    ForuiThemeConfig.borderRadiusMedium,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isLoading)
                                    const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  else
                                    const Icon(Icons.person_add, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isLoading ? 'Mendaftar...' : 'Daftar',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: ForuiThemeConfig.spacingLarge),

                          // Divider
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey.shade300)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: ForuiThemeConfig.spacingMedium,
                                ),
                                child: Text(
                                  'atau',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: ForuiThemeConfig.textSecondary,
                                      ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey.shade300)),
                            ],
                          ),
                          const SizedBox(height: ForuiThemeConfig.spacingLarge),

                          // Login Link
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Sudah punya akun? ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () => context.go('/login'),
                                child: const Text(
                                  'Masuk di sini',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ForuiThemeConfig.primaryGreen,
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
          ),
        ),
      ),
    );
  }
}
