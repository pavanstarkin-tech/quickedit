import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle displayHero({Color color = AppColors.surfaceWhite}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 28,
        height: 1.15,
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: -0.5,
      );

  static TextStyle headlineLarge({Color color = AppColors.textDark}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 22,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.3,
      );

  static TextStyle titleLarge({Color color = AppColors.textDark}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 18,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle titleMedium({Color color = AppColors.textDark}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 16,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle bodyMedium({Color color = AppColors.textDark}) =>
      GoogleFonts.inter(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodySmall({Color color = AppColors.mutedGray}) =>
      GoogleFonts.inter(
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle labelLarge({Color color = AppColors.surfaceWhite}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle labelSmall({Color color = AppColors.mutedGray}) =>
      GoogleFonts.inter(
        fontSize: 12,
        height: 1.2,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle mono({Color color = AppColors.textDark, double fontSize = 13}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: color,
      );
}
