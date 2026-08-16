import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/models/user_role.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_spacing.dart';
import 'core/theme/app_text_styles.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

/// Ticket: section 6 — role-based bottom nav shell.
/// Tab set changes based on the logged-in role from core/services/auth_service.dart.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  List<({IconData icon, String label})> _tabsFor(UserRole role) {
    switch (role) {
      case UserRole.etudiant:
        return const [
          (icon: Icons.home_outlined, label: 'Accueil'),
          (icon: Icons.menu_book_outlined, label: 'Cours'),
          (icon: Icons.fact_check_outlined, label: 'Examens'),
          (icon: Icons.person_outline, label: 'Profil'),
        ];
      case UserRole.enseignant:
        return const [
          (icon: Icons.home_outlined, label: 'Accueil'),
          (icon: Icons.groups_outlined, label: 'Classes'),
          (icon: Icons.fact_check_outlined, label: 'Examens'),
          (icon: Icons.person_outline, label: 'Profil'),
        ];
      case UserRole.admin:
        return const [
          (icon: Icons.dashboard_outlined, label: 'Tableau de bord'),
          (icon: Icons.people_outline, label: 'Étudiants'),
          (icon: Icons.badge_outlined, label: 'Enseignants'),
          (icon: Icons.meeting_room_outlined, label: 'Salles'),
          (icon: Icons.person_outline, label: 'Profil'),
        ];
      case UserRole.technicien:
        return const [
          (icon: Icons.home_outlined, label: 'Accueil'),
          (icon: Icons.build_outlined, label: 'Matériels'),
          (icon: Icons.meeting_room_outlined, label: 'Salles'),
          (icon: Icons.person_outline, label: 'Profil'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox.shrink();

    final tabs = _tabsFor(user.role);
    final safeIndex = _index < tabs.length ? _index : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UniApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // TODO(section 6): wire global notification center once
              // flutter_local_notifications channel is set up per module.
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.accentSoft,
              child: Text(
                user.fullName.substring(0, 1),
                style: AppTextStyles.label.copyWith(color: AppColors.accent),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Espace ${user.role.label} — ${tabs[safeIndex].label}\n'
          '(écran de module à venir)',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMuted,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (final t in tabs)
            NavigationDestination(icon: Icon(t.icon), label: t.label),
        ],
      ),
    );
  }
}
