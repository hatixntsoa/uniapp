import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/presentation_entity.dart';
import '../../domain/entities/presentation_evaluation.dart';
import '../providers/presentation_providers.dart';

/// Ticket: Gp10-2 — per-student remarks/comments/attendance/support file;
/// distinguish collective vs individual grade
class PresentationEvaluationScreen extends ConsumerWidget {
  const PresentationEvaluationScreen({super.key, required this.presentation});

  final PresentationEntity presentation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final evalAsync = ref.watch(
      presentationEvaluationProvider(presentation.id),
    );

    return Scaffold(
      appBar: AppBar(title: Text(presentation.title)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'presentationEvalFab',
        onPressed: () async {
          await ref
              .read(presentationListProvider.notifier)
              .markCompleted(presentation.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Présentation marquée comme évaluée'),
              ),
            );
          }
        },
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Clôturer'),
      ),
      body: evalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (evaluation) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              if (presentation.mode == PresentationMode.groupe) ...[
                const SectionHeader(
                  eyebrow: 'Note collective',
                  title: 'Évaluation du groupe',
                ),
                AppCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Note collective (sur 20)',
                          style: AppTextStyles.body,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          key: ValueKey(evaluation.collectiveScore),
                          initialValue: evaluation.collectiveScore.toString(),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(labelText: 'Note'),
                          onFieldSubmitted: (val) {
                            final parsed = double.tryParse(val);
                            if (parsed != null) {
                              ref
                                  .read(
                                    presentationEvaluationProvider(
                                      presentation.id,
                                    ).notifier,
                                  )
                                  .updateCollectiveScore(parsed);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
              const SectionHeader(
                eyebrow: 'Détail',
                title: 'Évaluation par participant',
              ),
              for (final m in evaluation.memberEvaluations) ...[
                _MemberEvaluationCard(
                  presentationId: presentation.id,
                  criteria: presentation.criteria,
                  member: m,
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

class _MemberEvaluationCard extends ConsumerStatefulWidget {
  const _MemberEvaluationCard({
    required this.presentationId,
    required this.criteria,
    required this.member,
  });

  final String presentationId;
  final List<GradingCriterion> criteria;
  final MemberEvaluation member;

  @override
  ConsumerState<_MemberEvaluationCard> createState() =>
      _MemberEvaluationCardState();
}

class _MemberEvaluationCardState extends ConsumerState<_MemberEvaluationCard> {
  late TextEditingController _remarksCtrl;

  @override
  void initState() {
    super.initState();
    _remarksCtrl = TextEditingController(text: widget.member.remarks);
  }

  @override
  void dispose() {
    _remarksCtrl.dispose();
    super.dispose();
  }

  void _updateScore(String criterionId, double points) {
    final scores = [
      for (final s in widget.member.individualScores)
        if (s.criterionId == criterionId)
          CriterionScore(criterionId: criterionId, points: points)
        else
          s,
    ];
    ref
        .read(presentationEvaluationProvider(widget.presentationId).notifier)
        .updateMember(widget.member.copyWith(individualScores: scores));
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.member.studentName,
                  style: AppTextStyles.cardTitle,
                ),
              ),
              Switch(
                value:
                    widget.member.attendance == PresentationAttendance.present,
                onChanged: (v) => ref
                    .read(
                      presentationEvaluationProvider(widget.presentationId)
                          .notifier,
                    )
                    .updateMember(
                      widget.member.copyWith(
                        attendance: v
                            ? PresentationAttendance.present
                            : PresentationAttendance.absent,
                      ),
                    ),
              ),
            ],
          ),
          Text(
            widget.member.attendance == PresentationAttendance.present
                ? 'Présent'
                : 'Absent',
            style: AppTextStyles.label,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final c in widget.criteria)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${c.label} (/${c.maxPoints.toInt()})',
                      style: AppTextStyles.bodyMuted,
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: TextFormField(
                      initialValue: widget.member.individualScores
                          .firstWhere(
                            (s) => s.criterionId == c.id,
                            orElse: () =>
                                CriterionScore(criterionId: c.id, points: 0),
                          )
                          .points
                          .toString(),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(isDense: true),
                      onFieldSubmitted: (val) {
                        final parsed = double.tryParse(val);
                        if (parsed != null) _updateScore(c.id, parsed);
                      },
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _remarksCtrl,
            decoration: const InputDecoration(labelText: 'Remarques'),
            maxLines: 2,
            onFieldSubmitted: (val) => ref
                .read(
                  presentationEvaluationProvider(widget.presentationId)
                      .notifier,
                )
                .updateMember(widget.member.copyWith(remarks: val)),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                widget.member.hasSupportFile
                    ? Icons.attach_file
                    : Icons.attach_file_outlined,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                widget.member.hasSupportFile
                    ? 'Support déposé'
                    : 'Aucun support déposé',
                style: AppTextStyles.label,
              ),
              // TODO(Gp10-2): wire actual file upload once a document-storage
              // backend endpoint exists; currently a display-only flag.
            ],
          ),
        ],
      ),
    );
  }
}
