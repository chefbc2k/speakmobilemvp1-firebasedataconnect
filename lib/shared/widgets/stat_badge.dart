import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_styles.dart';

class StatBadge extends StatelessWidget {
  final String value;
  final String? label;
  final Color backgroundColor;
  final Color textColor;

  const StatBadge({
    super.key,
    required this.value,
    this.label,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.numberMedium.copyWith(
              color: textColor,
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 2),
            Text(
              label!,
              style: AppTextStyles.labelSmall.copyWith(
                color: textColor.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
