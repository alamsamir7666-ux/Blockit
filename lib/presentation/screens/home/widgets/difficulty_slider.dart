import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DifficultySlider extends StatelessWidget {
  final int difficulty;
  final ValueChanged<int> onChanged;

  const DifficultySlider({
    super.key,
    required this.difficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Difficulty',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getDifficultyColor().withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getDifficultyLabel(),
                style: TextStyle(
                  color: _getDifficultyColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            activeTrackColor: _getDifficultyColor(),
            inactiveTrackColor: AppColors.surfaceLight,
            thumbColor: _getDifficultyColor(),
            overlayColor: _getDifficultyColor().withOpacity(0.2),
          ),
          child: Slider(
            value: difficulty.toDouble(),
            min: 1,
            max: 3,
            divisions: 2,
            onChanged: (value) => onChanged(value.toInt()),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Easy', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            Text('Medium', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            Text('Hard', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Color _getDifficultyColor() {
    switch (difficulty) {
      case 1:
        return AppColors.success;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.error;
      default:
        return AppColors.success;
    }
  }

  String _getDifficultyLabel() {
    switch (difficulty) {
      case 1:
        return 'Easy - 1 Parachute';
      case 2:
        return 'Medium - No Parachutes';
      case 3:
        return 'Hard - No Escape';
      default:
        return 'Easy';
    }
  }
}
