import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/student_providers.dart';

/// Ticket: Gp2-3 — global situation view (grades, absences, upcoming exams, notifications)
class StudentSituationScreen extends ConsumerWidget {
  const StudentSituationScreen({super.key, required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final situationAsync = ref.watch(studentSituationProvider(studentId));

    return Scaffold(
      appBar: AppBar(title: const Text('Situation globale')),
      body: situationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (s) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              const SectionHeader(
                eyebrow: 'Vue d\'ensemble',
                title: 'Ma situation',
              ),
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${s.absenceCount}',
                            style: AppTextStyles.heroNumber,
                          ),
                          Text('Absences', style: AppTextStyles.bodyMuted),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${s.notificationCount}',
                            style: AppTextStyles.heroNumber,
                          ),
                          Text('Notifications', style: AppTextStyles.bodyMuted),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(eyebrow: 'Résultats', title: 'Mes notes'),
              AppCard(
                child: Column(
                  children: [
                    for (final g in s.grades)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                g.subjectName,
                                style: AppTextStyles.body,
                              ),
                            ),
                            Text(
                              '${g.grade}/20 (coef. ${g.coefficient})',
                              style: AppTextStyles.bodyMuted,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(
                eyebrow: 'À venir',
                title: 'Prochains examens',
              ),
              for (final ex in s.upcomingExams) ...[
                AppCard(
                  child: Row(
                    children: [
                      const Icon(Icons.event_outlined, color: AppColors.accent),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ex.title, style: AppTextStyles.cardTitle),
                            Text(
                              ex.subjectName,
                              style: AppTextStyles.bodyMuted,
                            ),
                          ],
                        ),
                      ),
                      PillBadge(
                        label: '${ex.date.day}/${ex.date.month}',
                        color: AppColors.accent,
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
