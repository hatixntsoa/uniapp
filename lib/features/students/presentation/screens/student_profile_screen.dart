import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/timeline_tile.dart';
import '../../domain/entities/student_entity.dart';
import '../providers/student_providers.dart';

/// Ticket: Gp2-2 — full profile: photo, QR code, attendance history, academic history
class StudentProfileScreen extends ConsumerWidget {
  const StudentProfileScreen({super.key, required this.student});

  final StudentEntity student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(studentHistoryProvider(student.id));
    final df = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: Text(student.fullName)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.accentSoft,
                  child: Text(
                    student.fullName.substring(0, 1),
                    style: AppTextStyles.heroNumber.copyWith(
                      fontSize: 24,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.fullName, style: AppTextStyles.cardTitle),
                      const SizedBox(height: 4),
                      Text(
                        '${student.filiere} · ${student.niveau} · ${student.groupName}',
                        style: AppTextStyles.bodyMuted,
                      ),
                      Text(student.email, style: AppTextStyles.label),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            eyebrow: 'Identification',
            title: 'Code QR étudiant',
          ),
          AppCard(
            child: Center(
              child: QrImageView(
                data: student.matricule,
                size: 160,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            eyebrow: 'Parcours',
            title: 'Historique académique',
          ),
          historyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (history) {
              if (history.isEmpty) {
                return Text(
                  'Aucun élément à afficher',
                  style: AppTextStyles.bodyMuted,
                );
              }
              return AppCard(
                child: Column(
                  children: [
                    for (var i = 0; i < history.length; i++)
                      AppTimelineTile(
                        title: history[i].title,
                        subtitle: history[i].subtitle,
                        dateLabel: df.format(history[i].date),
                        details: history[i].details,
                        isLast: i == history.length - 1,
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
