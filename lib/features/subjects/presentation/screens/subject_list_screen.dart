import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/subject_providers.dart';
import 'subject_form_screen.dart';
import 'subject_detail_screen.dart';

/// Ticket: Gp5-3 — browse/filter by level, filière, teacher
class SubjectListScreen extends ConsumerStatefulWidget {
  const SubjectListScreen({super.key});

  @override
  ConsumerState<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends ConsumerState<SubjectListScreen> {
  final _searchCtrl = TextEditingController();
  String? _niveau;

  static const _niveaux = ['L1', 'L2', 'L3', 'M1', 'M2'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter() {
    ref.read(subjectFilterProvider.notifier).state = ref
        .read(subjectFilterProvider)
        .copyWith(query: _searchCtrl.text, niveau: _niveau ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final subjectsAsync = ref.watch(subjectListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Matières')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SubjectFormScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Créer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              eyebrow: 'Gestion',
              title: 'Catalogue des matières',
            ),
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                hintText: 'Rechercher par nom ou code',
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
              child: subjectsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Une erreur est survenue',
                    style: AppTextStyles.bodyMuted,
                  ),
                ),
                data: (subjects) {
                  if (subjects.isEmpty) {
                    return Center(
                      child: Text(
                        'Aucun élément à afficher',
                        style: AppTextStyles.bodyMuted,
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: subjects.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final s = subjects[i];
                      return AppCard(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SubjectDetailScreen(subject: s),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.accentSoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                s.code.substring(0, 2),
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
                                  Text(s.name, style: AppTextStyles.cardTitle),
                                  Text(
                                    '${s.code} · ${s.niveau} · Coef. ${s.coefficient}',
                                    style: AppTextStyles.bodyMuted,
                                  ),
                                  Text(
                                    s.teacherName,
                                    style: AppTextStyles.label,
                                  ),
                                ],
                              ),
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
