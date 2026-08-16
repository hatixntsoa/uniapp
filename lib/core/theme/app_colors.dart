import 'package:flutter/material.dart';

/// Ticket: core — design system foundation (section 3)
/// Single accent color, light-mode-first palette.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF13151A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  static const Color hairline = Color(0xFFE5E7EB);

  // Single confident accent: indigo. Never introduce a second accent.
  static const Color accent = Color(0xFF4F46E5);
  static const Color accentSoft = Color(0xFFEEF2FF);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);

  // Status colors used consistently for présence/salle/etc.
  static const Color statusPresent = success;
  static const Color statusAbsent = danger;
  static const Color statusLate = warning;
  static const Color statusJustified = Color(0xFF6366F1);
}
