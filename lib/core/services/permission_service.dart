import '../models/user_role.dart';

/// Ticket: Gp3-3 — permission gating per screen/action.
/// Central place mapping role -> allowed actions, so feature screens
/// never hardcode role checks inline.
enum AppPermission {
  manageStudents,
  manageTeachers,
  manageAdmin,
  manageRooms,
  manageEquipment,
  manageTimetable,
  createExam,
  gradeExam,
  viewOwnGrades,
  manageAttendanceSession,
  checkInAttendance,
  moderateFeed,
  manageActivities,
}

class PermissionService {
  PermissionService._();

  static const Map<UserRole, Set<AppPermission>> _matrix = {
    UserRole.admin: {
      AppPermission.manageStudents,
      AppPermission.manageTeachers,
      AppPermission.manageAdmin,
      AppPermission.manageRooms,
      AppPermission.manageEquipment,
      AppPermission.manageTimetable,
      AppPermission.createExam,
      AppPermission.gradeExam,
      AppPermission.manageAttendanceSession,
      AppPermission.moderateFeed,
      AppPermission.manageActivities,
    },
    UserRole.enseignant: {
      AppPermission.createExam,
      AppPermission.gradeExam,
      AppPermission.manageAttendanceSession,
      AppPermission.checkInAttendance,
      AppPermission.manageActivities,
    },
    UserRole.etudiant: {AppPermission.viewOwnGrades},
    UserRole.technicien: {
      AppPermission.manageEquipment,
      AppPermission.manageRooms,
    },
  };

  static bool can(UserRole role, AppPermission permission) {
    return _matrix[role]?.contains(permission) ?? false;
  }
}
