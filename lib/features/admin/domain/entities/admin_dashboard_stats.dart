/// Ticket: Gp3-2 — admin dashboard key indicators
class AdminDashboardStats {
  const AdminDashboardStats({
    required this.studentCount,
    required this.teacherCount,
    required this.courseCount,
    required this.absenceRate,
    required this.evaluationCount,
    required this.equipmentCount,
    required this.alertCount,
  });

  final int studentCount;
  final int teacherCount;
  final int courseCount;
  final double absenceRate;
  final int evaluationCount;
  final int equipmentCount;
  final int alertCount;
}
