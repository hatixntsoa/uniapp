import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/timeline_tile.dart';
import '../providers/presentation_providers.dart';

/// Ticket: Gp10-3 — history (plan/track/evaluate/history)
class PresentationHistoryScreen extends ConsumerWidget {
  const PresentationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(presentationHistoryProvider);
    final df = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Historique des présentations')),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (history) {
          if (history.isEmpty) {
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
                eyebrow: 'Suivi',
                title: 'Parcours des soutenances',
              ),
              AppCard(
                child: Column(
                  children: [
                    for (var i = 0; i < history.length; i++)
                      AppTimelineTile(
                        title: history[i].title,
                        subtitle:
                            history[i].status.toString().split('.').last +
                            (history[i].finalScore != null
                                ? ' · Note: ${history[i].finalScore!.toStringAsFixed(1)}/20'
                                : ''),
                        dateLabel: df.format(history[i].date),
                        isLast: i == history.length - 1,
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
