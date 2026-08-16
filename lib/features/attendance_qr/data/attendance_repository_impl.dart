import '../domain/entities/attendance_record_entity.dart';
import '../domain/entities/attendance_report.dart';
import '../domain/entities/attendance_session_entity.dart';
import '../domain/repositories/attendance_repository.dart';

/// Ticket: Gp2-4 / Gp2-5 — mock in-memory implementation.
/// Status: mocked. Replace with Dio calls to /attendance/sessions,
/// /attendance/sessions/:id/records, /attendance/reports/* once backend
/// is available. Interface (AttendanceRepository) stays identical.
class MockAttendanceRepository implements AttendanceRepository {
  final List<AttendanceSessionEntity> _sessions = [
    AttendanceSessionEntity(
      id: 'sess-1',
      courseName: 'Algorithmique',
      groupName: 'Groupe A',
      teacherName: 'Karim Haddad',
      startTime: DateTime.now(),
      state: SessionState.open,
    ),
    AttendanceSessionEntity(
      id: 'sess-2',
      courseName: 'Bases de données',
      groupName: 'Groupe A',
      teacherName: 'Karim Haddad',
      startTime: DateTime.now().subtract(const Duration(days: 2)),
      state: SessionState.closed,
    ),
  ];

  final Map<String, List<AttendanceRecordEntity>> _records = {
    'sess-1': [
      const AttendanceRecordEntity(
        studentId: 'u-stud-1',
        studentName: 'Lina Meziane',
        status: CheckInStatus.absent,
      ),
      const AttendanceRecordEntity(
        studentId: 'u-stud-2',
        studentName: 'Yanis Kaci',
        status: CheckInStatus.absent,
      ),
      const AttendanceRecordEntity(
        studentId: 'u-stud-3',
        studentName: 'Amel Cherif',
        status: CheckInStatus.absent,
      ),
    ],
    'sess-2': [
      const AttendanceRecordEntity(
        studentId: 'u-stud-1',
        studentName: 'Lina Meziane',
        status: CheckInStatus.present,
      ),
      const AttendanceRecordEntity(
        studentId: 'u-stud-2',
        studentName: 'Yanis Kaci',
        status: CheckInStatus.absent,
      ),
      const AttendanceRecordEntity(
        studentId: 'u-stud-3',
        studentName: 'Amel Cherif',
        status: CheckInStatus.justified,
      ),
    ],
  };

  // Matricule -> (studentId, studentName), mirrors features/students fixtures.
  static const _matriculeIndex = {
    '20231045': ('u-stud-1', 'Lina Meziane'),
    '20231046': ('u-stud-2', 'Yanis Kaci'),
    '20231047': ('u-stud-3', 'Amel Cherif'),
  };

  @override
  Future<List<AttendanceSessionEntity>> getSessions() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_sessions);
  }

  @override
  Future<AttendanceSessionEntity> createSession(
    AttendanceSessionEntity session,
  ) async {
    _sessions.add(session);
    _records.putIfAbsent(session.id, () => []);
    return session;
  }

  @override
  Future<void> setSessionState(String sessionId, SessionState state) async {
    final i = _sessions.indexWhere((s) => s.id == sessionId);
    if (i != -1) _sessions[i] = _sessions[i].copyWith(state: state);
  }

  @override
  Future<List<AttendanceRecordEntity>> getRecords(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_records[sessionId] ?? const []);
  }

  @override
  Future<void> checkIn(
    String sessionId,
    String studentId, {
    CheckInStatus? forcedStatus,
  }) async {
    final list = _records.putIfAbsent(sessionId, () => []);
    final i = list.indexWhere((r) => r.studentId == studentId);
    if (i != -1) {
      list[i] = list[i].copyWith(
        status: forcedStatus ?? CheckInStatus.present,
        checkedInAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> updateStatus(
    String sessionId,
    String studentId,
    CheckInStatus status,
  ) async {
    final list = _records.putIfAbsent(sessionId, () => []);
    final i = list.indexWhere((r) => r.studentId == studentId);
    if (i != -1) list[i] = list[i].copyWith(status: status);
  }

  @override
  Future<AttendanceRecordEntity> checkInByQrPayload(
    String sessionId,
    String qrPayload,
  ) async {
    final match = _matriculeIndex[qrPayload.trim()];
    if (match == null) {
      throw StateError('QR code non reconnu');
    }
    final (studentId, studentName) = match;
    final list = _records.putIfAbsent(sessionId, () => []);
    final i = list.indexWhere((r) => r.studentId == studentId);
    final updated = AttendanceRecordEntity(
      studentId: studentId,
      studentName: studentName,
      status: CheckInStatus.present,
      checkedInAt: DateTime.now(),
    );
    if (i != -1) {
      list[i] = updated;
    } else {
      list.add(updated);
    }
    return updated;
  }

  @override
  Future<List<GroupAttendanceRate>> getRatesByGroup() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      GroupAttendanceRate(
        groupName: 'Groupe A',
        presentCount: 27,
        totalCount: 30,
      ),
      GroupAttendanceRate(
        groupName: 'Groupe B',
        presentCount: 22,
        totalCount: 28,
      ),
      GroupAttendanceRate(
        groupName: 'Groupe C',
        presentCount: 18,
        totalCount: 25,
      ),
    ];
  }

  @override
  Future<List<AbsenceAlert>> getRepeatedAbsenceAlerts({
    int threshold = 3,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      AbsenceAlert(
        studentId: 'u-stud-2',
        studentName: 'Yanis Kaci',
        consecutiveAbsences: 4,
      ),
    ];
  }
}
