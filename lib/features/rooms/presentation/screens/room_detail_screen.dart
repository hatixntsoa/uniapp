import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/room_entity.dart';
import '../providers/room_providers.dart';
import 'room_reservation_screen.dart';

/// Ticket: Gp8-4 — availability/state/occupation history
/// Ticket: Gp8-6 — statuses control (indisponible/occupée/maintenance)
class RoomDetailScreen extends ConsumerWidget {
  const RoomDetailScreen({super.key, required this.room});

  final RoomEntity room;

  Color _statusColor(RoomStatus s) => switch (s) {
    RoomStatus.disponible => AppColors.success,
    RoomStatus.occupee => AppColors.warning,
    RoomStatus.indisponible => AppColors.danger,
    RoomStatus.maintenance => AppColors.textMuted,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationsAsync = ref.watch(roomReservationsProvider(room.id));
    final df = DateFormat('EEE dd/MM · HH:mm', 'fr_FR');

    return Scaffold(
      appBar: AppBar(title: Text(room.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RoomReservationScreen(room: room)),
        ),
        icon: const Icon(Icons.event_available_outlined),
        label: const Text('Réserver'),
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
                      child: Text(room.name, style: AppTextStyles.cardTitle),
                    ),
                    PopupMenuButton<RoomStatus>(
                      onSelected: (s) => ref
                          .read(roomListProvider.notifier)
                          .setStatus(room.id, s),
                      itemBuilder: (context) => RoomStatus.values
                          .map(
                            (s) =>
                                PopupMenuItem(value: s, child: Text(s.label)),
                          )
                          .toList(),
                      child: PillBadge(
                        label: room.status.label,
                        color: _statusColor(room.status),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${room.type.label} · ${room.location} · ${room.capacity} places',
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final eq in room.equipmentList)
                      Chip(label: Text(eq), side: BorderSide.none),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            eyebrow: 'Planning',
            title: 'Historique d\'occupation',
          ),
          reservationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (reservations) {
              if (reservations.isEmpty) {
                return Text(
                  'Aucun élément à afficher',
                  style: AppTextStyles.bodyMuted,
                );
              }
              return Column(
                children: [
                  for (final r in reservations) ...[
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.title, style: AppTextStyles.cardTitle),
                          const SizedBox(height: 4),
                          Text(r.groupName, style: AppTextStyles.bodyMuted),
                          Text(
                            '${df.format(r.startTime)} → ${DateFormat('HH:mm').format(r.endTime)}',
                            style: AppTextStyles.label,
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
