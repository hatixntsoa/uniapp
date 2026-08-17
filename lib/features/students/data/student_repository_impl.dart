import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../domain/entities/academic_history_entry.dart';
import '../domain/entities/student_entity.dart';
import '../domain/entities/student_situation.dart';
import '../domain/repositories/student_repository.dart';

/// Ticket: Gp2-1..Gp2-3 — SQLite-backed implementation.
/// Status: wired to local database (lib/core/database/app_database.dart).
/// Interface unchanged — swapping this for a Dio-backed remote repository
/// later is still a one-line change at student_providers.dart.
class SqliteStudentRepository implements StudentRepository {
  Future<Database> get _db => AppDatabase.instance.database;

  StudentEntity _fromRow(Map<String, Object?> row) => StudentEntity(
    id: row['id'] as String,
    fullName: row['fullName'] as String,
    matricule: row['matricule'] as String,
    email: row['email'] as String,
    filiere: row['filiere'] as String,
    niveau: row['niveau'] as String,
    groupName: row['groupName'] as String,
    anneeUniversitaire: row['anneeUniversitaire'] as String,
    photoUrl: row['photoUrl'] as String?,
    isArchived: (row['isArchived'] as int) == 1,
  );

  @override
  Future<List<StudentEntity>> getStudents({
    String? query,
    String? niveau,
    String? groupName,
    bool includeArchived = false,
  }) async {
    final db = await _db;
    final where = <String>[];
    final args = <Object?>[];

    if (!includeArchived) where.add('isArchived = 0');
    if (query != null && query.trim().isNotEmpty) {
      where.add('(fullName LIKE ? OR matricule LIKE ?)');
      args.add('%$query%');
      args.add('%$query%');
    }
    if (niveau != null && niveau.isNotEmpty) {
      where.add('niveau = ?');
      args.add(niveau);
    }
    if (groupName != null && groupName.isNotEmpty) {
      where.add('groupName = ?');
      args.add(groupName);
    }

    final rows = await db.query(
      'students',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args,
      orderBy: 'fullName ASC',
    );
    return rows.map(_fromRow).toList();
  }

  @override
  Future<StudentEntity> createStudent(StudentEntity student) async {
    final db = await _db;
    await db.insert('students', {
      'id': student.id.isEmpty ? const Uuid().v4() : student.id,
      'fullName': student.fullName,
      'matricule': student.matricule,
      'email': student.email,
      'filiere': student.filiere,
      'niveau': student.niveau,
      'groupName': student.groupName,
      'anneeUniversitaire': student.anneeUniversitaire,
      'photoUrl': student.photoUrl,
      'isArchived': student.isArchived ? 1 : 0,
    });
    return student;
  }

  @override
  Future<StudentEntity> updateStudent(StudentEntity student) async {
    final db = await _db;
    await db.update(
      'students',
      {
        'fullName': student.fullName,
        'filiere': student.filiere,
        'niveau': student.niveau,
        'groupName': student.groupName,
        'isArchived': student.isArchived ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [student.id],
    );
    return student;
  }

  @override
  Future<void> archiveStudent(String studentId) async {
    final db = await _db;
    await db.update(
      'students',
      {'isArchived': 1},
      where: 'id = ?',
      whereArgs: [studentId],
    );
  }

  @override
  Future<List<AcademicHistoryEntry>> getAcademicHistory(
    String studentId,
  ) async {
    final db = await _db;
    final rows = await db.query(
      'academic_history',
      where: 'studentId = ?',
      whereArgs: [studentId],
      orderBy: 'date DESC',
    );
    return rows
        .map(
          (r) => AcademicHistoryEntry(
            title: r['title'] as String,
            subtitle: r['subtitle'] as String,
            date: DateTime.parse(r['date'] as String),
            details: (r['details'] as String)
                .split('|')
                .where((e) => e.isNotEmpty)
                .toList(),
          ),
        )
        .toList();
  }

  @override
  Future<StudentSituation> getSituation(String studentId) async {
    final db = await _db;
    final studentRows = await db.query(
      'students',
      where: 'id = ?',
      whereArgs: [studentId],
    );
    final student = _fromRow(studentRows.first);

    // Aggregate real grade data for this student across all exams.
    final gradeRows = await db.rawQuery(
      '''
      SELECT e.subjectName, g.grade, e.coefficient
      FROM exam_grades g
      JOIN exams e ON e.id = g.examId
      WHERE g.studentId = ? AND g.grade IS NOT NULL
    ''',
      [studentId],
    );

    final grades = gradeRows
        .map(
          (r) => GradeSummary(
            subjectName: r['subjectName'] as String,
            grade: r['grade'] as double,
            coefficient: r['coefficient'] as double,
          ),
        )
        .toList();

    final absenceRows = await db.query(
      'exam_grades',
      where: 'studentId = ? AND attendance IN (?, ?)',
      whereArgs: [studentId, 'absent', 'justified'],
    );
    final absenceCount = absenceRows
        .where((r) => r['attendance'] == 'absent')
        .length;
    final justifiedCount = absenceRows
        .where((r) => r['attendance'] == 'justified')
        .length;

    final upcomingRows = await db.query(
      'exams',
      where: 'groupId = (SELECT groupName FROM students WHERE id = ?) OR 1=1',
      whereArgs: [studentId],
    );
    final upcoming = upcomingRows
        .map(
          (r) => (
            date: DateTime.parse(r['date'] as String),
            title: r['title'] as String,
            subjectName: r['subjectName'] as String,
          ),
        )
        .where((e) => e.date.isAfter(DateTime.now()))
        .map(
          (e) => UpcomingExamSummary(
            title: e.title,
            date: e.date,
            subjectName: e.subjectName,
          ),
        )
        .toList();

    return StudentSituation(
      student: student,
      grades: grades,
      absenceCount: absenceCount,
      justifiedAbsenceCount: justifiedCount,
      upcomingExams: upcoming,
      notificationCount: 0,
    );
  }
}
