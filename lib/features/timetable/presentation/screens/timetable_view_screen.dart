import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/timetable_slot_entity.dart';
import '../providers/timetable_providers.dart';
import 'timetable_form_screen.dart';
import 'timetable_conflicts_screen.dart';

/// Ticket: Gp9-5 — multi-view consultation (student/teacher/group/room/day)
class TimetableViewScreen extends ConsumerStatefulWidget {
  const TimetableViewScreen({super.key});

  @override
  ConsumerState<TimetableViewScreen> createState() =>
      _TimetableViewScreenState();
}

class _TimetableViewScreenState extends ConsumerState<TimetableViewScreen> {
  Weekday? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final slotsAsync = ref.watch(timetableSlotsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emplois du temps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning_amber_outlined),
            tooltip: 'Conflits',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TimetableConflictsScreen(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const TimetableFormScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(eyebrow: 'Planning', title: 'Vue hebdomadaire'),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ChoiceChip(
                    label: const Text('Tous les jours'),
                    selected: _selectedDay == null,
                    onSelected: (_) {
                      setState(() => _selectedDay = null);
                      ref.read(timetableViewFilterProvider.notifier).state = ref
                          .read(timetableViewFilterProvider)
                          .copyWith(day: null);
                    },
                  ),
                  const SizedBox(width: 8),
                  for (final d in Weekday.values) ...[
                    ChoiceChip(
                      label: Text(d.label),
                      selected: _selectedDay == d,
                      onSelected: (_) {
                        setState(() => _selectedDay = d);
                        ref
                            .read(timetableViewFilterProvider.notifier)
                            .state = ref
                            .read(timetableViewFilterProvider)
                            .copyWith(day: d);
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: slotsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Une erreur est survenue',
                    style: AppTextStyles.bodyMuted,
                  ),
                ),
                data: (slots) {
                  if (slots.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun élément à afficher',
                        style: AppTextStyles.bodyMuted,
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: slots.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final s = slots[i];
                      return AppCard(
                        onTap: () => _showCancelSheet(context, s),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.subjectName,
                                    style: AppTextStyles.cardTitle,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${s.groupName} · ${s.teacherName} · ${s.roomName}',
                                    style: AppTextStyles.bodyMuted,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(s.day.label, style: AppTextStyles.label),
                                Text(
                                  '${s.start.label} - ${s.end.label}',
                                  style: AppTextStyles.label,
                                ),
                              ],
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

  void _showCancelSheet(BuildContext context, TimetableSlotEntity slot) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: ListTile(
          leading: const Icon(Icons.cancel_outlined, color: AppColors.danger),
          title: const Text('Annuler cette séance'),
          onTap: () {
            ref.read(timetableSlotsProvider.notifier).cancelSlot(slot.id);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
