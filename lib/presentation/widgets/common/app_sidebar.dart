import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/forui_theme.dart';
import '../../../providers/auth_provider.dart';

class AppSidebar extends ConsumerStatefulWidget {
  const AppSidebar({super.key});

  @override
  ConsumerState<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends ConsumerState<AppSidebar> {
  bool _isDataPendudukExpanded = false;

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    // Auto-expand if on family-cards route
    if (currentRoute.startsWith('/family-cards') && !_isDataPendudukExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _isDataPendudukExpanded = true);
      });
    }

    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and branding
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ForuiThemeConfig.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.eco, color: ForuiThemeConfig.primaryGreen, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Apps i-Desa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ForuiThemeConfig.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Menu items
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MENU UTAMA section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      'MENU UTAMA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ForuiThemeConfig.textSecondary.withValues(alpha: 0.6),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _SidebarMenuItem(
                    icon: Icons.dashboard,
                    label: 'Dashboard',
                    isActive: currentRoute == '/',
                    onTap: () => context.go('/'),
                  ),
                  _ExpandableSidebarMenuItem(
                    icon: Icons.people_outline,
                    label: 'Data Penduduk',
                    isActive: currentRoute.startsWith('/family-cards'),
                    isExpanded: _isDataPendudukExpanded,
                    onToggle: () {
                      setState(() {
                        _isDataPendudukExpanded = !_isDataPendudukExpanded;
                      });
                    },
                    children: [
                      _SidebarSubMenuItem(
                        icon: Icons.home_outlined,
                        label: 'Keluarga',
                        isActive: currentRoute.startsWith('/family-cards'),
                        onTap: () => context.go('/family-cards'),
                      ),
                    ],
                  ),
                  _SidebarMenuItem(
                    icon: Icons.assessment_outlined,
                    label: 'Indikator Desa',
                    isActive: currentRoute.startsWith('/sub-dimensions'),
                    onTap: () => context.go('/sub-dimensions'),
                  ),

                ],
              ),
            ),
          ),

          // User profile section at bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ForuiThemeConfig.primaryGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'AD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Administrator',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ForuiThemeConfig.textPrimary,
                        ),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 12,
                          color: ForuiThemeConfig.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 20),
                  color: ForuiThemeConfig.textSecondary,
                  onPressed: () async {
                    await ref.read(authStateProvider.notifier).logout();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarMenuItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarMenuItem> createState() => _SidebarMenuItemState();
}

class _SidebarMenuItemState extends State<_SidebarMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActiveOrHovered = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isActive
                ? ForuiThemeConfig.primaryGreen.withValues(alpha: 0.1)
                : _isHovered
                    ? Colors.grey.shade100
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: widget.isActive
                    ? ForuiThemeConfig.primaryGreen
                    : isActiveOrHovered
                        ? ForuiThemeConfig.textPrimary
                        : ForuiThemeConfig.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                    color: widget.isActive
                        ? ForuiThemeConfig.primaryGreen
                        : isActiveOrHovered
                            ? ForuiThemeConfig.textPrimary
                            : ForuiThemeConfig.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandableSidebarMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isExpanded;
  final VoidCallback onToggle;
  final List<Widget> children;

  const _ExpandableSidebarMenuItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isExpanded,
    required this.onToggle,
    required this.children,
  });

  @override
  State<_ExpandableSidebarMenuItem> createState() => _ExpandableSidebarMenuItemState();
}

class _ExpandableSidebarMenuItemState extends State<_ExpandableSidebarMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActiveOrHovered = widget.isActive || _isHovered;

    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onToggle,
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.isActive
                    ? ForuiThemeConfig.primaryGreen.withValues(alpha: 0.1)
                    : _isHovered
                        ? Colors.grey.shade100
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 20,
                    color: widget.isActive
                        ? ForuiThemeConfig.primaryGreen
                        : isActiveOrHovered
                            ? ForuiThemeConfig.textPrimary
                            : ForuiThemeConfig.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                        color: widget.isActive
                            ? ForuiThemeConfig.primaryGreen
                            : isActiveOrHovered
                                ? ForuiThemeConfig.textPrimary
                                : ForuiThemeConfig.textSecondary,
                      ),
                    ),
                  ),
                  Icon(
                    widget.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    size: 20,
                    color: widget.isActive
                        ? ForuiThemeConfig.primaryGreen
                        : isActiveOrHovered
                            ? ForuiThemeConfig.textPrimary
                            : ForuiThemeConfig.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              children: widget.children,
            ),
          ),
      ],
    );
  }
}

class _SidebarSubMenuItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarSubMenuItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarSubMenuItem> createState() => _SidebarSubMenuItemState();
}

class _SidebarSubMenuItemState extends State<_SidebarSubMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActiveOrHovered = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isActive
                ? ForuiThemeConfig.primaryGreen.withValues(alpha: 0.1)
                : _isHovered
                    ? Colors.grey.shade100
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: widget.isActive
                    ? ForuiThemeConfig.primaryGreen
                    : isActiveOrHovered
                        ? ForuiThemeConfig.textPrimary
                        : ForuiThemeConfig.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                    color: widget.isActive
                        ? ForuiThemeConfig.primaryGreen
                        : isActiveOrHovered
                            ? ForuiThemeConfig.textPrimary
                            : ForuiThemeConfig.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
