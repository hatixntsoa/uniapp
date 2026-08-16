import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../domain/entities/attendance_record_entity.dart';
import '../../domain/entities/attendance_session_entity.dart';
import '../providers/attendance_providers.dart';
import 'qr_scan_screen.dart';

/// Ticket: Gp2-4 — manual + QR check-in, statuses (présent/absent/retard/justifié)
class SessionCheckinScreen extends ConsumerWidget {
  const SessionCheckinScreen({super.key, required this.session});

  final AttendanceSessionEntity session;

  Color _statusColor(CheckInStatus s) => switch (s) {
        CheckInStatus.present => AppColors.statusPresent,
        CheckInStatus.absent => AppColors.statusAbsent,
        CheckInStatus.late => AppColors.statusLate,
        CheckInStatus.justified => AppColors.statusJustified,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(sessionRecordsProvider(session.id));

    return Scaffold(
      appBar: AppBar(title: Text(session.courseName)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: session.state != SessionState.open
            ? null
            : () async {
                final payload = await Navigator.of(context).push<String>(
                  MaterialPageRoute(builder: (_) => const QrScanScreen()),
                );
                if (payload == null || !context.mounted) return;
                final name = await ref
                    .read(sessionRecordsProvider(session.id).notifier)
                    .checkInWithQr(payload);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      name != null
                          ? 'Présence enregistrée : $name'
                          : 'QR code non reconnu',
                    ),
                  ),
                );
              },
        icon: const Icon(Icons.qr_code_scanner_outlined),
        label: const Text('Scanner'),
      ),
      body: recordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
        ),
        data: (records) {
          if (records.isEmpty) {
            return Center(
              child: Text('Aucun élément à afficher', style: AppTextStyles.bodyMuted),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) {
              final r = records[i];
              return AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(r.studentName, style: AppTextStyles.cardTitle),
                    ),
                    PopupMenuButton<CheckInStatus>(
                      onSelected: (status) => ref
                          .read(sessionRecordsProvider(session.id).notifier)
                          .setStatus(r.studentId, status),
                      itemBuilder: (context) => CheckInStatus.values
                          .map((s) => PopupMenuItem(value: s, child: Text(s.label)))
                          .toList(),
                      child: PillBadge(
                        label: r.status.label,
                        color: _statusColor(r.status),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}