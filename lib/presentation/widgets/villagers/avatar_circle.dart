import 'package:flutter/material.dart';

class AvatarCircle extends StatelessWidget {
  final String name;
  final double size;
  final String? backgroundColor;

  const AvatarCircle({
    super.key,
    required this.name,
    this.size = 40,
    this.backgroundColor,
  });

  String _getInitials(String name) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return '?';

    final parts = trimmedName.split(' ').where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return '?';

    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }

    return (parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '') +
        (parts[1].isNotEmpty ? parts[1][0].toUpperCase() : '');
  }

  Color _getColorFromName(String name) {
    final colors = [
      const Color(0xFF4CAF50),  // Green
      const Color(0xFF2196F3),  // Blue
      const Color(0xFFFF9800),  // Orange
      const Color(0xFF9C27B0),  // Purple
      const Color(0xFFE91E63),  // Pink
      const Color(0xFF00BCD4),  // Cyan
      const Color(0xFF3F51B5),  // Indigo
      const Color(0xFFF44336),  // Red
    ];

    final index = name.codeUnits.fold(0, (sum, code) => sum + code) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final bgColor = backgroundColor != null
        ? Color(int.parse(backgroundColor!.replaceFirst('#', '0xFF')))
        : _getColorFromName(name);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
