import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/exam_entity.dart';
import '../providers/exam_providers.dart';
import 'exam_form_screen.dart';
import 'exam_roster_screen.dart';

/// Ticket: Gp1-1 / Gp1-4 — list of evaluations with create entry point
class ExamListScreen extends ConsumerWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examsAsync = ref.watch(examListProvider);
    final df = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Examens & Évaluations')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const ExamFormScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Créer'),
      ),
      body: examsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (exams) {
          if (exams.isEmpty) {
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
                eyebrow: 'Aujourd\'hui',
                title: 'Vos prochains examens',
              ),
              for (final exam in exams) ...[
                AppCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ExamRosterScreen(exam: exam),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              exam.title,
                              style: AppTextStyles.cardTitle,
                            ),
                          ),
                          PillBadge(
                            label: exam.isPublished ? 'Publié' : 'Brouillon',
                            color: exam.isPublished
                                ? AppColors.success
                                : AppColors.textMuted,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${exam.type.label} · ${exam.subjectName} · ${exam.groupName}',
                        style: AppTextStyles.bodyMuted,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${df.format(exam.date)} · ${exam.durationMinutes} min · '
                        'Coef. ${exam.coefficient} · Barème /${exam.bareme.toInt()}',
                        style: AppTextStyles.label,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        },
      ),
    );
  }
}
