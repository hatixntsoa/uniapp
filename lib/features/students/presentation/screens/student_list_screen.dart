import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/student_providers.dart';
import 'student_form_screen.dart';
import 'student_profile_screen.dart';

/// Ticket: Gp2-3 — search + filters by level/group
class StudentListScreen extends ConsumerStatefulWidget {
  const StudentListScreen({super.key});

  @override
  ConsumerState<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends ConsumerState<StudentListScreen> {
  final _searchCtrl = TextEditingController();
  String? _niveau;

  static const _niveaux = ['L1', 'L2', 'L3', 'M1', 'M2'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter() {
    ref.read(studentFilterProvider.notifier).state = ref
        .read(studentFilterProvider)
        .copyWith(query: _searchCtrl.text, niveau: _niveau ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Étudiants')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'studentListFab',
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const StudentFormScreen())),
        icon: const Icon(Icons.person_add_alt_outlined),
        label: const Text('Ajouter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              eyebrow: 'Gestion',
              title: 'Répertoire des étudiants',
            ),
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Rechercher par nom ou matricule',
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
                    label: const Text('Tous niveaux'),
                    selected: _niveau == null,
                    onSelected: (_) {
                      setState(() => _niveau = null);
                      _applyFilter();
                    },
                  ),
                  const SizedBox(width: 8),
                  for (final n in _niveaux) ...[
                    ChoiceChip(
                      label: Text(n),
                      selected: _niveau == n,
                      onSelected: (_) {
                        setState(() => _niveau = n);
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
              child: studentsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Une erreur est survenue',
                    style: AppTextStyles.bodyMuted,
                  ),
                ),
                data: (students) {
                  if (students.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun élément à afficher',
                        style: AppTextStyles.bodyMuted,
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: students.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final s = students[i];
                      return AppCard(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => StudentProfileScreen(student: s),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.accentSoft,
                              child: Text(
                                s.fullName.substring(0, 1),
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.fullName,
                                    style: AppTextStyles.cardTitle,
                                  ),
                                  Text(
                                    '${s.matricule} · ${s.niveau} · ${s.groupName}',
                                    style: AppTextStyles.bodyMuted,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.textMuted,
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
