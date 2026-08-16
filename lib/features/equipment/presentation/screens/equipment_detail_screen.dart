import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/timeline_tile.dart';
import '../../domain/entities/equipment_entity.dart';
import '../../domain/entities/equipment_movement.dart';
import '../../domain/entities/incident_report.dart';
import '../providers/equipment_providers.dart';

/// Ticket: Gp5-5 — movement history, quick incident report
class EquipmentDetailScreen extends ConsumerWidget {
  const EquipmentDetailScreen({super.key, required this.equipment});

  final EquipmentEntity equipment;

  Color _stateColor(EquipmentState s) => switch (s) {
    EquipmentState.fonctionnel => AppColors.success,
    EquipmentState.enPanne => AppColors.danger,
    EquipmentState.maintenance => AppColors.warning,
    EquipmentState.horsService => AppColors.textMuted,
  };

  void _reportIncident(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Signaler un incident'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Description'),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text.trim().isEmpty) return;
              ref
                  .read(equipmentMovementsProvider(equipment.id).notifier)
                  .reportIncident(
                    IncidentReport(
                      id: const Uuid().v4(),
                      equipmentId: equipment.id,
                      description: ctrl.text.trim(),
                      reportedAt: DateTime.now(),
                      reporterName: 'Utilisateur courant',
                    ),
                  );
              Navigator.of(context).pop();
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movementsAsync = ref.watch(equipmentMovementsProvider(equipment.id));
    final df = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: Text(equipment.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _reportIncident(context, ref),
        icon: const Icon(Icons.report_problem_outlined),
        label: const Text('Signaler'),
        backgroundColor: AppColors.danger,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        equipment.name,
                        style: AppTextStyles.cardTitle,
                      ),
                    ),
                    PillBadge(
                      label: equipment.state.label,
                      color: _stateColor(equipment.state),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${equipment.category.label} · ${equipment.roomName}',
                  style: AppTextStyles.bodyMuted,
                ),
                Text(
                  'Responsable : ${equipment.responsibleName}',
                  style: AppTextStyles.label,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            eyebrow: 'Identification',
            title: 'Code QR matériel',
          ),
          AppCard(
            child: Center(
              child: QrImageView(
                data: equipment.inventoryCode,
                size: 140,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            eyebrow: 'Suivi',
            title: 'Historique des mouvements',
          ),
          movementsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (movements) {
              if (movements.isEmpty) {
                return Text(
                  'Aucun élément à afficher',
                  style: AppTextStyles.bodyMuted,
                );
              }
              return AppCard(
                child: Column(
                  children: [
                    for (var i = 0; i < movements.length; i++)
                      AppTimelineTile(
                        title: movements[i].type.label,
                        subtitle: movements[i].note ?? movements[i].actorName,
                        dateLabel: df.format(movements[i].date),
                        isLast: i == movements.length - 1,
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
