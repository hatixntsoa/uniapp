import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../domain/entities/exam_entity.dart';
import '../../domain/entities/grade_entity.dart';
import '../providers/exam_providers.dart';

/// Ticket: Gp1-2 — student roster: attendance check-in, grade entry, publish
class ExamRosterScreen extends ConsumerWidget {
  const ExamRosterScreen({super.key, required this.exam});

  final ExamEntity exam;

  Color _statusColor(ExamAttendanceStatus s) => switch (s) {
    ExamAttendanceStatus.present => AppColors.statusPresent,
    ExamAttendanceStatus.absent => AppColors.statusAbsent,
    ExamAttendanceStatus.late => AppColors.statusLate,
    ExamAttendanceStatus.justified => AppColors.statusJustified,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterAsync = ref.watch(examRosterProvider(exam.id));

    return Scaffold(
      appBar: AppBar(title: Text(exam.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await ref.read(examListProvider.notifier).publishExam(exam.id);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Évaluation publiée')));
          }
        },
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Publier'),
      ),
      body: rosterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (roster) {
          if (roster.isEmpty) {
            return Center(
              child: Text(
                'Aucun élément à afficher',
                style: AppTextStyles.bodyMuted,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: roster.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, i) {
              final g = roster[i];
              return AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g.studentName, style: AppTextStyles.cardTitle),
                          const SizedBox(height: 6),
                          PillBadge(
                            label: g.attendance.label,
                            color: _statusColor(g.attendance),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        initialValue: g.grade?.toString() ?? '',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(labelText: 'Note'),
                        onFieldSubmitted: (val) {
                          final parsed = double.tryParse(val);
                          if (parsed == null) return;
                          ref
                              .read(examRosterProvider(exam.id).notifier)
                              .updateGrade(g.copyWith(grade: parsed));
                        },
                      ),
                    ),
                    PopupMenuButton<ExamAttendanceStatus>(
                      onSelected: (status) {
                        ref
                            .read(examRosterProvider(exam.id).notifier)
                            .updateGrade(g.copyWith(attendance: status));
                      },
                      itemBuilder: (context) => ExamAttendanceStatus.values
                          .map(
                            (s) =>
                                PopupMenuItem(value: s, child: Text(s.label)),
                          )
                          .toList(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
