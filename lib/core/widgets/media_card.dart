import 'package:flutter/material.dart';

import 'app_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Ticket: core — reusable media/portfolio-grid card (section 3)
/// Used by: activities, presentations, equipment, social_feed posts.
class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    this.icon = Icons.school_outlined,
    this.actionLabel,
    this.onAction,
    this.onTap,
  });

  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 72,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSpacing.cardRadius),
              ),
            ),
            child: Icon(icon, color: AppColors.accent, size: 32),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.cardPadding,
              AppSpacing.sm,
              AppSpacing.cardPadding,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: AppTextStyles.eyebrow,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: AppTextStyles.cardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyMuted,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (actionLabel != null) ...[
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 28,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: AppColors.accent,
                        ),
                        child: Text(actionLabel!),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
