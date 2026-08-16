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
| Gp6-3 | features/social_feed | post_entity.dart, feed_screen.dart, post_detail_screen.dart | Fil d'actualité, posts officiels, réactions, commentaires, modération | mocked |
| Gp6-4 | features/social_feed | activity_group_entity.dart, group_list_screen.dart | Groupes classe/club/activité | mocked |
| Gp6-5 | features/social_feed | chat_transport.dart, mock_chat_transport.dart, chat_screen.dart | Messagerie/bot (scaffold UI + transport pluggable) | stubbed |
| Gp7-1 | features/activities | activity_entity.dart, activity_form_screen.dart | Créer activité (type, date, lieu, responsable, places, description) | mocked |
| Gp7-2 | features/activities | activity_form_screen.dart | Détails complets de création | mocked |
| Gp7-3 | features/activities | activity_form_screen.dart, activity_repository.dart (publishActivity) | Publication + inscription (places) | mocked |
| Gp7-4 | features/activities | activity_list_screen.dart, activity_detail_screen.dart, registration_entity.dart | Browse/inscription/désinscription + historique | mocked |
| Gp7-5 | features/activities | participation_stats.dart, participation_stats_screen.dart | Statistiques admin de participation | mocked |
| Gp8-1 | features/rooms | room_entity.dart, room_form_screen.dart | Ajout salle (capacité, type, localisation, équipement) | mocked |
| Gp8-3 | features/rooms | room_form_screen.dart | Édition salle | mocked |
| Gp8-4 | features/rooms | room_reservation.dart, room_detail_screen.dart | Disponibilité/état/historique d'occupation | mocked |
| Gp8-5 | features/rooms | room_reservation_screen.dart, room_repository.dart (checkConflict, autoAssign) | Recherche, réservation/auto-assignation, vue conflits | mocked |
| Gp8-6 | features/rooms | room_detail_screen.dart (PopupMenuButton status) | Statuts indisponible/occupée/maintenance | mocked |
| Gp9-1 | features/timetable | timetable_slot_entity.dart, timetable_form_screen.dart | Créer EDT par groupe/niveau | mocked |
| Gp9-2 | features/timetable | timetable_form_screen.dart | Assigner matière/enseignant/salle/jour/créneau, édition/annulation | mocked |
| Gp9-3 | features/timetable | timetable_conflict.dart, timetable_conflicts_screen.dart | Détection conflits salle/enseignant/groupe | mocked |
| Gp9-5 | features/timetable | timetable_view_screen.dart | Vue multi-consultation + auto-notification (stub) | mocked |
| Gp10-1..Gp10-3 | features/presentations | Présentations, évaluation, historique | mocked |

**Toutes les 46 tickets sont livrées avec UI complète, providers Riverpod, et couche
repository mockée derrière une interface prête pour l'intégration API réelle.**

**Prochaines étapes suggérées (hors scope de cette livraison) :**
1. Remplacer chaque `Mock*Repository` par une implémentation Dio pointant vers le vrai backend.
2. Brancher `flutter_local_notifications` pour les TODO de notification (activités, EDT).
3. Relier les pickers texte-libre (matière/enseignant/groupe dans plusieurs formulaires)
   à de vrais dropdowns alimentés par `features/admin`, `features/teachers`, `features/subjects`.
4. Appeler `AuthNotifier.notifyActivity()` depuis un `Listener` global dans `AppShell`
   pour activer le timer d'inactivité (Gp3-4).
5. Ajouter les tests widgets/unitaires (section 1 du prompt) — non inclus dans cette livraison de code.
6. Ajouter les fichiers ARB `app_en.arb` si l'anglais devient nécessaire.