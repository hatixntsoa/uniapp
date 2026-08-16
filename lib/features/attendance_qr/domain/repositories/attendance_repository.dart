import '../entities/attendance_record_entity.dart';
import '../entities/attendance_report.dart';
import '../entities/attendance_session_entity.dart';

/// Ticket: Gp2-4 / Gp2-5 — repository contract
abstract class AttendanceRepository {
  Future<List<AttendanceSessionEntity>> getSessions();
  Future<AttendanceSessionEntity> createSession(
    AttendanceSessionEntity session,
  );
  Future<void> setSessionState(String sessionId, SessionState state);

  Future<List<AttendanceRecordEntity>> getRecords(String sessionId);
  Future<void> checkIn(
    String sessionId,
    String studentId, {
    CheckInStatus? forcedStatus,
  });
  Future<void> updateStatus(
    String sessionId,
    String studentId,
    CheckInStatus status,
  );

  /// Gp2-4: QR scan resolves a raw QR payload (student matricule) to a check-in.
  Future<AttendanceRecordEntity> checkInByQrPayload(
    String sessionId,
    String qrPayload,
  );

  Future<List<GroupAttendanceRate>> getRatesByGroup();
  Future<List<AbsenceAlert>> getRepeatedAbsenceAlerts({int threshold = 3});
}
