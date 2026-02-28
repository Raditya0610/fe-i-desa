import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/forui_theme.dart';
import '../../widgets/common/app_sidebar.dart';

class SubDimensionsHubScreen extends StatefulWidget {
  const SubDimensionsHubScreen({super.key});

  @override
  State<SubDimensionsHubScreen> createState() => _SubDimensionsHubScreenState();
}

class _SubDimensionsHubScreenState extends State<SubDimensionsHubScreen> {
  String _selectedCategory = 'pendidikan';

  // Category definitions
  final List<_CategoryItem> _categories = [
    const _CategoryItem(
      id: 'pendidikan',
      title: 'Pendidikan',
      description: 'Akses dan fasilitas pendidikan dasar hingga menengah.',
      icon: Icons.menu_book_outlined,
      route: '/sub-dimensions/pendidikan',
    ),
    const _CategoryItem(
      id: 'kesehatan',
      title: 'Kesehatan',
      description: 'Fasilitas dan layanan kesehatan masyarakat.',
      icon: Icons.favorite_border,
      route: '/sub-dimensions/kesehatan',
    ),
    const _CategoryItem(
      id: 'utilitas-dasar',
      title: 'Utilitas Dasar',
      description: 'Air bersih, listrik, dan sanitasi dasar.',
      icon: Icons.lightbulb_outline,
      route: '/sub-dimensions/utilitas-dasar',
    ),
    const _CategoryItem(
      id: 'aktivitas',
      title: 'Aktivitas',
      description: 'Kegiatan sosial dan kemasyarakatan.',
      icon: Icons.auto_awesome_outlined,
      route: '/sub-dimensions/aktivitas',
    ),
    const _CategoryItem(
      id: 'fasilitas-masyarakat',
      title: 'Fasilitas Masyarakat',
      description: 'Balai desa, tempat ibadah, dan fasilitas umum.',
      icon: Icons.people_outline,
      route: '/sub-dimensions/fasilitas-masyarakat',
    ),
    const _CategoryItem(
      id: 'produksi-desa',
      title: 'Produksi Desa',
      description: 'Hasil pertanian, peternakan, dan industri desa.',
      icon: Icons.agriculture_outlined,
      route: '/sub-dimensions/produksi-desa',
    ),
    const _CategoryItem(
      id: 'fasilitas-ekonomi',
      title: 'Fasilitas Ekonomi',
      description: 'Pasar, toko, dan infrastruktur perdagangan.',
      icon: Icons.store_outlined,
      route: '/sub-dimensions/fasilitas-ekonomi',
    ),
    const _CategoryItem(
      id: 'pengelolaan-lingkungan',
      title: 'Pengelolaan Lingkungan',
      description: 'Kelestarian dan kebersihan lingkungan.',
      icon: Icons.eco_outlined,
      route: '/sub-dimensions/pengelolaan-lingkungan',
    ),
    const _CategoryItem(
      id: 'penanggulangan-bencana',
      title: 'Penanggulangan Bencana',
      description: 'Mitigasi dan tanggap darurat bencana.',
      icon: Icons.warning_amber_outlined,
      route: '/sub-dimensions/penanggulangan-bencana',
    ),
    const _CategoryItem(
      id: 'kondisi-akses-jalan',
      title: 'Kondisi Akses Jalan',
      description: 'Infrastruktur dan kondisi jalan desa.',
      icon: Icons.route_outlined,
      route: '/sub-dimensions/kondisi-akses-jalan',
    ),
    const _CategoryItem(
      id: 'kemudahan-akses',
      title: 'Kemudahan Akses',
      description: 'Transportasi dan komunikasi.',
      icon: Icons.directions_car_outlined,
      route: '/sub-dimensions/kemudahan-akses',
    ),
    const _CategoryItem(
      id: 'kelembagaan-pelayanan',
      title: 'Kelembagaan Pelayanan',
      description: 'Layanan publik dan kelembagaan desa.',
      icon: Icons.business_outlined,
      route: '/sub-dimensions/kelembagaan-pelayanan',
    ),
    const _CategoryItem(
      id: 'tata-kelola-keuangan',
      title: 'Tata Kelola Keuangan',
      description: 'Pengelolaan dana dan keuangan desa.',
      icon: Icons.account_balance_outlined,
      route: '/sub-dimensions/tata-kelola-keuangan',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCategoryData = _categories.firstWhere(
      (c) => c.id == _selectedCategory,
      orElse: () => _categories.first,
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          const AppSidebar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Card with IDM Score
                        _buildHeroCard(),
                        const SizedBox(height: ForuiThemeConfig.spacingLarge),

                        // Three Score Cards
                        _buildScoreCardsRow(),
                        const SizedBox(height: ForuiThemeConfig.spacingLarge),

                        // Detail & Input Section
                        _buildDetailInputSection(selectedCategoryData),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ForuiThemeConfig.spacingLarge,
        vertical: ForuiThemeConfig.spacingMedium,
      ),
      color: Colors.white,
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Indikator Desa Membangun',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ForuiThemeConfig.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Data Terpadu Desa',
                  style: TextStyle(
                    fontSize: 14,
                    color: ForuiThemeConfig.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Search bar
          Container(
            width: 250,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(Icons.search, size: 20, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari data...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: ForuiThemeConfig.spacingMedium),
          // Notification icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
            ),
            child: Icon(Icons.notifications_outlined, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1B5E20),
            ForuiThemeConfig.primaryGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusLarge),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Year badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.white.withValues(alpha: 0.9)),
                      const SizedBox(width: 6),
                      Text(
                        'TAHUN 2025',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: ForuiThemeConfig.spacingMedium),
                // Village status
                const Text(
                  'Desa Mandiri',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Status Indeks Desa Membangun (IDM) tertinggi.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // IDM Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '0.895',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Skor Indeks Komposit',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCardsRow() {
    return const Row(
      children: [
        Expanded(
          child: _ScoreCard(
            title: 'Ketahanan Sosial',
            score: 0.912,
            status: 'Sangat Baik',
            color: Color(0xFF00897B),
            icon: Icons.people_alt_outlined,
          ),
        ),
        SizedBox(width: ForuiThemeConfig.spacingMedium),
        Expanded(
          child: _ScoreCard(
            title: 'Ketahanan Ekonomi',
            score: 0.845,
            status: 'Baik - Perlu Peningkatan UMKM',
            color: Color(0xFFFFA000),
            icon: Icons.monetization_on_outlined,
          ),
        ),
        SizedBox(width: ForuiThemeConfig.spacingMedium),
        Expanded(
          child: _ScoreCard(
            title: 'Ketahanan Lingkungan',
            score: 0.928,
            status: 'Sangat Baik',
            color: Color(0xFF43A047),
            icon: Icons.eco_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailInputSection(_CategoryItem selectedCategoryData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusLarge),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detail & Input Data IDM',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ForuiThemeConfig.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pilih kategori untuk memperbarui data indikator.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Save data functionality
                  },
                  icon: const Icon(Icons.save_outlined, size: 18),
                  label: const Text('Simpan Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ForuiThemeConfig.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category Tabs
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: ForuiThemeConfig.spacingLarge),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category.id == _selectedCategory;
                return _CategoryChip(
                  icon: category.icon,
                  label: category.title,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedCategory = category.id),
                );
              },
            ),
          ),
          const SizedBox(height: ForuiThemeConfig.spacingLarge),

          // Divider
          Divider(height: 1, color: Colors.grey.shade200),

          // Selected Category Content
          Padding(
            padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: ForuiThemeConfig.surfaceGreen,
                        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
                      ),
                      child: Icon(
                        selectedCategoryData.icon,
                        color: ForuiThemeConfig.primaryGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: ForuiThemeConfig.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedCategoryData.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ForuiThemeConfig.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedCategoryData.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => context.push(selectedCategoryData.route),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Buka Form Lengkap'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ForuiThemeConfig.primaryGreen,
                        side: const BorderSide(color: ForuiThemeConfig.primaryGreen),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ForuiThemeConfig.spacingLarge),

                // Placeholder for form content
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(ForuiThemeConfig.spacingXLarge),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusMedium),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        selectedCategoryData.icon,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: ForuiThemeConfig.spacingMedium),
                      Text(
                        'Klik "Buka Form Lengkap" untuk mengisi data ${selectedCategoryData.title}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
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
}

class _ScoreCard extends StatelessWidget {
  final String title;
  final double score;
  final String status;
  final Color color;
  final IconData icon;

  const _ScoreCard({
    required this.title,
    required this.score,
    required this.status,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusLarge),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                score.toStringAsFixed(3),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ForuiThemeConfig.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: ForuiThemeConfig.spacingMedium),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ForuiThemeConfig.textPrimary,
            ),
          ),
          const SizedBox(height: ForuiThemeConfig.spacingSmall),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: ForuiThemeConfig.spacingSmall),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? ForuiThemeConfig.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
          border: Border.all(
            color: isSelected ? ForuiThemeConfig.primaryGreen : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String route;

  const _CategoryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });
}
