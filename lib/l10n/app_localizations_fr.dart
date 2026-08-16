// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'UniApp';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginSubtitle => 'Accédez à votre espace universitaire';

  @override
  String get loginIdentifierLabel => 'Email ou matricule';

  @override
  String get loginIdentifierHint => 'ex: etudiant@univ.fr ou 20231045';

  @override
  String get loginPasswordLabel => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginForgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginErrorRequired => 'Ce champ est requis';

  @override
  String get loginErrorInvalid => 'Identifiants incorrects';

  @override
  String get navHome => 'Accueil';

  @override
  String get navCourses => 'Cours';

  @override
  String get navExams => 'Examens';

  @override
  String get navProfile => 'Profil';

  @override
  String get navAdmin => 'Administration';

  @override
  String get navStudents => 'Étudiants';

  @override
  String get navTeachers => 'Enseignants';

  @override
  String get navRooms => 'Salles';

  @override
  String get sectionTodayEyebrow => 'Aujourd\'hui';

  @override
  String get sectionTodayTitle => 'Vos prochains examens';

  @override
  String get commonLoading => 'Chargement en cours';

  @override
  String get commonEmpty => 'Aucun élément à afficher';

  @override
  String get commonError => 'Une erreur est survenue';

  @override
  String get commonRetry => 'Réessayer';
}
