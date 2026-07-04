import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ParachuteBadge extends StatelessWidget {
  final int count;
  final VoidCallback? onTap;

  const ParachuteBadge({
    super.key,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.warning.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🪂', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: const TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
