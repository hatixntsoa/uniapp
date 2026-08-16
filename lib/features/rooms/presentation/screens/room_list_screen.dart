import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/room_entity.dart';
import '../providers/room_providers.dart';
import 'room_form_screen.dart';
import 'room_detail_screen.dart';

/// Ticket: Gp8-5 — search; entry point for the module
class RoomListScreen extends ConsumerStatefulWidget {
  const RoomListScreen({super.key});

  @override
  ConsumerState<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends ConsumerState<RoomListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter() {
    ref.read(roomFilterProvider.notifier).state = ref
        .read(roomFilterProvider)
        .copyWith(query: _searchCtrl.text);
  }

  Color _statusColor(RoomStatus s) => switch (s) {
    RoomStatus.disponible => AppColors.success,
    RoomStatus.occupee => AppColors.warning,
    RoomStatus.indisponible => AppColors.danger,
    RoomStatus.maintenance => AppColors.textMuted,
  };

  @override
  Widget build(BuildContext context) {
    final roomsAsync = ref.watch(roomListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Salles')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const RoomFormScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              eyebrow: 'Infrastructure',
              title: 'Salles & espaces',
            ),
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Rechercher une salle',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _applyFilter(),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: roomsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Une erreur est survenue',
                    style: AppTextStyles.bodyMuted,
                  ),
                ),
                data: (rooms) {
                  if (rooms.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun élément à afficher',
                        style: AppTextStyles.bodyMuted,
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: rooms.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final r = rooms[i];
                      return AppCard(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RoomDetailScreen(room: r),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.name, style: AppTextStyles.cardTitle),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${r.type.label} · ${r.location} · ${r.capacity} places',
                                    style: AppTextStyles.bodyMuted,
                                  ),
                                ],
                              ),
                            ),
                            PillBadge(
                              label: r.status.label,
                              color: _statusColor(r.status),
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
