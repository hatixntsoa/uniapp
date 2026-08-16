import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/attendance_providers.dart';

/// Ticket: Gp2-5 — reports (by course/group rate) + alerts on repeated absences
class AttendanceReportsScreen extends ConsumerWidget {
  const AttendanceReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratesAsync = ref.watch(groupRatesProvider);
    final alertsAsync = ref.watch(absenceAlertsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rapports de présence')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const SectionHeader(
            eyebrow: 'Statistiques',
            title: 'Taux de présence par groupe',
          ),
          ratesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (rates) {
              if (rates.isEmpty) {
                return Text('Aucun élément à afficher',
                    style: AppTextStyles.bodyMuted);
              }
              return AppCard(
                child: SizedBox(
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final i = value.toInt();
                              if (i < 0 || i >= rates.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  rates[i].groupName,
                                  style: AppTextStyles.label,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: [
                        for (var i = 0; i < rates.length; i++)
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: rates[i].rate * 100,
                                color: AppColors.accent,
                                width: 22,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(
            eyebrow: 'Vigilance',
            title: 'Alertes absences répétées',
          ),
          alertsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Text('Une erreur est survenue', style: AppTextStyles.bodyMuted),
            data: (alerts) {
              if (alerts.isEmpty) {
                return Text('Aucun élément à afficher',
                    style: AppTextStyles.bodyMuted);
              }
              return Column(
                children: [
                  for (final a in alerts) ...[
                    AppCard(
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: AppColors.danger),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a.studentName, style: AppTextStyles.cardTitle),
                                Text(
                                  '${a.consecutiveAbsences} absences consécutives',
                                  style: AppTextStyles.bodyMuted,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}