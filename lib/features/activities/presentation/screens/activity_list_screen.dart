import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/media_card.dart';
// import '../../../../core/widgets/section_header.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/activity_providers.dart';
import 'activity_detail_screen.dart';
import 'activity_form_screen.dart';
import 'participation_stats_screen.dart';

/// Ticket: Gp7-4 — student-facing browse; Gp7-1/7-2 create entry point
class ActivityListScreen extends ConsumerWidget {
  const ActivityListScreen({super.key});

  IconData _iconFor(String label) => switch (label) {
    'Conférence' => Icons.mic_outlined,
    'Atelier' => Icons.build_outlined,
    'Sortie' => Icons.directions_walk_outlined,
    'Sport' => Icons.sports_soccer_outlined,
    'Culturel' => Icons.palette_outlined,
    _ => Icons.emoji_events_outlined,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activityListProvider);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activités universitaires'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ParticipationStatsScreen(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'activityListFab',
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const ActivityFormScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Créer'),
      ),
      body: activitiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Une erreur est survenue',
            style: AppTextStyles.bodyMuted,
          ),
        ),
        data: (activities) {
          final published = activities.where((a) => a.isPublished).toList();
          if (published.isEmpty) {
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
            childAspectRatio: 0.62,
            children: [
              for (final a in published)
                MediaCard(
                  eyebrow: a.type.name,
                  title: a.title,
                  description:
                      '${a.location} · ${a.remainingSeats} places restantes',
                  icon: _iconFor(a.type.name),
                  actionLabel: 'Voir',
                  onAction: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ActivityDetailScreen(
                        activity: a,
                        studentId: user?.id ?? 'u-stud-1',
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ActivityDetailScreen(
                        activity: a,
                        studentId: user?.id ?? 'u-stud-1',
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
