import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/teacher_entity.dart';
import '../providers/teacher_providers.dart';
import 'teacher_form_screen.dart';
import 'teacher_detail_screen.dart';

/// Ticket: Gp4-4 — search/filter by department; entry point for the module
class TeacherListScreen extends ConsumerStatefulWidget {
  const TeacherListScreen({super.key});

  @override
  ConsumerState<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends ConsumerState<TeacherListScreen> {
  final _searchCtrl = TextEditingController();
  String? _department;

  static const _departments = ['Informatique', 'Mathématiques'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter() {
    ref.read(teacherFilterProvider.notifier).state = ref
        .read(teacherFilterProvider)
        .copyWith(query: _searchCtrl.text, department: _department ?? '');
  }

  Color _statusColor(TeacherStatus s) => switch (s) {
        TeacherStatus.actif => AppColors.success,
        TeacherStatus.conge => AppColors.warning,
        TeacherStatus.retraite => AppColors.textMuted,
      };

  @override
  Widget build(BuildContext context) {
    final teachersAsync = ref.watch(teacherListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Enseignants')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TeacherFormScreen()),
        ),
        icon: const Icon(Icons.person_add_alt_outlined),
        label: const Text('Ajouter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(eyebrow: 'Gestion', title: 'Corps enseignant'),
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Rechercher par nom',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _applyFilter(),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ChoiceChip(
                    label: const Text('Tous départements'),
                    selected: _department == null,
                    onSelected: (_) {
                      setState(() => _department = null);
                      _applyFilter();
                    },
                  ),
                  const SizedBox(width: 8),
                  for (final d in _departments) ...[
                    ChoiceChip(
                      label: Text(d),
                      selected: _department == d,
                      onSelected: (_) {
                        setState(() => _department = d);
                        _applyFilter();
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: teachersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text('Une erreur est survenue',
                      style: AppTextStyles.bodyMuted),
                ),
                data: (teachers) {
                  if (teachers.isEmpty) {
                    return Center(
                      child: Text('Aucun élément à afficher',
                          style: AppTextStyles.bodyMuted),
                    );
                  }
                  return ListView.separated(
                    itemCount: teachers.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final t = teachers[i];
                      return AppCard(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TeacherDetailScreen(teacher: t),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.accentSoft,
                              child: Text(
                                t.fullName.substring(0, 1),
                                style: AppTextStyles.label
                                    .copyWith(color: AppColors.accent),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.fullName, style: AppTextStyles.cardTitle),
                                  Text(t.department, style: AppTextStyles.bodyMuted),
                                ],
                              ),
                            ),
                            PillBadge(
                              label: t.status.label,
                              color: _statusColor(t.status),
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