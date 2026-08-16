import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/admin_providers.dart';
import 'academic_structure_screen.dart';

/// Ticket: Gp3-2 — admin dashboard with key indicators
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            tooltip: 'Structure académique',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AcademicStructureScreen(),
              ),
            ),
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (stats) {
          final tiles = [
            (
              label: 'Étudiants',
              value: '${stats.studentCount}',
              icon: Icons.people_outline,
            ),
            (
              label: 'Enseignants',
              value: '${stats.teacherCount}',
              icon: Icons.badge_outlined,
            ),
            (
              label: 'Cours',
              value: '${stats.courseCount}',
              icon: Icons.menu_book_outlined,
            ),
            (
              label: 'Taux d\'absence',
              value: '${(stats.absenceRate * 100).toStringAsFixed(0)}%',
              icon: Icons.event_busy_outlined,
            ),
            (
              label: 'Évaluations',
              value: '${stats.evaluationCount}',
              icon: Icons.fact_check_outlined,
            ),
            (
              label: 'Matériels',
              value: '${stats.equipmentCount}',
              icon: Icons.build_outlined,
            ),
          ];

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              const SectionHeader(
                eyebrow: 'Vue d\'ensemble',
                title: 'Indicateurs clés',
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 1.5,
                children: [
                  for (final t in tiles)
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(t.icon, color: AppColors.accent),
                          const Spacer(),
                          Text(
                            t.value,
                            style: AppTextStyles.heroNumber.copyWith(
                              fontSize: 26,
                            ),
                          ),
                          Text(t.label, style: AppTextStyles.bodyMuted),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(
                eyebrow: 'Vigilance',
                title: 'Alertes système',
              ),
              AppCard(
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        '${stats.alertCount} alertes actives (absences répétées, matériels en panne, salles indisponibles)',
                        style: AppTextStyles.body,
                      ),
                    ),
                    PillBadge(
                      label: '${stats.alertCount}',
                      color: AppColors.warning,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
