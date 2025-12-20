import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // -- Primary Brand Colors (Blue/Green) [cite: 340] --
  static const Color primary = Color(0xFF4A90E2); // Soft Medical Blue
  static const Color secondary = Color(0xFF50E3C2); // Fresh Teal/Green
  static const Color accent = Color(0xFF2ECC71); // Success Green (for "Pris")

  // -- Background & Surface Colors --
  static const Color background = Color(
    0xFFF5F7FA,
  ); // Very light grey/blue tint
  static const Color surface = Colors.white; // Card backgrounds
  static const Color surfaceAlt = Color(0xFFEBF4FF); // Light blue highlights

  // -- Text Colors --
  static const Color textPrimary = Color(
    0xFF2D3436,
  ); // Dark Grey (softer than black)
  static const Color textSecondary = Color(0xFF636E72); // Medium Grey
  static const Color textInverse = Colors.white;

  // -- Status Colors --
  static const Color error = Color(0xFFFF6B6B); // Soft Red (Missed/Error)
  static const Color warning = Color(0xFFFFCC00); // Late/Warning
  static const Color success = Color(0xFF2ECC71); // Taken

  // -- UI Elements --
  static const Color border = Color(0xFFDFE6E9);
  static const Color iconColor = Color(0xFFB2BEC3);
}
