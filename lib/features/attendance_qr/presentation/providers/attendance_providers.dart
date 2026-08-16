import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/attendance_repository_impl.dart';
import '../../domain/entities/attendance_record_entity.dart';
import '../../domain/entities/attendance_report.dart';
import '../../domain/entities/attendance_session_entity.dart';
import '../../domain/repositories/attendance_repository.dart';

/// Ticket: Gp2-4 / Gp2-5 — providers
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return MockAttendanceRepository();
});

final sessionListProvider =
    AsyncNotifierProvider<SessionListNotifier, List<AttendanceSessionEntity>>(
      SessionListNotifier.new,
    );

class SessionListNotifier extends AsyncNotifier<List<AttendanceSessionEntity>> {
  @override
  Future<List<AttendanceSessionEntity>> build() {
    return ref.read(attendanceRepositoryProvider).getSessions();
  }

  Future<void> toggleSession(String id, SessionState newState) async {
    await ref.read(attendanceRepositoryProvider).setSessionState(id, newState);
    ref.invalidateSelf();
  }
}

final sessionRecordsProvider =
    AsyncNotifierProvider.family<
      SessionRecordsNotifier,
      List<AttendanceRecordEntity>,
      String
    >(SessionRecordsNotifier.new);

class SessionRecordsNotifier
    extends FamilyAsyncNotifier<List<AttendanceRecordEntity>, String> {
  @override
  Future<List<AttendanceRecordEntity>> build(String sessionId) {
    return ref.read(attendanceRepositoryProvider).getRecords(sessionId);
  }

  Future<void> setStatus(String studentId, CheckInStatus status) async {
    await ref
        .read(attendanceRepositoryProvider)
        .updateStatus(arg, studentId, status);
    ref.invalidateSelf();
  }

  /// Gp2-4: manual + QR check-in share this entry point.
  Future<String?> checkInWithQr(String qrPayload) async {
    try {
      final rec = await ref
          .read(attendanceRepositoryProvider)
          .checkInByQrPayload(arg, qrPayload);
      ref.invalidateSelf();
      return rec.studentName;
    } catch (_) {
      return null;
    }
  }
}

final groupRatesProvider = FutureProvider<List<GroupAttendanceRate>>((ref) {
  return ref.read(attendanceRepositoryProvider).getRatesByGroup();
});

final absenceAlertsProvider = FutureProvider<List<AbsenceAlert>>((ref) {
  return ref.read(attendanceRepositoryProvider).getRepeatedAbsenceAlerts();
});
