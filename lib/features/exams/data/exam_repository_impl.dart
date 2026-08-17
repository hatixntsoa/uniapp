import 'package:sqflite/sqflite.dart';
import '../../../core/database/app_database.dart';
import '../domain/entities/exam_entity.dart';
import '../domain/entities/grade_entity.dart';
import '../domain/entities/quiz_entity.dart';
import '../domain/repositories/exam_repository.dart';
import 'ai_grading_service.dart';

/// Ticket: Gp1-1..Gp1-4 — SQLite-backed implementation.
/// Status: wired to local database. Gp1-3 quiz storage remains in-memory
/// (no quiz table yet — see TODO below); everything else is persisted.
class SqliteExamRepository implements ExamRepository {
  SqliteExamRepository({AiGradingService? aiGradingService})
      : _ai = aiGradingService ?? AiGradingService();

  final AiGradingService _ai;
  final Map<String, QuizEntity> _quizzes = {};
  // TODO(Gp1-3): move quizzes to their own SQLite tables (quizzes,
  // quiz_questions) once the quiz builder UI needs to persist across
  // app restarts; kept in-memory for now to limit this pass's scope.

  Future<Database> get _db => AppDatabase.instance.database;

  ExamEntity _examFromRow(Map<String, Object?> row) => ExamEntity(
        id: row['id'] as String,
        title: row['title'] as String,
        type: ExamType.values.byName(row['type'] as String),
        subjectId: row['subjectId'] as String,
        subjectName: row['subjectName'] as String,
        teacherId: row['teacherId'] as String,
        teacherName: row['teacherName'] as String,
        groupId: row['groupId'] as String,
        groupName: row['groupName'] as String,
        date: DateTime.parse(row['date'] as String),
        durationMinutes: row['durationMinutes'] as int,
        bareme: row['bareme'] as double,
        coefficient: row['coefficient'] as double,
        isPublished: (row['isPublished'] as int) == 1,
      );

  @override
  Future<List<ExamEntity>> getExams() async {
    final db = await _db;
    final rows = await db.query('exams', orderBy: 'date ASC');
    return rows.map(_examFromRow).toList();
  }

  @override
  Future<ExamEntity> createExam(ExamEntity exam) async {
    final db = await _db;
    await db.insert('exams', {
      'id': exam.id,
      'title': exam.title,
      'type': exam.type.name,
      'subjectId': exam.subjectId,
      'subjectName': exam.subjectName,
      'teacherId': exam.teacherId,
      'teacherName': exam.teacherName,
      'groupId': exam.groupId,
      'groupName': exam.groupName,
      'date': exam.date.toIso8601String(),
      'durationMinutes': exam.durationMinutes,
      'bareme': exam.bareme,
      'coefficient': exam.coefficient,
      'isPublished': exam.isPublished ? 1 : 0,
    });
    return exam;
  }

  @override
  Future<ExamEntity> updateExam(ExamEntity exam) async {
    final db = await _db;
    await db.update(
      'exams',
      {
        'title': exam.title,
        'date': exam.date.toIso8601String(),
        'durationMinutes': exam.durationMinutes,
        'bareme': exam.bareme,
        'coefficient': exam.coefficient,
        'isPublished': exam.isPublished ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [exam.id],
    );
    return exam;
  }

  @override
  Future<void> deleteExam(String examId) async {
    final db = await _db;
    await db.delete('exams', where: 'id = ?', whereArgs: [examId]);
  }

  @override
  Future<void> publishExam(String examId) async {
    final db = await _db;
    await db.update(
      'exams',
      {'isPublished': 1},
      where: 'id = ?',
      whereArgs: [examId],
    );
  }

  @override
  Future<List<GradeEntity>> getRoster(String examId) async {
    final db = await _db;
    final rows = await db.query(
      'exam_grades',
      where: 'examId = ?',
      whereArgs: [examId],
    );
    return rows
        .map((r) => GradeEntity(
              studentId: r['studentId'] as String,
              studentName: r['studentName'] as String,
              attendance:
                  ExamAttendanceStatus.values.byName(r['attendance'] as String),
              grade: r['grade'] as double?,
              plagiarismFlag: (r['plagiarismFlag'] as int) == 1,
            ))
        .toList();
  }

  @override
  Future<void> updateGrade(String examId, GradeEntity grade) async {
    final db = await _db;
    await db.insert(
      'exam_grades',
      {
        'examId': examId,
        'studentId': grade.studentId,
        'studentName': grade.studentName,
        'attendance': grade.attendance.name,
        'grade': grade.grade,
        'plagiarismFlag': grade.plagiarismFlag ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<QuizEntity?> getQuiz(String examId) async => _quizzes[examId];

  @override
  Future<void> saveQuiz(QuizEntity quiz) async {
    _quizzes[quiz.examId] = quiz;
  }

  @override
  Future<double> autoGradeMcq(
    QuizEntity quiz,
    Map<String, int> studentAnswers,
  ) {
    return _ai.gradeMcq(quiz, studentAnswers);
  }
}