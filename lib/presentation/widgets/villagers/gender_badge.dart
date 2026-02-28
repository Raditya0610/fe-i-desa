import 'package:flutter/material.dart';

class GenderBadge extends StatelessWidget {
  final String jenisKelamin;

  const GenderBadge({
    super.key,
    required this.jenisKelamin,
  });

  @override
  Widget build(BuildContext context) {
    final isLakiLaki = jenisKelamin == 'Laki-laki' || jenisKelamin == 'L';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isLakiLaki ? Colors.blue.shade600 : Colors.pink.shade400,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isLakiLaki ? 'Laki-Laki' : 'Perempuan',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
