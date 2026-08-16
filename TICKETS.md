# UniApp — Suivi des tickets

| Ticket | Dossier | Fichier(s) | Description | Statut |
|---|---|---|---|---|
| Gp1-1 | features/exams | exam_entity.dart, exam_form_screen.dart | Créer évaluation | mocked |
| Gp1-2 | features/exams | exam_roster_screen.dart, grade_entity.dart | Liste étudiants, pointage, notes, publication | mocked |
| Gp1-3 | features/exams | exam_entity.dart (ExamType), quiz_entity.dart | Types d'évaluation + quiz builder (entités) | mocked |
| Gp1-4 | features/exams | exam_form_screen.dart | Lien évaluation/matière/enseignant/groupe | mocked, needs subjects/teachers/admin modules |
| Gp1-5 | features/exams | ai_grading_service.dart | QCM auto-corrigé (fonctionnel) + plagiat (stub) | partially mocked |
| Gp2-1 | features/students | student_entity.dart, student_form_screen.dart | Ajout/édition/archivage étudiant | mocked |
| Gp2-2 | features/students | student_profile_screen.dart | Profil complet + QR + historique académique | mocked |
| Gp2-3 | features/students | student_list_screen.dart, student_situation_screen.dart | Recherche/filtres + vue globale | mocked |
| Gp2-4 | features/attendance_qr | attendance_session_entity.dart, session_checkin_screen.dart, qr_scan_screen.dart | Session de présence, ouverture/fermeture, check-in manuel + QR, statuts | mocked |
| Gp2-5 | features/attendance_qr | attendance_reports_screen.dart | Rapports (par élève/cours/groupe) + alertes absences répétées | mocked |
| Gp3-1 | features/admin | — | Années/semestres/départements/filières | pending |
| Gp3-2 | features/admin | — | Dashboard admin | pending |
| Gp3-3 | features/auth | core/services/auth_service.dart, features/auth/... | Login/logout/reset/rôles | **mocked** |
| Gp3-4 | features/auth | — | Profil, mot de passe, session sécurisée | in progress |
| Gp4-1..5 | features/teachers | — | Profil enseignant, EDT, recherche, liens matière | pending |
| Gp5-1..3 | features/subjects | — | Matières, liens, filtres | pending |
| Gp5-4/5, Gp6-1/2 | features/equipment | — | Matériels, mouvements, QR, alertes | pending |
| Gp6-3..5 | features/social_feed | — | Fil d'actualité, groupes, messagerie | pending |
| Gp7-1..5 | features/activities | — | Activités, inscriptions, stats | pending |
| Gp8-1,3..6 | features/rooms | — | Salles, disponibilité, réservation | pending |
| Gp9-1,2,3,5 | features/timetable | — | Emplois du temps, conflits, vues multiples | pending |
| Gp10-1..3 | features/presentations | — | Présentations, évaluation, historique | pending |

**Fondations livrées (hors tickets numérotés) :** thème, widgets partagés (`AppCard`, `SectionHeader`, `MediaCard`, `PillBadge`, `AppTimelineTile`), routeur, coquille d'app avec navigation par rôle, écran de connexion (mock).