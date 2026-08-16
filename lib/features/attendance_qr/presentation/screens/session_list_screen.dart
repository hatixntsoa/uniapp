import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/attendance_session_entity.dart';
import '../providers/attendance_providers.dart';
import 'session_checkin_screen.dart';
import 'attendance_reports_screen.dart';

/// Ticket: Gp2-4 — sessions list: open/close check-in window
class SessionListScreen extends ConsumerWidget {
  const SessionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionListProvider);
    final df = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Présence par QR code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AttendanceReportsScreen()),
            ),
          ),
        ],
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
        ),
        data: (sessions) {
          if (sessions.isEmpty) {
            return Center(
              child: Text('Aucun élément à afficher', style: AppTextStyles.bodyMuted),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              const SectionHeader(eyebrow: 'Séances', title: 'Sessions de présence'),
              for (final session in sessions) ...[
                AppCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SessionCheckinScreen(session: session),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(session.courseName, style: AppTextStyles.cardTitle),
                            const SizedBox(height: 4),
                            Text(
                              '${session.groupName} · ${session.teacherName}',
                              style: AppTextStyles.bodyMuted,
                            ),
                            Text(df.format(session.startTime), style: AppTextStyles.label),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          PillBadge(
                            label: session.state == SessionState.open
                                ? 'Séance ouverte'
                                : 'Fermée',
                            color: session.state == SessionState.open
                                ? AppColors.success
                                : AppColors.textMuted,
                          ),
                          const SizedBox(height: 6),
                          Switch(
                            value: session.state == SessionState.open,
                            onChanged: (v) => ref
                                .read(sessionListProvider.notifier)
                                .toggleSession(
                                  session.id,
                                  v ? SessionState.open : SessionState.closed,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        },
      ),
    );
  }
}