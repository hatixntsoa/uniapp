import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/timetable_providers.dart';

/// Ticket: Gp9-3 — conflict detection view (room/teacher/group double-booked)
class TimetableConflictsScreen extends ConsumerWidget {
  const TimetableConflictsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conflictsAsync = ref.watch(timetableConflictsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Conflits détectés')),
      body: conflictsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (conflicts) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              const SectionHeader(
                eyebrow: 'Vigilance',
                title: 'Chevauchements détectés',
              ),
              if (conflicts.isEmpty)
                AppCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text('Aucun conflit détecté', style: AppTextStyles.body),
                    ],
                  ),
                )
              else
                for (final c in conflicts) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PillBadge(label: c.type.name, color: AppColors.danger),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${c.slotA.subjectName} (${c.slotA.groupName}) — ${c.slotA.day.toString().split('.').last} ${c.slotA.start.label}',
                          style: AppTextStyles.body,
                        ),
                        Text(
                          '${c.slotB.subjectName} (${c.slotB.groupName}) — ${c.slotB.day.toString().split('.').last} ${c.slotB.start.label}',
                          style: AppTextStyles.body,
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
