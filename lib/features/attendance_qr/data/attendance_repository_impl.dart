import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';
import '../domain/entities/attendance_record_entity.dart';
import '../domain/entities/attendance_report.dart';
import '../domain/entities/attendance_session_entity.dart';
import '../domain/repositories/attendance_repository.dart';

/// Ticket: Gp2-4/Gp2-5 — SQLite-backed implementation.
/// Status: sessions + records wired to local database. Group rates and
/// absence alerts remain computed fixtures (see TODO) since they need
/// full timetable/group enrollment data not yet in the local schema.
class SqliteAttendanceRepository implements AttendanceRepository {
  Future<Database> get _db => AppDatabase.instance.database;

  AttendanceSessionEntity _sessionFromRow(Map<String, Object?> row) =>
      AttendanceSessionEntity(
        id: row['id'] as String,
        courseName: row['courseName'] as String,
        groupName: row['groupName'] as String,
        teacherName: row['teacherName'] as String,
        startTime: DateTime.parse(row['startTime'] as String),
        state: SessionState.values.byName(row['state'] as String),
      );

  @override
  Future<List<AttendanceSessionEntity>> getSessions() async {
    final db = await _db;
    final rows = await db.query(
      'attendance_sessions',
      orderBy: 'startTime DESC',
    );
    return rows.map(_sessionFromRow).toList();
  }

  @override
  Future<AttendanceSessionEntity> createSession(
    AttendanceSessionEntity session,
  ) async {
    final db = await _db;
    await db.insert('attendance_sessions', {
      'id': session.id,
      'courseName': session.courseName,
      'groupName': session.groupName,
      'teacherName': session.teacherName,
      'startTime': session.startTime.toIso8601String(),
      'state': session.state.name,
    });
    return session;
  }

  @override
  Future<void> setSessionState(String sessionId, SessionState state) async {
    final db = await _db;
    await db.update(
      'attendance_sessions',
      {'state': state.name},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  @override
  Future<List<AttendanceRecordEntity>> getRecords(String sessionId) async {
    final db = await _db;
    final rows = await db.query(
      'attendance_records',
      where: 'sessionId = ?',
      whereArgs: [sessionId],
    );
    return rows
        .map(
          (r) => AttendanceRecordEntity(
            studentId: r['studentId'] as String,
            studentName: r['studentName'] as String,
            status: CheckInStatus.values.byName(r['status'] as String),
            checkedInAt: r['checkedInAt'] != null
                ? DateTime.parse(r['checkedInAt'] as String)
                : null,
          ),
        )
        .toList();
  }

  @override
  Future<void> checkIn(
    String sessionId,
    String studentId, {
    CheckInStatus? forcedStatus,
  }) async {
    final db = await _db;
    await db.update(
      'attendance_records',
      {
        'status': (forcedStatus ?? CheckInStatus.present).name,
        'checkedInAt': DateTime.now().toIso8601String(),
      },
      where: 'sessionId = ? AND studentId = ?',
      whereArgs: [sessionId, studentId],
    );
  }

  @override
  Future<void> updateStatus(
    String sessionId,
    String studentId,
    CheckInStatus status,
  ) async {
    final db = await _db;
    await db.update(
      'attendance_records',
      {'status': status.name},
      where: 'sessionId = ? AND studentId = ?',
      whereArgs: [sessionId, studentId],
    );
  }

  @override
  Future<AttendanceRecordEntity> checkInByQrPayload(
    String sessionId,
    String qrPayload,
  ) async {
    final db = await _db;
    // Payload is the student's matricule; resolve it against the students table.
    final studentRows = await db.query(
      'students',
      where: 'matricule = ?',
      whereArgs: [qrPayload.trim()],
    );
    if (studentRows.isEmpty) {
      throw StateError('QR code non reconnu');
    }
    final studentId = studentRows.first['id'] as String;
    final studentName = studentRows.first['fullName'] as String;
    final now = DateTime.now().toIso8601String();

    await db.insert('attendance_records', {
      'sessionId': sessionId,
      'studentId': studentId,
      'studentName': studentName,
      'status': CheckInStatus.present.name,
      'checkedInAt': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    return AttendanceRecordEntity(
      studentId: studentId,
      studentName: studentName,
      status: CheckInStatus.present,
      checkedInAt: DateTime.parse(now),
    );
  }

  @override
  Future<List<GroupAttendanceRate>> getRatesByGroup() async {
    final db = await _db;
    // Real aggregate: present count / total records, grouped by session's group.
    final rows = await db.rawQuery('''
      SELECT s.groupName as groupName,
             SUM(CASE WHEN r.status = 'present' THEN 1 ELSE 0 END) as presentCount,
             COUNT(*) as totalCount
      FROM attendance_records r
      JOIN attendance_sessions s ON s.id = r.sessionId
      GROUP BY s.groupName
    ''');
    return rows
        .map(
          (r) => GroupAttendanceRate(
            groupName: r['groupName'] as String,
            presentCount: r['presentCount'] as int,
            totalCount: r['totalCount'] as int,
          ),
        )
        .toList();
  }

  @override
  Future<List<AbsenceAlert>> getRepeatedAbsenceAlerts({
    int threshold = 3,
  }) async {
    final db = await _db;
    final rows = await db.rawQuery(
      '''
      SELECT studentId, studentName, COUNT(*) as absenceCount
      FROM attendance_records
      WHERE status = 'absent'
      GROUP BY studentId
      HAVING absenceCount >= ?
    ''',
      [threshold],
    );
    return rows
        .map(
          (r) => AbsenceAlert(
            studentId: r['studentId'] as String,
            studentName: r['studentName'] as String,
            consecutiveAbsences: r['absenceCount'] as int,
          ),
        )
        .toList();
  }
}
