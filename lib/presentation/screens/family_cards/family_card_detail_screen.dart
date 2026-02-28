import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../providers/family_card_detail_provider.dart';
import '../../../data/repositories/villager_repository.dart';
import '../../widgets/common/app_sidebar.dart';
import '../../widgets/villagers/avatar_circle.dart';
import '../../widgets/family_cards/villager_form_dialog.dart';

class FamilyCardDetailScreen extends ConsumerWidget {
  final String nik;

  const FamilyCardDetailScreen({
    super.key,
    required this.nik,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(familyCardDetailProvider(nik));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar
          const AppSidebar(),

          // Main Content
          Expanded(
            child: detailState.when(
              data: (familyCardDetail) {
                if (familyCardDetail == null) {
                  return _buildNotFoundState(context);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(context, ref, familyCardDetail.name),

                    // Scrollable Content
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          ref.invalidate(familyCardDetailProvider(nik));
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Family Info Card
                              _buildFamilyInfoCard(context, familyCardDetail),
                              const SizedBox(height: ForuiThemeConfig.spacingLarge),

                              // Members Section Header with Add Button
                              _buildMembersSectionHeader(context, ref),
                              const SizedBox(height: ForuiThemeConfig.spacingMedium),

                              // Members Table
                              _buildMembersTable(context, ref, familyCardDetail.familyMembers),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Footer
                    _buildFooter(),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(context, ref, error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, String familyHeadName) {
    return Container(
      padding: const EdgeInsets.all(ForuiThemeConfig.spacingLarge),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: ForuiThemeConfig.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detail Kartu Keluarga',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ForuiThemeConfig.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  familyHeadName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(familyCardDetailProvider(nik));
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyInfoCard(BuildContext context, dynamic familyCardDetail) {
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
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: ForuiThemeConfig.surfaceGreen,
                  borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
                ),
                child: const Icon(
                  Icons.family_restroom,
                  size: 32,
                  color: ForuiThemeConfig.primaryGreen,
                ),
              ),
              const SizedBox(width: ForuiThemeConfig.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      familyCardDetail.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ForuiThemeConfig.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'No. KK: ${familyCardDetail.nik}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: ForuiThemeConfig.surfaceGreen,
                  borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.people,
                      size: 20,
                      color: ForuiThemeConfig.primaryGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${familyCardDetail.totalMembers} Anggota',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ForuiThemeConfig.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: ForuiThemeConfig.spacingMedium),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: ForuiThemeConfig.spacingMedium),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 20,
                color: ForuiThemeConfig.primaryGreen,
              ),
              const SizedBox(width: ForuiThemeConfig.spacingSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alamat',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      familyCardDetail.address,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ForuiThemeConfig.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSectionHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Anggota Keluarga',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ForuiThemeConfig.textPrimary,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddVillagerDialog(context, ref),
          icon: const Icon(Icons.person_add, size: 18),
          label: const Text('Tambah Anggota'),
          style: ElevatedButton.styleFrom(
            backgroundColor: ForuiThemeConfig.primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddVillagerDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VillagerFormDialog(
        familyCardId: nik,
        onSuccess: () {
          ref.invalidate(familyCardDetailProvider(nik));
        },
      ),
    );
  }

  void _showEditVillagerDialog(BuildContext context, WidgetRef ref, Map<String, dynamic> member) {
    final memberNik = member['nik'] as String?;
    if (memberNik == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('NIK tidak ditemukan'),
          backgroundColor: ForuiThemeConfig.errorColor,
        ),
      );
      return;
    }

    // Build edit map directly from the member data already available in the
    // family card detail response — no extra network call needed.
    final editMap = <String, dynamic>{
      'nik': member['nik'],
      'name': member['name'] ?? member['nama_lengkap'] ?? '',
      'nama_lengkap': member['name'] ?? member['nama_lengkap'] ?? '',
      'jenis_kelamin': member['jenis_kelamin'] ?? '',
      'status_hubungan': member['status_hubungan'],
      'pendidikan': member['pendidikan'],
      'pekerjaan': member['pekerjaan'],
      // Fields not available from family card detail — passed empty so the
      // user can optionally fill them in.
      'tempat_lahir': member['tempat_lahir'] ?? '',
      'tanggal_lahir': member['tanggal_lahir'],
      'agama': member['agama'],
      'status_perkawinan': member['status_perkawinan'],
      'kewarganegaraan': member['kewarganegaraan'] ?? 'WNI',
      'nomor_paspor': member['nomor_paspor'] ?? '',
      'nomor_kitas': member['nomor_kitas'] ?? '',
      'nama_ayah': member['nama_ayah'] ?? '',
      'nama_ibu': member['nama_ibu'] ?? '',
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VillagerFormDialog(
        familyCardId: nik,
        existingMember: editMap,
        onSuccess: () {
          ref.invalidate(familyCardDetailProvider(nik));
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref, Map<String, dynamic> member) async {
    final memberName = member['name'] ?? member['nama_lengkap'] ?? 'Anggota';
    final memberNik = member['nik'];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusLarge),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ForuiThemeConfig.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: ForuiThemeConfig.errorColor,
              ),
            ),
            const SizedBox(width: ForuiThemeConfig.spacingMedium),
            const Text('Hapus Anggota'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Apakah Anda yakin ingin menghapus anggota keluarga ini?'),
            const SizedBox(height: ForuiThemeConfig.spacingMedium),
            Container(
              padding: const EdgeInsets.all(ForuiThemeConfig.spacingMedium),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusSmall),
              ),
              child: Row(
                children: [
                  AvatarCircle(name: memberName, size: 40),
                  const SizedBox(width: ForuiThemeConfig.spacingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          memberName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (memberNik != null)
                          Text(
                            'NIK: $memberNik',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: ForuiThemeConfig.spacingMedium),
            Text(
              'Data yang dihapus tidak dapat dikembalikan.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ForuiThemeConfig.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && memberNik != null) {
      // Show loading
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );
      }

      final repository = VillagerRepository();
      final result = await repository.deleteVillager(memberNik);

      // Hide loading
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Anggota berhasil dihapus'),
              backgroundColor: ForuiThemeConfig.successColor,
            ),
          );
          ref.invalidate(familyCardDetailProvider(nik));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Gagal menghapus anggota'),
              backgroundColor: ForuiThemeConfig.errorColor,
            ),
          );
        }
      }
    }
  }

  Widget _buildMembersTable(BuildContext context, WidgetRef ref, List<Map<String, dynamic>> members) {
    if (members.isEmpty) {
      return _buildEmptyMembersState(context, ref);
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusLarge),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header Row
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Row(
              children: [
                SizedBox(
                  width: 48,
                  child: Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('NIK', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('NAMA', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 1,
                  child: Text('USIA', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('PENDIDIKAN', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('PEKERJAAN', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  width: 100,
                  child: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          // Data Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: members.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              final member = members[index];
              final isHead = member['status_hubungan'] == 'Kepala Keluarga';
              return Container(
                color: isHead ? Colors.green.shade50 : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 48,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        member['nik'] ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          AvatarCircle(
                            name: member['name'] ?? 'Unknown',
                            size: 32,
                          ),
                          const SizedBox(width: ForuiThemeConfig.spacingSmall),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member['name'] ?? '-',
                                  style: TextStyle(
                                    fontWeight: isHead ? FontWeight.bold : FontWeight.w500,
                                  ),
                                ),
                                if (member['jenis_kelamin'] != null)
                                  Text(
                                    member['jenis_kelamin'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isHead
                              ? ForuiThemeConfig.primaryGreen.withValues(alpha: 0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          member['status_hubungan'] ?? '-',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isHead ? FontWeight.bold : FontWeight.w500,
                            color: isHead ? ForuiThemeConfig.primaryGreen : ForuiThemeConfig.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        member['age'] != null ? '${member['age']} thn' : '-',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        member['pendidikan'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        member['pekerjaan'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: ForuiThemeConfig.primaryGreen,
                            ),
                            onPressed: () => _showEditVillagerDialog(context, ref, member),
                            tooltip: 'Edit',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: ForuiThemeConfig.errorColor,
                            ),
                            onPressed: () => _showDeleteConfirmation(context, ref, member),
                            tooltip: 'Hapus',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMembersState(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(ForuiThemeConfig.spacingXLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ForuiThemeConfig.borderRadiusLarge),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.person_off,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: ForuiThemeConfig.spacingMedium),
            const Text(
              'Belum ada anggota keluarga',
              style: TextStyle(color: ForuiThemeConfig.textSecondary),
            ),
            const SizedBox(height: ForuiThemeConfig.spacingMedium),
            ElevatedButton.icon(
              onPressed: () => _showAddVillagerDialog(context, ref),
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Tambah Anggota Pertama'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ForuiThemeConfig.primaryGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
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

  Widget _buildNotFoundState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: ForuiThemeConfig.spacingMedium),
          const Text(
            'Data tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              color: ForuiThemeConfig.textSecondary,
            ),
          ),
          const SizedBox(height: ForuiThemeConfig.spacingMedium),
          ElevatedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Kembali'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ForuiThemeConfig.primaryGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
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
          Text(
            'Terjadi kesalahan: $error',
            style: const TextStyle(color: ForuiThemeConfig.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ForuiThemeConfig.spacingMedium),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(familyCardDetailProvider(nik));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ForuiThemeConfig.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
