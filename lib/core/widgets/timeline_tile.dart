import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Ticket: core — numbered vertical timeline tile (section 3)
/// Used for: student academic history, teacher EDT, attendance/presentation history.
class AppTimelineTile extends StatelessWidget {
  const AppTimelineTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    this.icon = Icons.circle,
    this.isLast = false,
    this.details = const [],
  });

  final String title;
  final String subtitle;
  final String dateLabel;
  final IconData icon;
  final bool isLast;
  final List<String> details;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: AppColors.accent),
              ),
              if (!isLast)
                Expanded(child: Container(width: 1, color: AppColors.hairline)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(title, style: AppTextStyles.cardTitle),
                      ),
                      Text(dateLabel, style: AppTextStyles.label),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodyMuted),
                  for (final d in details) ...[
                    const SizedBox(height: 4),
                    Text('•  $d', style: AppTextStyles.bodyMuted),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
