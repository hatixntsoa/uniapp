import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/media_card.dart';
// import '../../../../core/widgets/section_header.dart';
import '../providers/social_feed_providers.dart';

/// Ticket: Gp6-4 — class/club/activity groups
class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  IconData _iconFor(String kindLabel) => switch (kindLabel) {
    'Classe' => Icons.school_outlined,
    'Club' => Icons.groups_outlined,
    _ => Icons.event_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Groupes')),
      body: groupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (groups) {
          if (groups.isEmpty) {
            return Center(
              child: Text(
                'Aucun élément à afficher',
                style: AppTextStyles.bodyMuted,
              ),
            );
          }
          return GridView.count(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.78,
            children: [
              for (final g in groups)
                MediaCard(
                  eyebrow: g.kind.toString().split('.').last,
                  title: g.name,
                  description: '${g.memberCount} membres · ${g.description}',
                  icon: _iconFor(g.kind.toString().split('.').last),
                  actionLabel: g.isJoined ? 'Quitter' : 'Rejoindre',
                  onAction: () =>
                      ref.read(groupListProvider.notifier).toggleJoin(g.id),
                ),
            ],
          );
        },
      ),
    );
  }
}
