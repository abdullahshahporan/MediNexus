import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MediNexus Typography System
/// Using Inter for UI and Poppins for headings
class AppTextStyles {
  AppTextStyles._();

  // ═══════════════════════════════════════════════════════════════════════════
  // FONT FAMILIES
  // ═══════════════════════════════════════════════════════════════════════════
  
  static String get _headingFont => GoogleFonts.poppins().fontFamily!;
  static String get _bodyFont => GoogleFonts.inter().fontFamily!;

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY STYLES (Large headers, splash screens)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static TextStyle displayLarge(Color color) => TextStyle(
    fontFamily: _headingFont,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.2,
    color: color,
  );
  
  static TextStyle displayMedium(Color color) => TextStyle(
    fontFamily: _headingFont,
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.25,
    color: color,
  );
  
  static TextStyle displaySmall(Color color) => TextStyle(
    fontFamily: _headingFont,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    color: color,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADING STYLES (Section headers, card titles)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static TextStyle headlineLarge(Color color) => TextStyle(
    fontFamily: _headingFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.35,
    color: color,
  );
  
  static TextStyle headlineMedium(Color color) => TextStyle(
    fontFamily: _headingFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
    color: color,
  );
  
  static TextStyle headlineSmall(Color color) => TextStyle(
    fontFamily: _headingFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
    color: color,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TITLE STYLES (List item titles, dialog titles)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static TextStyle titleLarge(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
    color: color,
  );
  
  static TextStyle titleMedium(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.45,
    color: color,
  );
  
  static TextStyle titleSmall(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
    color: color,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY STYLES (Paragraphs, descriptions)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static TextStyle bodyLarge(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: color,
  );
  
  static TextStyle bodyMedium(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
    color: color,
  );
  
  static TextStyle bodySmall(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.5,
    color: color,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LABEL STYLES (Buttons, chips, form labels)
  // ═══════════════════════════════════════════════════════════════════════════
  
  static TextStyle labelLarge(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
    color: color,
  );
  
  static TextStyle labelMedium(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
    color: color,
  );
  
  static TextStyle labelSmall(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
    color: color,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL STYLES
  // ═══════════════════════════════════════════════════════════════════════════
  
  static TextStyle button(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
    color: color,
  );
  
  static TextStyle caption(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.4,
    color: color,
  );
  
  static TextStyle overline(Color color) => TextStyle(
    fontFamily: _bodyFont,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    height: 1.4,
    color: color,
  );
  
  // For numbers and stats
  static TextStyle number(Color color) => TextStyle(
    fontFamily: _headingFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: color,
  );
  
  // For time display
  static TextStyle time(Color color) => TextStyle(
    fontFamily: _headingFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.4,
    color: color,
  );
}
