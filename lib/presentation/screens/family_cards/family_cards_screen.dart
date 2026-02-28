import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../providers/family_card_provider.dart';
import '../../../data/services/export_service.dart';
import '../../widgets/common/app_sidebar.dart';
import '../../widgets/villagers/avatar_circle.dart';

class FamilyCardsScreen extends ConsumerStatefulWidget {
  const FamilyCardsScreen({super.key});

  @override
  ConsumerState<FamilyCardsScreen> createState() => _FamilyCardsScreenState();
}

class _FamilyCardsScreenState extends ConsumerState<FamilyCardsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Set<String> selectedNiks = {};

  // Pagination
  int currentPage = 1;
  int itemsPerPage = 10;

  // Search query
  String searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      currentPage = 1; // Reset to first page when filtering
    });
  }

  List<dynamic> get filteredFamilyCards {
    final familyCardsState = ref.watch(familyCardsProvider);
    final allCards = familyCardsState.familyCards;

    if (searchQuery.isEmpty) {
      return allCards;
    }

    return allCards.where((card) {
      final query = searchQuery.toLowerCase();
      return card.name.toLowerCase().contains(query) ||
          card.nik.contains(query);
    }).toList();
  }

  List<dynamic> get paginatedFamilyCards {
    final filtered = filteredFamilyCards;
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;

    if (startIndex >= filtered.length) {
      return [];
    }

    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  int get totalPages {
    final total = filteredFamilyCards.length;
    return (total / itemsPerPage).ceil();
  }

  Future<void> _handleExport(BuildContext context) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Pilih format export:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'excel'),
            child: const Text('Excel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'csv'),
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );

    if (choice == null || !context.mounted) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Convert FamilyCard objects to Map format for export
    final exportData = filteredFamilyCards
        .map((card) => {
              'nik': card.nik,
              'nama_lengkap': card.name,
              'jumlah_anggota': card.totalMembers,
            })
        .toList();

    String? filePath;
    if (choice == 'excel') {
      filePath = await ExportService.exportFamilyCardsToExcel(exportData);
    } else if (choice == 'csv') {
      filePath = await ExportService.exportFamilyCardsToCsv(exportData);
    }

    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog

      if (filePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File berhasil disimpan di: $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengekspor data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final familyCardsState = ref.watch(familyCardsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar
          const AppSidebar(),

          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context),

                // Search and Filters
                _buildSearchAndFilters(context),

                // Content
                Expanded(
                  child: familyCardsState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : familyCardsState.error != null
                          ? _buildErrorState(context)
                          : familyCardsState.familyCards.isEmpty
                              ? _buildEmptyState(context)
                              : _buildDataTable(context),
                ),

                // Footer
                if (!familyCardsState.isLoading) _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
      color: Colors.white,
      child: Row(
        children: [
          // Back button (only shows if navigation history exists)
          if (Navigator.canPop(context))
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Data Kartu Keluarga',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ForuiThemeConfig.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Data Terpadu Desa',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Nama Kepala Keluarga / NIK...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
                _applyFilters();
              },
            ),
          ),
          const SizedBox(width: ForuiThemeConfig.spacingMedium),
          OutlinedButton.icon(
            onPressed: () {
              // Filter functionality placeholder
            },
            icon: const Icon(Icons.filter_alt_outlined),
            label: const Text('Filter'),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () => _handleExport(context),
            icon: const Icon(Icons.download),
            label: const Text('Export'),
          ),
          const SizedBox(width: ForuiThemeConfig.spacingMedium),
          ElevatedButton.icon(
            onPressed: () => context.push('/family-cards/add'),
            icon: const Icon(Icons.add),
            label: const Text('Tambah'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ForuiThemeConfig.primaryGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context) {
    final paginated = paginatedFamilyCards;

    return Container(
      margin: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusLarge),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Checkbox(
                    value: selectedNiks.length == paginated.length &&
                        paginated.isNotEmpty,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedNiks =
                              paginated.map((c) => c.nik as String).toSet();
                        } else {
                          selectedNiks.clear();
                        }
                      });
                    },
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text('NO KK',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Expanded(
                  flex: 3,
                  child: Text('KEPALA KELUARGA',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Expanded(
                  flex: 2,
                  child: Text('JUMLAH ANGGOTA',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  width: 80,
                  child: Text('AKSI',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Data rows
          Expanded(
            child: ListView.separated(
              itemCount: paginated.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final familyCard = paginated[index];
                final isSelected = selectedNiks.contains(familyCard.nik);
                return InkWell(
                  onTap: () => context.push('/family-cards/${familyCard.nik}'),
                  child: Container(
                    color: isSelected ? Colors.green.shade50 : Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 48,
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  selectedNiks.add(familyCard.nik);
                                } else {
                                  selectedNiks.remove(familyCard.nik);
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(familyCard.nik),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              AvatarCircle(name: familyCard.name, size: 32),
                              const SizedBox(
                                  width: ForuiThemeConfig.spacingMedium),
                              Expanded(child: Text(familyCard.name)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('${familyCard.totalMembers} orang'),
                        ),
                        SizedBox(
                          width: 80,
                          child: IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () =>
                                context.push('/family-cards/${familyCard.nik}'),
                            tooltip: 'Edit',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildTablePagination(),
        ],
      ),
    );
  }

  Widget _buildTablePagination() {
    final startIndex =
        filteredFamilyCards.isEmpty ? 0 : (currentPage - 1) * itemsPerPage + 1;
    final endIndex = currentPage * itemsPerPage > filteredFamilyCards.length
        ? filteredFamilyCards.length
        : currentPage * itemsPerPage;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ForuiThemeConfig.spacingLarge,
        vertical: ForuiThemeConfig.spacingMedium,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Menampilkan $startIndex-$endIndex dari ${filteredFamilyCards.length} data',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: currentPage > 1
                    ? () => setState(() => currentPage--)
                    : null,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Prev'),
              ),
              const SizedBox(width: ForuiThemeConfig.spacingSmall),
              OutlinedButton(
                onPressed: currentPage < totalPages
                    ? () => setState(() => currentPage++)
                    : null,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        '© 2025 Apps I-Desa. Hak Cipta Dilindungi.',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final familyCardsState = ref.watch(familyCardsProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: ForuiThemeConfig.errorColor,
          ),
          const SizedBox(height: ForuiThemeConfig.spacingMedium),
          Text(familyCardsState.error!),
          const SizedBox(height: ForuiThemeConfig.spacingMedium),
          ElevatedButton(
            onPressed: () {
              ref.read(familyCardsProvider.notifier).refresh();
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.family_restroom,
            size: 100,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: ForuiThemeConfig.spacingMedium),
          Text(
            'Belum ada data kartu keluarga',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ForuiThemeConfig.textSecondary,
                ),
          ),
          const SizedBox(height: ForuiThemeConfig.spacingMedium),
          ElevatedButton.icon(
            onPressed: () => context.push('/family-cards/add'),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Kartu Keluarga'),
          ),
        ],
      ),
    );
  }
}
