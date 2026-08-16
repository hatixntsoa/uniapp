import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/admin_providers.dart';

/// Ticket: Gp3-1 — manage academic years, semesters, departments, filières, levels, groups, classes
class AcademicStructureScreen extends ConsumerWidget {
  const AcademicStructureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final years = ref.watch(academicYearsProvider);
    final semesters = ref.watch(semestersProvider);
    final departments = ref.watch(departmentsProvider);
    final filieres = ref.watch(filieresProvider);
    final levels = ref.watch(levelsProvider);
    final groups = ref.watch(groupsProvider);
    final classes = ref.watch(classesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Structure académique')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const SectionHeader(
            eyebrow: 'Calendrier',
            title: 'Années universitaires',
          ),
          years.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (list) => AppCard(
              child: Column(
                children: [
                  for (final y in list)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(y.label),
                      trailing: y.isActive
                          ? Text('Active', style: AppTextStyles.label)
                          : null,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(eyebrow: 'Calendrier', title: 'Semestres'),
          semesters.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (list) => AppCard(
              child: Column(
                children: [
                  for (final s in list)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.label),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(
            eyebrow: 'Organisation',
            title: 'Départements',
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddDialog(
                context,
                title: 'Nouveau département',
                onSubmit: (name) =>
                    ref.read(departmentsProvider.notifier).add(name),
              ),
            ),
          ),
          departments.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (list) => AppCard(
              child: Column(
                children: [
                  for (final d in list)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(d.name),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(eyebrow: 'Organisation', title: 'Filières'),
          filieres.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (list) => AppCard(
              child: Column(
                children: [
                  for (final f in list)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(f.name),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(eyebrow: 'Organisation', title: 'Niveaux'),
          levels.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (list) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final l in list)
                  Chip(label: Text(l.label), side: BorderSide.none),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(
            eyebrow: 'Organisation',
            title: 'Groupes',
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddDialog(
                context,
                title: 'Nouveau groupe',
                onSubmit: (name) => ref
                    .read(groupsProvider.notifier)
                    .add(name, 'lvl-2', 'fil-1'),
              ),
            ),
          ),
          groups.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (list) => AppCard(
              child: Column(
                children: [
                  for (final g in list)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(g.name),
                      trailing: Text(
                        '${g.studentCount} étudiants',
                        style: AppTextStyles.label,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(eyebrow: 'Organisation', title: 'Classes'),
          classes.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (list) => AppCard(
              child: Column(
                children: [
                  for (final c in list)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(c.name),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(
    BuildContext context, {
    required String title,
    required void Function(String) onSubmit,
  }) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Nom'),
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
              onSubmit(ctrl.text.trim());
              Navigator.of(context).pop();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
