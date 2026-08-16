import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/equipment_providers.dart';
import 'equipment_detail_screen.dart';

/// Ticket: Gp6-2 — "frequently failing equipment" alerts
class EquipmentAlertsScreen extends ConsumerWidget {
  const EquipmentAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failingAsync = ref.watch(frequentlyFailingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Alertes matériels')),
      body: failingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (items) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              const SectionHeader(
                eyebrow: 'Vigilance',
                title: 'Matériels en panne fréquente',
              ),
              if (items.isEmpty)
                Text('Aucun élément à afficher', style: AppTextStyles.bodyMuted)
              else
                for (final e in items) ...[
                  AppCard(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EquipmentDetailScreen(equipment: e),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.danger,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.name, style: AppTextStyles.cardTitle),
                              Text(
                                '${e.failureCount} pannes signalées',
                                style: AppTextStyles.bodyMuted,
                              ),
                            ],
                          ),
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
