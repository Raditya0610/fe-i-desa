import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/common/app_sidebar.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          // Left Sidebar
          const AppSidebar(),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // AppBar
                _buildAppBar(context, authState),

                // Main Dashboard Content
                Expanded(
                  child: _buildMainContent(context, dashboardState),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, authState) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Back button (only shows if navigation history exists)
          if (Navigator.canPop(context))
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          const Spacer(),
          // Search bar
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Cari data...',
                hintStyle: TextStyle(fontSize: 14, color: ForuiThemeConfig.textHint),
                prefixIcon: Icon(Icons.search, size: 20, color: ForuiThemeConfig.textHint),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Notification icon
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: ForuiThemeConfig.textSecondary),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          // User menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle, color: ForuiThemeConfig.textSecondary),
            onSelected: (value) async {
              if (value == 'logout') {
                await ref.read(authStateProvider.notifier).logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'username',
                enabled: false,
                child: Text(
                  authState.username ?? 'User',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: ForuiThemeConfig.errorColor),
                    SizedBox(width: 8),
                    Text('Keluar'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, dashboardState) {
    return dashboardState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : dashboardState.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: ForuiThemeConfig.errorColor,
                    ),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),
                    Text(dashboardState.error!),
                    const SizedBox(height: ForuiThemeConfig.spacingMedium),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(dashboardProvider.notifier).refresh();
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
            : FadeTransition(
                opacity: _fadeAnimation,
                child: RefreshIndicator(
                  onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page title and date
                        _buildPageHeader(),
                        const SizedBox(height: 32),

                        // Main content - two column layout
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column - main content
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Welcome card
                                  if (dashboardState.dashboard != null)
                                    _buildWelcomeCard(context),
                                  const SizedBox(height: 32),

                                  // Statistics Cards
                                  if (dashboardState.dashboard != null)
                                    _buildStatisticsCards(context, dashboardState.dashboard),
                                  const SizedBox(height: 32),

                                  // Gender Chart
                                  if (dashboardState.dashboard != null)
                                    _buildGenderChart(context, dashboardState.dashboard!),
                                  const SizedBox(height: 32),

                                  // Administrative stats boxes
                                  if (dashboardState.dashboard != null)
                                    _buildAdministrativeStats(context, dashboardState.dashboard!),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),

                            // Right column - sidebar with insights and activities
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  if (dashboardState.dashboard != null)
                                    _buildInsightCepatCard(context, dashboardState.dashboard!),
                                  const SizedBox(height: 32),
                                  _buildAktivitasTerbaru(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }

  Widget _buildPageHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Demografi',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: ForuiThemeConfig.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Senin, 25 Oktober 2025',
          style: TextStyle(
            fontSize: 14,
            color: ForuiThemeConfig.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Halo, Admin! ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ForuiThemeConfig.textPrimary,
                      ),
                    ),
                    Text(
                      '👋',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Berikut adalah laporan terkini kondisi demograf desa. Data telah diperbarui secara otomatis dari sistem.',
                  style: TextStyle(
                    fontSize: 14,
                    color: ForuiThemeConfig.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // Export functionality
                },
                icon: const Icon(Icons.file_download_outlined, size: 18),
                label: const Text('Export Laporan'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  side: BorderSide(color: Colors.grey.shade300),
                  foregroundColor: ForuiThemeConfig.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/family-cards/add');
                },
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text('Tambah Penduduk'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  backgroundColor: ForuiThemeConfig.primaryGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards(BuildContext context, dashboard) {
    if (dashboard == null) return const SizedBox();

    return Row(
      children: [
        Expanded(
          child: _ModernStatCard(
            title: 'Total Penduduk',
            value: dashboard.totalPenduduk.toString(),
            icon: Icons.group_outlined,
            iconColor: const Color(0xFF10B981),
            iconBackground: const Color(0xFFD1FAE5),
            subtitle: '+2.4% bln ini',
            subtitleColor: const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _ModernStatCard(
            title: 'Total Keluarga',
            value: dashboard.totalKeluarga.toString(),
            icon: Icons.home_outlined,
            iconColor: const Color(0xFF3B82F6),
            iconBackground: const Color(0xFFDBEAFE),
            subtitle: 'Kepala Keluarga: ${dashboard.kepalaKeluarga}',
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _ModernStatCard(
            title: 'Rerata Umur',
            value: dashboard.rerataUmur.toStringAsFixed(2),
            icon: Icons.cake_outlined,
            iconColor: const Color(0xFFF59E0B),
            iconBackground: const Color(0xFFFEF3C7),
            subtitle: 'Tahun',
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _ModernStatCard(
            title: 'Rasio Keluarga',
            value: dashboard.rasioKeluarga.toStringAsFixed(3),
            icon: Icons.show_chart,
            iconColor: const Color(0xFF8B5CF6),
            iconBackground: const Color(0xFFEDE9FE),
            subtitle: 'Index Kepadatan',
          ),
        ),
      ],
    );
  }

  Widget _buildGenderChart(BuildContext context, dashboard) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Komposisi Gender',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ForuiThemeConfig.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Perbandingan Laki-laki dan Perempuan',
                    style: TextStyle(
                      fontSize: 13,
                      color: ForuiThemeConfig.textSecondary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz, color: ForuiThemeConfig.textSecondary),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 220,
            child: Row(
              children: [
                // Donut Chart
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: dashboard.lakiLaki.toDouble(),
                              color: const Color(0xFF3B82F6),
                              radius: 60,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: dashboard.perempuan.toDouble(),
                              color: const Color(0xFFEC4899),
                              radius: 60,
                              showTitle: false,
                            ),
                          ],
                          centerSpaceRadius: 70,
                          sectionsSpace: 4,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 13,
                              color: ForuiThemeConfig.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dashboard.totalPenduduk.toString(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: ForuiThemeConfig.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
                // Legend with progress bars
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildGenderLegendItem(
                        'Laki-Laki',
                        dashboard.lakiLaki,
                        const Color(0xFF3B82F6),
                        dashboard.genderRatioMale / 100,
                      ),
                      const SizedBox(height: 40),
                      _buildGenderLegendItem(
                        'Perempuan',
                        dashboard.perempuan,
                        const Color(0xFFEC4899),
                        dashboard.genderRatioFemale / 100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderLegendItem(String label, int value, Color color, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: ForuiThemeConfig.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ForuiThemeConfig.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildAdministrativeStats(BuildContext context, dashboard) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _AdminStatBox(
              label: 'KECAMATAN',
              value: dashboard.kecamatan.toString(),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _AdminStatBox(
              label: 'KELURAHAN',
              value: dashboard.kelurahan.toString(),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _AdminStatBox(
              label: 'TOTAL RW',
              value: dashboard.rw.toString(),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _AdminStatBox(
              label: 'TOTAL RT',
              value: dashboard.rt.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCepatCard(BuildContext context, dashboard) {
    final kepalaKeluargaProgress = dashboard.kepalaKeluarga / dashboard.totalKeluarga;
    final targetProgress = 0.85;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bolt, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Insight Cepat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Kepala Keluarga progress
          const Text(
            'Kepala Keluarga',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${dashboard.kepalaKeluarga} / ${dashboard.totalKeluarga}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: kepalaKeluargaProgress,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 24),
          // Target Pendataan progress
          const Text(
            'Target Pendataan',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(targetProgress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: targetProgress,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 24),
          // Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                context.push('/sub-dimensions');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lihat Analisis Lengkap',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAktivitasTerbaru(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Aktivitas Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ForuiThemeConfig.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 13,
                    color: ForuiThemeConfig.primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _ActivityItem(
            title: 'Penduduk Baru',
            subtitle: 'Keluarga Bpk. Hartono ditambahkan ke sistem.',
            time: '2 jam yang lalu',
            color: Color(0xFF10B981),
          ),
          const SizedBox(height: 20),
          const _ActivityItem(
            title: 'Update Kartu Keluarga',
            subtitle: 'Perubahan data pada No. KK 09123...',
            time: '5 jam yang lalu',
            color: Color(0xFF3B82F6),
          ),
          const SizedBox(height: 20),
          _ActivityItem(
            title: 'Sistem Backup',
            subtitle: 'Pencadangan data otomatis berhasil.',
            time: '1 hari yang lalu',
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}

// Modern stat card widget
class _ModernStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String? subtitle;
  final Color? subtitleColor;

  const _ModernStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.subtitle,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: ForuiThemeConfig.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: ForuiThemeConfig.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (subtitleColor != null)
                  Icon(Icons.arrow_upward, size: 14, color: subtitleColor),
                if (subtitleColor != null) const SizedBox(width: 4),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColor ?? ForuiThemeConfig.textSecondary,
                    fontWeight: subtitleColor != null ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Administrative stat box widget
class _AdminStatBox extends StatelessWidget {
  final String label;
  final String value;

  const _AdminStatBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: ForuiThemeConfig.textSecondary.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: ForuiThemeConfig.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// Activity item widget
class _ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final Color color;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ForuiThemeConfig.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: ForuiThemeConfig.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 11,
                  color: ForuiThemeConfig.textSecondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
