import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../domain/entities/activity_entity.dart';
import '../providers/activity_providers.dart';

/// Ticket: Gp7-4 — register/unregister + participation view
class ActivityDetailScreen extends ConsumerWidget {
  const ActivityDetailScreen({
    super.key,
    required this.activity,
    required this.studentId,
  });

  final ActivityEntity activity;
  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final df = DateFormat('dd/MM/yyyy à HH:mm');
    final registrationsAsync = ref.watch(myRegistrationsProvider(studentId));

    return Scaffold(
      appBar: AppBar(title: Text(activity.title)),
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
                      child: Text(
                        activity.title,
                        style: AppTextStyles.cardTitle,
                      ),
                    ),
                    PillBadge(
                      label: activity.isFull ? 'Complet' : 'Disponible',
                      color: activity.isFull
                          ? AppColors.danger
                          : AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${activity.type.label} · ${activity.location}',
                  style: AppTextStyles.bodyMuted,
                ),
                Text(df.format(activity.date), style: AppTextStyles.label),
                const SizedBox(height: AppSpacing.md),
                Text(activity.description, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Responsable : ${activity.responsibleName}',
                  style: AppTextStyles.bodyMuted,
                ),
                Text(
                  '${activity.registeredCount}/${activity.totalSeats} inscrits',
                  style: AppTextStyles.bodyMuted,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          registrationsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, _) => const SizedBox.shrink(),
            data: (regs) {
              final isRegistered = regs.any((r) => r.activityId == activity.id);
              return ElevatedButton(
                onPressed: (!isRegistered && activity.isFull)
                    ? null
                    : () async {
                        if (isRegistered) {
                          await ref
                              .read(activityListProvider.notifier)
                              .unregister(activity.id, studentId);
                        } else {
                          await ref
                              .read(activityListProvider.notifier)
                              .register(activity.id, studentId);
                        }
                      },
                style: isRegistered
                    ? ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                      )
                    : null,
                child: Text(
                  isRegistered
                      ? 'Se désinscrire'
                      : (activity.isFull ? 'Complet' : 'S\'inscrire'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
