import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/presentation_entity.dart';
import '../providers/presentation_providers.dart';
import 'presentation_form_screen.dart';
import 'presentation_evaluation_screen.dart';
import 'presentation_history_screen.dart';

/// Ticket: Gp10-3 — plan/track entry point
class PresentationListScreen extends ConsumerWidget {
  const PresentationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presentationsAsync = ref.watch(presentationListProvider);
    final df = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Présentations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PresentationHistoryScreen(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'presentationListFab',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PresentationFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Planifier'),
      ),
      body: presentationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (presentations) {
          if (presentations.isEmpty) {
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
                eyebrow: 'Planification',
                title: 'Présentations & soutenances',
              ),
              for (final p in presentations) ...[
                AppCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          PresentationEvaluationScreen(presentation: p),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title, style: AppTextStyles.cardTitle),
                            const SizedBox(height: 4),
                            Text(
                              '${p.mode.label} · ${p.subjectName} · ${p.members.length} participant(s)',
                              style: AppTextStyles.bodyMuted,
                            ),
                            Text(df.format(p.date), style: AppTextStyles.label),
                          ],
                        ),
                      ),
                      PillBadge(
                        label: p.isCompleted ? 'Évaluée' : 'Planifiée',
                        color: p.isCompleted
                            ? AppColors.success
                            : AppColors.accent,
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
