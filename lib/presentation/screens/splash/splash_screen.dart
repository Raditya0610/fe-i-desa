import 'package:flutter/material.dart';
import '../../../core/theme/forui_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ForuiThemeConfig.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon/Logo placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: ForuiThemeConfig.primaryGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.location_city,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            // App Title
            const Text(
              'Apps I-Desa',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ForuiThemeConfig.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sistem Informasi Desa',
              style: TextStyle(
                fontSize: 14,
                color: ForuiThemeConfig.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  ForuiThemeConfig.primaryGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
