import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/user_role.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/media_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../activities/presentation/screens/activity_list_screen.dart';
import '../../../attendance_qr/presentation/screens/session_list_screen.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../equipment/presentation/screens/equipment_list_screen.dart';
import '../../../presentations/presentation/screens/presentation_list_screen.dart';
import '../../../rooms/presentation/screens/room_list_screen.dart';
import '../../../social_feed/presentation/screens/feed_screen.dart';
import '../../../subjects/presentation/screens/subject_list_screen.dart';
import '../../../timetable/presentation/screens/timetable_view_screen.dart';

/// Ticket: section 6 — role-based home / quick-access hub.
/// Surfaces every module not already reachable from the bottom nav tabs,
/// so no feature screen from modules 1–13 is ever unreachable after login.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox.shrink();

    final items = _itemsFor(user.role);

    return Scaffold(
      appBar: AppBar(title: Text('Bonjour, ${user.fullName.split(' ').first}')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          const SectionHeader(eyebrow: 'Aujourd\'hui', title: 'Accès rapide'),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.85,
            children: [
              for (final item in items)
                MediaCard(
                  eyebrow: item.eyebrow,
                  title: item.title,
                  description: item.description,
                  icon: item.icon,
                  actionLabel: 'Ouvrir',
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => item.builder())),
                  onAction: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => item.builder())),
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<_HomeItem> _itemsFor(UserRole role) {
    final common = [
      _HomeItem(
        eyebrow: 'Communauté',
        title: 'Réseau social',
        description: 'Actualités, groupes, messagerie',
        icon: Icons.groups_outlined,
        builder: () => const FeedScreen(),
      ),
      _HomeItem(
        eyebrow: 'Planning',
        title: 'Emplois du temps',
        description: 'Vue hebdomadaire, conflits',
        icon: Icons.calendar_month_outlined,
        builder: () => const TimetableViewScreen(),
      ),
      _HomeItem(
        eyebrow: 'Campus',
        title: 'Activités',
        description: 'Conférences, ateliers, sport',
        icon: Icons.event_outlined,
        builder: () => const ActivityListScreen(),
      ),
    ];

    switch (role) {
      case UserRole.etudiant:
        return [
          _HomeItem(
            eyebrow: 'Présence',
            title: 'Sessions QR',
            description: 'Historique de présence',
            icon: Icons.qr_code_scanner_outlined,
            builder: () => const SessionListScreen(),
          ),
          _HomeItem(
            eyebrow: 'Évaluation',
            title: 'Présentations',
            description: 'Soutenances et historique',
            icon: Icons.slideshow_outlined,
            builder: () => const PresentationListScreen(),
          ),
          ...common,
        ];
      case UserRole.enseignant:
        return [
          _HomeItem(
            eyebrow: 'Présence',
            title: 'Sessions QR',
            description: 'Ouvrir/fermer, check-in',
            icon: Icons.qr_code_scanner_outlined,
            builder: () => const SessionListScreen(),
          ),
          _HomeItem(
            eyebrow: 'Programme',
            title: 'Matières',
            description: 'Catalogue et affectations',
            icon: Icons.menu_book_outlined,
            builder: () => const SubjectListScreen(),
          ),
          _HomeItem(
            eyebrow: 'Évaluation',
            title: 'Présentations',
            description: 'Planifier et évaluer',
            icon: Icons.slideshow_outlined,
            builder: () => const PresentationListScreen(),
          ),
          ...common,
        ];
      case UserRole.admin:
        return [
          _HomeItem(
            eyebrow: 'Présence',
            title: 'Sessions QR',
            description: 'Suivi et rapports',
            icon: Icons.qr_code_scanner_outlined,
            builder: () => const SessionListScreen(),
          ),
          _HomeItem(
            eyebrow: 'Programme',
            title: 'Matières',
            description: 'Catalogue complet',
            icon: Icons.menu_book_outlined,
            builder: () => const SubjectListScreen(),
          ),
          _HomeItem(
            eyebrow: 'Inventaire',
            title: 'Matériels',
            description: 'Équipements et alertes',
            icon: Icons.build_outlined,
            builder: () => const EquipmentListScreen(),
          ),
          _HomeItem(
            eyebrow: 'Évaluation',
            title: 'Présentations',
            description: 'Suivi des soutenances',
            icon: Icons.slideshow_outlined,
            builder: () => const PresentationListScreen(),
          ),
          ...common,
        ];
      case UserRole.technicien:
        return [
          _HomeItem(
            eyebrow: 'Inventaire',
            title: 'Matériels',
            description: 'Équipements et alertes',
            icon: Icons.build_outlined,
            builder: () => const EquipmentListScreen(),
          ),
          _HomeItem(
            eyebrow: 'Infrastructure',
            title: 'Salles',
            description: 'États et réservations',
            icon: Icons.meeting_room_outlined,
            builder: () => const RoomListScreen(),
          ),
          ...common,
        ];
    }
  }
}

class _HomeItem {
  const _HomeItem({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.icon,
    required this.builder,
  });

  final String eyebrow;
  final String title;
  final String description;
  final IconData icon;
  final Widget Function() builder;
}
