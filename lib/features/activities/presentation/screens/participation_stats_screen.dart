import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fl_chart/fl_chart.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/activity_providers.dart';

/// Ticket: Gp7-5 — admin participation stats
class ParticipationStatsScreen extends ConsumerWidget {
  const ParticipationStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(participationStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques de participation')),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (stats) {
          if (stats.isEmpty) {
            return Center(
              child: Text(
                'Aucun élément à afficher',
                style: AppTextStyles.bodyMuted,
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              const SectionHeader(
                eyebrow: 'Vue d\'ensemble',
                title: 'Taux de remplissage par activité',
              ),
              for (final s in stats) ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.activityTitle, style: AppTextStyles.cardTitle),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: s.fillRate,
                          minHeight: 8,
                          backgroundColor: AppColors.accentSoft,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${s.registeredCount}/${s.totalSeats} places (${(s.fillRate * 100).toStringAsFixed(0)}%)',
                        style: AppTextStyles.bodyMuted,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          );
        },
      ),
    );
  }
}
