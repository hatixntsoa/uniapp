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
| Gp3-1 | features/admin | academic_structure_entities.dart, academic_structure_screen.dart | Années/semestres/départements/filières/niveaux/groupes/classes | mocked |
| Gp3-2 | features/admin | admin_dashboard_stats.dart, admin_dashboard_screen.dart | Dashboard admin avec indicateurs clés | mocked |
| Gp3-3 | features/auth, core/services | permission_service.dart, permission_gate.dart, forgot_password_screen.dart | Login/logout/reset, gestion des rôles, permission gating | mocked |
| Gp3-4 | features/auth, core/services | session_service.dart, profile_screen.dart, edit_profile_screen.dart, change_password_screen.dart | Profil, mot de passe, session sécurisée (refresh + auto-logout) | mocked |
| Gp4-1 | features/teachers | teacher_entity.dart, teacher_form_screen.dart | Ajout profil enseignant | mocked |
| Gp4-2 | features/teachers | teacher_form_screen.dart | Édition profil, statut, assignation niveaux/groupes | mocked |
| Gp4-3 | features/teachers | teacher_schedule_entry.dart, teacher_detail_screen.dart | Vue EDT + absences | mocked |
| Gp4-4 | features/teachers | teacher_list_screen.dart | Recherche/filtre par département | mocked |
| Gp4-5 | features/teachers | teacher_repository.dart (assignSubjects) | Liaison enseignant↔matière | mocked |
| Gp5-1 | features/subjects | subject_entity.dart, subject_form_screen.dart | Créer matière (code, coef, volume, semestre, niveau, enseignant) | mocked |
| Gp5-2 | features/subjects | subject_links.dart, subject_detail_screen.dart | Lien évaluations/notes/EDT/groupes | mocked |
| Gp5-3 | features/subjects | subject_list_screen.dart | Recherche/filtre niveau/filière/enseignant | mocked |
| Gp5-4 | features/equipment | equipment_entity.dart, equipment_form_screen.dart | Ajout matériel (catégorie, salle, état, id, responsable) | mocked |
| Gp5-5 | features/equipment | equipment_movement.dart, equipment_detail_screen.dart | Mouvements (réservation, sortie, retour, panne, maintenance) | mocked |
| Gp6-1 | features/equipment | equipment_repository.dart (findByQrPayload), equipment_list_screen.dart | Recherche par QR (réutilise le scanner du module 3) | mocked |
| Gp6-2 | features/equipment | equipment_alerts_screen.dart, incident_report.dart | Inventaire + alertes pannes fréquentes, incident rapide | mocked |
| Gp6-3..5 | features/social_feed | — | Fil d'actualité, groupes, messagerie | pending |
| Gp7-1..5 | features/activities | — | Activités, inscriptions, stats | pending |
| Gp8-1,3..6 | features/rooms | — | Salles, disponibilité, réservation | pending |
| Gp9-1,2,3,5 | features/timetable | — | Emplois du temps, conflits, vues multiples | pending |
| Gp10-1..3 | features/presentations | — | Présentations, évaluation, historique | pending |

**Fondations livrées (hors tickets numérotés) :** thème, widgets partagés (`AppCard`, `SectionHeader`, `MediaCard`, `PillBadge`, `AppTimelineTile`), routeur, coquille d'app avec navigation par rôle, écran de connexion (mock).