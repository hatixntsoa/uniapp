import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../attendance_qr/presentation/screens/qr_scan_screen.dart';
import '../../domain/entities/equipment_entity.dart';
import '../providers/equipment_providers.dart';
import 'equipment_form_screen.dart';
import 'equipment_detail_screen.dart';
import 'equipment_alerts_screen.dart';

/// Ticket: Gp6-2 — search/filter by category/state, entry point for the module
/// Ticket: Gp6-1 — QR-based lookup (reuses module 3's QrScanScreen)
class EquipmentListScreen extends ConsumerStatefulWidget {
  const EquipmentListScreen({super.key});

  @override
  ConsumerState<EquipmentListScreen> createState() =>
      _EquipmentListScreenState();
}

class _EquipmentListScreenState extends ConsumerState<EquipmentListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter() {
    ref.read(equipmentFilterProvider.notifier).state = ref
        .read(equipmentFilterProvider)
        .copyWith(query: _searchCtrl.text);
  }

  Color _stateColor(EquipmentState s) => switch (s) {
    EquipmentState.fonctionnel => AppColors.success,
    EquipmentState.enPanne => AppColors.danger,
    EquipmentState.maintenance => AppColors.warning,
    EquipmentState.horsService => AppColors.textMuted,
  };

  Future<void> _scanLookup() async {
    final payload = await Navigator.of(context)
        .push<String>(MaterialPageRoute(builder: (_) => const QrScanScreen()));
    if (payload == null || !mounted) return;
    final result = await ref
        .read(equipmentListProvider.notifier)
        .lookupByQr(payload);
    if (!mounted) return;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun matériel trouvé pour ce code')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EquipmentDetailScreen(equipment: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final equipmentAsync = ref.watch(equipmentListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matériels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning_amber_outlined),
            tooltip: 'Alertes',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const EquipmentAlertsScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'scan',
            onPressed: _scanLookup,
            child: const Icon(Icons.qr_code_scanner_outlined),
          ),
          const SizedBox(height: AppSpacing.sm),
          FloatingActionButton.extended(
            heroTag: 'add',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const EquipmentFormScreen()),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Ajouter'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              eyebrow: 'Inventaire',
              title: 'Matériels & équipements',
            ),
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Rechercher par nom ou code',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _applyFilter(),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: equipmentAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Une erreur est survenue',
                    style: AppTextStyles.bodyMuted,
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun élément à afficher',
                        style: AppTextStyles.bodyMuted,
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final e = items[i];
                      return AppCard(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EquipmentDetailScreen(equipment: e),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.name, style: AppTextStyles.cardTitle),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${e.inventoryCode} · ${e.category.label} · ${e.roomName}',
                                    style: AppTextStyles.bodyMuted,
                                  ),
                                ],
                              ),
                            ),
                            PillBadge(
                              label: e.state.label,
                              color: _stateColor(e.state),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
