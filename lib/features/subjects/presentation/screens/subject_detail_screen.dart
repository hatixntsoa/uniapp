import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/subject_entity.dart';
import '../providers/subject_providers.dart';

/// Ticket: Gp5-2 — link to evaluations/grades/timetable/groups
class SubjectDetailScreen extends ConsumerWidget {
  const SubjectDetailScreen({super.key, required this.subject});

  final SubjectEntity subject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linksAsync = ref.watch(subjectLinkSummaryProvider(subject.id));

    return Scaffold(
      appBar: AppBar(title: Text(subject.name)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject.name, style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(
                  '${subject.code} · ${subject.niveau} · ${subject.filiere}',
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: 4),
                Text(
                  'Coef. ${subject.coefficient} · ${subject.volumeHoraire}h · ${subject.semestre}',
                  style: AppTextStyles.label,
                ),
                const SizedBox(height: 4),
                Text(
                  'Enseignant : ${subject.teacherName}',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            eyebrow: 'Aperçu',
            title: 'Liens avec les autres modules',
          ),
          linksAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (links) {
              return AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row('Évaluations', '${links.evaluationCount}'),
                    _row('Moyenne', '${links.averageGrade}/20'),
                    _row('Créneaux EDT', '${links.timetableSlotCount}'),
                    _row('Groupes liés', links.linkedGroups.join(', ')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.body)),
        Text(value, style: AppTextStyles.bodyMuted),
      ],
    ),
  );
}
