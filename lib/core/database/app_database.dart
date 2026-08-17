import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Ticket: core — shared local SQLite database.
/// Single source of truth for on-device persistence across all modules.
/// Replaces the in-memory Mock*Repository lists module by module.
class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  static const _dbName = 'uniapp.db';
  static const _dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    // ---- students (Gp2-1..Gp2-3) ----
    batch.execute('''
      CREATE TABLE students (
        id TEXT PRIMARY KEY,
        fullName TEXT NOT NULL,
        matricule TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL,
        filiere TEXT NOT NULL,
        niveau TEXT NOT NULL,
        groupName TEXT NOT NULL,
        anneeUniversitaire TEXT NOT NULL,
        photoUrl TEXT,
        isArchived INTEGER NOT NULL DEFAULT 0
      )
    ''');

    batch.execute('''
      CREATE TABLE academic_history (
        id TEXT PRIMARY KEY,
        studentId TEXT NOT NULL,
        title TEXT NOT NULL,
        subtitle TEXT NOT NULL,
        date TEXT NOT NULL,
        details TEXT NOT NULL,
        FOREIGN KEY (studentId) REFERENCES students (id) ON DELETE CASCADE
      )
    ''');

    // ---- exams (Gp1-1..Gp1-5) ----
    batch.execute('''
      CREATE TABLE exams (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        subjectId TEXT NOT NULL,
        subjectName TEXT NOT NULL,
        teacherId TEXT NOT NULL,
        teacherName TEXT NOT NULL,
        groupId TEXT NOT NULL,
        groupName TEXT NOT NULL,
        date TEXT NOT NULL,
        durationMinutes INTEGER NOT NULL,
        bareme REAL NOT NULL,
        coefficient REAL NOT NULL,
        isPublished INTEGER NOT NULL DEFAULT 0
      )
    ''');

    batch.execute('''
      CREATE TABLE exam_grades (
        examId TEXT NOT NULL,
        studentId TEXT NOT NULL,
        studentName TEXT NOT NULL,
        attendance TEXT NOT NULL,
        grade REAL,
        plagiarismFlag INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (examId, studentId),
        FOREIGN KEY (examId) REFERENCES exams (id) ON DELETE CASCADE
      )
    ''');

    // ---- attendance_qr (Gp2-4, Gp2-5) ----
    batch.execute('''
      CREATE TABLE attendance_sessions (
        id TEXT PRIMARY KEY,
        courseName TEXT NOT NULL,
        groupName TEXT NOT NULL,
        teacherName TEXT NOT NULL,
        startTime TEXT NOT NULL,
        state TEXT NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE attendance_records (
        sessionId TEXT NOT NULL,
        studentId TEXT NOT NULL,
        studentName TEXT NOT NULL,
        status TEXT NOT NULL,
        checkedInAt TEXT,
        PRIMARY KEY (sessionId, studentId),
        FOREIGN KEY (sessionId) REFERENCES attendance_sessions (id) ON DELETE CASCADE
      )
    ''');

    await batch.commit(noResult: true);
    await _seed(db);
  }

  Future<void> _seed(Database db) async {
    final batch = db.batch();

    // Students — mirrors previous MockStudentRepository fixtures
    batch.insert('students', {
      'id': 'u-stud-1',
      'fullName': 'Lina Meziane',
      'matricule': '20231045',
      'email': 'lina.meziane@etu.univ.fr',
      'filiere': 'Informatique',
      'niveau': 'L2',
      'groupName': 'Groupe A',
      'anneeUniversitaire': '2025/2026',
      'isArchived': 0,
    });
    batch.insert('students', {
      'id': 'u-stud-2',
      'fullName': 'Yanis Kaci',
      'matricule': '20231046',
      'email': 'yanis.kaci@etu.univ.fr',
      'filiere': 'Informatique',
      'niveau': 'L2',
      'groupName': 'Groupe A',
      'anneeUniversitaire': '2025/2026',
      'isArchived': 0,
    });
    batch.insert('students', {
      'id': 'u-stud-3',
      'fullName': 'Amel Cherif',
      'matricule': '20231047',
      'email': 'amel.cherif@etu.univ.fr',
      'filiere': 'Génie Logiciel',
      'niveau': 'L3',
      'groupName': 'Groupe B',
      'anneeUniversitaire': '2025/2026',
      'isArchived': 0,
    });
    batch.insert('students', {
      'id': 'u-stud-4',
      'fullName': 'Sofiane Belkacem',
      'matricule': '20231048',
      'email': 'sofiane.belkacem@etu.univ.fr',
      'filiere': 'Réseaux',
      'niveau': 'M1',
      'groupName': 'Groupe C',
      'anneeUniversitaire': '2025/2026',
      'isArchived': 0,
    });

    // Academic history sample for u-stud-1
    batch.insert('academic_history', {
      'id': 'hist-1',
      'studentId': 'u-stud-1',
      'title': 'Inscription L2 Informatique',
      'subtitle': 'Groupe A · Année 2025/2026',
      'date': DateTime(2025, 9, 15).toIso8601String(),
      'details': 'Filière: Informatique|Niveau: L2',
    });

    // Exams — mirrors previous MockExamRepository fixtures
    final exam1Date = DateTime.now()
        .add(const Duration(days: 3))
        .toIso8601String();
    final exam2Date = DateTime.now()
        .add(const Duration(days: 10))
        .toIso8601String();

    batch.insert('exams', {
      'id': 'ex-1',
      'title': 'Contrôle continu — Algorithmique',
      'type': 'continueEval',
      'subjectId': 'sub-1',
      'subjectName': 'Algorithmique',
      'teacherId': 'u-teach-1',
      'teacherName': 'Karim Haddad',
      'groupId': 'grp-1',
      'groupName': 'L2 Info — Groupe A',
      'date': exam1Date,
      'durationMinutes': 60,
      'bareme': 20.0,
      'coefficient': 1.5,
      'isPublished': 0,
    });
    batch.insert('exams', {
      'id': 'ex-2',
      'title': 'Examen final — Bases de données',
      'type': 'examenFinal',
      'subjectId': 'sub-2',
      'subjectName': 'Bases de données',
      'teacherId': 'u-teach-1',
      'teacherName': 'Karim Haddad',
      'groupId': 'grp-1',
      'groupName': 'L2 Info — Groupe A',
      'date': exam2Date,
      'durationMinutes': 120,
      'bareme': 20.0,
      'coefficient': 3.0,
      'isPublished': 0,
    });

    batch.insert('exam_grades', {
      'examId': 'ex-1',
      'studentId': 'u-stud-1',
      'studentName': 'Lina Meziane',
      'attendance': 'present',
      'grade': 15.5,
      'plagiarismFlag': 0,
    });
    batch.insert('exam_grades', {
      'examId': 'ex-1',
      'studentId': 'u-stud-2',
      'studentName': 'Yanis Kaci',
      'attendance': 'absent',
      'grade': null,
      'plagiarismFlag': 0,
    });
    batch.insert('exam_grades', {
      'examId': 'ex-1',
      'studentId': 'u-stud-3',
      'studentName': 'Amel Cherif',
      'attendance': 'late',
      'grade': 12.0,
      'plagiarismFlag': 0,
    });

    // Attendance sessions — mirrors previous MockAttendanceRepository
    batch.insert('attendance_sessions', {
      'id': 'sess-1',
      'courseName': 'Algorithmique',
      'groupName': 'Groupe A',
      'teacherName': 'Karim Haddad',
      'startTime': DateTime.now().toIso8601String(),
      'state': 'open',
    });
    batch.insert('attendance_sessions', {
      'id': 'sess-2',
      'courseName': 'Bases de données',
      'groupName': 'Groupe A',
      'teacherName': 'Karim Haddad',
      'startTime': DateTime.now()
          .subtract(const Duration(days: 2))
          .toIso8601String(),
      'state': 'closed',
    });

    for (final s in [
      ('sess-1', 'u-stud-1', 'Lina Meziane'),
      ('sess-1', 'u-stud-2', 'Yanis Kaci'),
      ('sess-1', 'u-stud-3', 'Amel Cherif'),
      ('sess-2', 'u-stud-1', 'Lina Meziane'),
    ]) {
      batch.insert('attendance_records', {
        'sessionId': s.$1,
        'studentId': s.$2,
        'studentName': s.$3,
        'status': 'absent',
        'checkedInAt': null,
      });
    }

    await batch.commit(noResult: true);
  }

  /// Useful for tests or a "reset demo data" debug action.
  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
    _db = null;
    await database;
  }
}
