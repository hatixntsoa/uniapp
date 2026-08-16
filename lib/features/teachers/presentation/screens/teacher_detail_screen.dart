import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/teacher_entity.dart';
import '../../domain/entities/teacher_schedule_entry.dart';
import '../providers/teacher_providers.dart';

/// Ticket: Gp4-3 — schedule view (EDT) with sessions + absences
/// Ticket: Gp4-5 — teacher <-> subject linking display
class TeacherDetailScreen extends ConsumerWidget {
  const TeacherDetailScreen({super.key, required this.teacher});

  final TeacherEntity teacher;

  Color _statusColor(ScheduleEntryStatus s) => switch (s) {
    ScheduleEntryStatus.planned => AppColors.accent,
    ScheduleEntryStatus.done => AppColors.success,
    ScheduleEntryStatus.absent => AppColors.danger,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleAsync = ref.watch(teacherScheduleProvider(teacher.id));
    final df = DateFormat('EEE dd/MM · HH:mm', 'fr_FR');

    return Scaffold(
      appBar: AppBar(title: Text(teacher.fullName)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teacher.fullName, style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(teacher.email, style: AppTextStyles.bodyMuted),
                const SizedBox(height: 4),
                Text(teacher.department, style: AppTextStyles.label),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            eyebrow: 'Affectations',
            title: 'Matières & groupes',
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${teacher.subjectIds.length} matière(s) assignée(s)',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final g in teacher.assignedGroups)
                      Chip(label: Text(g), side: BorderSide.none),
                    for (final l in teacher.assignedLevels)
                      Chip(label: Text(l), side: BorderSide.none),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(eyebrow: 'Planning', title: 'Emploi du temps'),
          scheduleAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (schedule) {
              if (schedule.isEmpty) {
                return Text(
                  'Aucun élément à afficher',
                  style: AppTextStyles.bodyMuted,
                );
              }
              return Column(
                children: [
                  for (final s in schedule) ...[
                    AppCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.subjectName,
                                  style: AppTextStyles.cardTitle,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${s.groupName} · ${s.roomName}',
                                  style: AppTextStyles.bodyMuted,
                                ),
                                Text(
                                  df.format(s.startTime),
                                  style: AppTextStyles.label,
                                ),
                              ],
                            ),
                          ),
                          PillBadge(
                            label: s.status.label,
                            color: _statusColor(s.status),
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
        ],
      ),
    );
  }
}
