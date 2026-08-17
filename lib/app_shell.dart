import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/models/user_role.dart';
// import 'core/theme/app_colors.dart';
// import 'core/theme/app_spacing.dart';
// import 'core/theme/app_text_styles.dart';
import 'features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/equipment/presentation/screens/equipment_list_screen.dart';
import 'features/exams/presentation/screens/exam_list_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/rooms/presentation/screens/room_list_screen.dart';
import 'features/students/presentation/screens/student_list_screen.dart';
import 'features/subjects/presentation/screens/subject_list_screen.dart';
import 'features/teachers/presentation/screens/teacher_list_screen.dart';

/// Ticket: section 6 — role-based bottom nav shell.
/// Each tab now renders a real feature screen instead of a placeholder —
/// this is what makes content actually appear after login for every role.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 0;

  List<({IconData icon, String label, Widget screen})> _tabsFor(UserRole role) {
    switch (role) {
      case UserRole.etudiant:
        return [
          (
            icon: Icons.home_outlined,
            label: 'Accueil',
            screen: const HomeScreen(),
          ),
          (
            icon: Icons.menu_book_outlined,
            label: 'Cours',
            screen: const SubjectListScreen(),
          ),
          (
            icon: Icons.fact_check_outlined,
            label: 'Examens',
            screen: const ExamListScreen(),
          ),
          (
            icon: Icons.person_outline,
            label: 'Profil',
            screen: const ProfileScreen(),
          ),
        ];
      case UserRole.enseignant:
        return [
          (
            icon: Icons.home_outlined,
            label: 'Accueil',
            screen: const HomeScreen(),
          ),
          (
            icon: Icons.groups_outlined,
            label: 'Classes',
            screen: const StudentListScreen(),
          ),
          (
            icon: Icons.fact_check_outlined,
            label: 'Examens',
            screen: const ExamListScreen(),
          ),
          (
            icon: Icons.person_outline,
            label: 'Profil',
            screen: const ProfileScreen(),
          ),
        ];
      case UserRole.admin:
        return [
          (
            icon: Icons.dashboard_outlined,
            label: 'Tableau de bord',
            screen: const AdminDashboardScreen(),
          ),
          (
            icon: Icons.people_outline,
            label: 'Étudiants',
            screen: const StudentListScreen(),
          ),
          (
            icon: Icons.badge_outlined,
            label: 'Enseignants',
            screen: const TeacherListScreen(),
          ),
          (
            icon: Icons.meeting_room_outlined,
            label: 'Salles',
            screen: const RoomListScreen(),
          ),
          (
            icon: Icons.person_outline,
            label: 'Profil',
            screen: const ProfileScreen(),
          ),
        ];
      case UserRole.technicien:
        return [
          (
            icon: Icons.home_outlined,
            label: 'Accueil',
            screen: const HomeScreen(),
          ),
          (
            icon: Icons.build_outlined,
            label: 'Matériels',
            screen: const EquipmentListScreen(),
          ),
          (
            icon: Icons.meeting_room_outlined,
            label: 'Salles',
            screen: const RoomListScreen(),
          ),
          (
            icon: Icons.person_outline,
            label: 'Profil',
            screen: const ProfileScreen(),
          ),
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
      body: IndexedStack(
        index: safeIndex,
        children: [for (final t in tabs) t.screen],
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
