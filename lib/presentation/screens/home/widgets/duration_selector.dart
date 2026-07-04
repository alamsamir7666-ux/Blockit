import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DurationSelector extends StatelessWidget {
  final int selectedMinutes;
  final ValueChanged<int> onChanged;

  const DurationSelector({
    super.key,
    required this.selectedMinutes,
    required this.onChanged,
  });

  static const _durations = [15, 30, 45, 60, 90, 120];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Duration',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _durations.map((minutes) {
            final isSelected = minutes == selectedMinutes;
            return GestureDetector(
              onTap: () => onChanged(minutes),
              child: Container(
                width: (MediaQuery.of(context).size.width - 96) / 3,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.2)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _formatDuration(minutes),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      minutes >= 60 ? '${minutes ~/ 60}h' : 'min',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatDuration(int minutes) {
    if (minutes >= 60) {
      return '${minutes ~/ 60}:${(minutes % 60).toString().padLeft(2, '0')}';
    }
    return minutes.toString();
  }
}
