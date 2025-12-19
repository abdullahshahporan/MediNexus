import 'package:flutter/material.dart';

/// MediNexus Color System
/// Supports both Dark and Light modes with glassmorphism design
class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK MODE COLORS (Primary Theme)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Background gradients
  static const darkBg1 = Color(0xFF0A0A0A);
  static const darkBg2 = Color(0xFF1A1A1A);
  static const darkBg3 = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  
  // Glass effects for dark mode
  static const darkGlassWhite = Color(0x0DFFFFFF);     // 5% white
  static const darkGlassBorder = Color(0x1AFFFFFF);    // 10% white
  static const darkGlassHighlight = Color(0x33FFFFFF); // 20% white
  
  // Text colors for dark mode
  static const darkTextPrimary = Color(0xFFF5F5F5);    // 96% white
  static const darkTextSecondary = Color(0xB3FFFFFF);  // 70% white
  static const darkTextTertiary = Color(0x66FFFFFF);   // 40% white
  static const darkTextDisabled = Color(0x33FFFFFF);   // 20% white

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT MODE COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Background
  static const lightBg1 = Color(0xFFF8FAFC);
  static const lightBg2 = Color(0xFFFFFFFF);
  static const lightBg3 = Color(0xFFF1F5F9);
  static const lightSurface = Color(0xFFFFFFFF);
  
  // Glass effects for light mode
  static const lightGlassWhite = Color(0xB3FFFFFF);    // 70% white
  static const lightGlassBorder = Color(0x1A000000);   // 10% black
  static const lightGlassHighlight = Color(0xE6FFFFFF); // 90% white
  
  // Text colors for light mode
  static const lightTextPrimary = Color(0xFF0F172A);   // Slate 900
  static const lightTextSecondary = Color(0xFF475569); // Slate 600
  static const lightTextTertiary = Color(0xFF94A3B8);  // Slate 400
  static const lightTextDisabled = Color(0xFFCBD5E1);  // Slate 300

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCENT COLORS (Same for both modes)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Primary - Teal/Cyan (Medical theme)
  static const primary = Color(0xFF14B8A6);           // Teal 500
  static const primaryLight = Color(0xFF5EEAD4);      // Teal 300
  static const primaryDark = Color(0xFF0F766E);       // Teal 700
  
  // Secondary - Purple (Premium feel)
  static const secondary = Color(0xFF8B5CF6);         // Violet 500
  static const secondaryLight = Color(0xFFA78BFA);    // Violet 400
  static const secondaryDark = Color(0xFF6D28D9);     // Violet 700
  
  // Doctor specific accent
  static const doctorAccent = Color(0xFF6366F1);      // Indigo 500
  static const doctorAccentLight = Color(0xFF818CF8); // Indigo 400
  
  // Patient specific accent
  static const patientAccent = Color(0xFF06B6D4);     // Cyan 500
  static const patientAccentLight = Color(0xFF22D3EE); // Cyan 400

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Success
  static const success = Color(0xFF22C55E);           // Green 500
  static const successLight = Color(0xFF4ADE80);      // Green 400
  static const successBg = Color(0x1A22C55E);         // 10% green
  
  // Error / Danger
  static const error = Color(0xFFEF4444);             // Red 500
  static const errorLight = Color(0xFFF87171);        // Red 400
  static const errorBg = Color(0x1AEF4444);           // 10% red
  
  // Warning
  static const warning = Color(0xFFF59E0B);           // Amber 500
  static const warningLight = Color(0xFFFBBF24);      // Amber 400
  static const warningBg = Color(0x1AF59E0B);         // 10% amber
  
  // Info
  static const info = Color(0xFF3B82F6);              // Blue 500
  static const infoLight = Color(0xFF60A5FA);         // Blue 400
  static const infoBg = Color(0x1A3B82F6);            // 10% blue

  // ═══════════════════════════════════════════════════════════════════════════
  // FUNCTIONAL COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Online/Offline status
  static const online = Color(0xFF22C55E);            // Green
  static const offline = Color(0xFF64748B);           // Slate 500
  static const busy = Color(0xFFEF4444);              // Red
  static const away = Color(0xFFF59E0B);              // Amber
  
  // Appointment status
  static const appointmentWaiting = Color(0xFFFCD34D);
  static const appointmentConfirmed = Color(0xFF22C55E);
  static const appointmentCompleted = Color(0xFF3B82F6);
  static const appointmentCancelled = Color(0xFFEF4444);
  
  // Adherence colors (for heatmap)
  static const adherenceComplete = Color(0xFF22C55E);
  static const adherenceMissed = Color(0xFFEF4444);
  static const adherencePartial = Color(0xFFF59E0B);
  static const adherenceNone = Color(0xFF374151);     // Gray 700

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENT DEFINITIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBg1, darkBg2, darkBg1],
  );
  
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightBg1, lightBg2, lightBg3],
  );
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient doctorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [doctorAccent, secondary],
  );
  
  static const LinearGradient patientGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [patientAccent, primary],
  );
  
  static const LinearGradient alertGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [error, errorLight],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // CONVENIENCE ALIASES (for backward compatibility)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Dark mode background and card aliases
  static const darkBg = darkBg1;
  static const darkCardBg = darkGlassWhite;
  static const darkBorder = darkGlassBorder;
  static const backgroundDark = darkBg1;
  static const surfaceDark = darkSurface;
  
  // Light mode background and card aliases
  static const lightBg = lightBg1;
  static const lightCardBg = lightGlassWhite;
  static const lightBorder = lightGlassBorder;
  static const backgroundLight = lightBg1;
  static const surfaceLight = lightSurface;
  
  // Primary color aliases
  static const doctorPrimary = doctorAccent;
  static const patientPrimary = patientAccent;
  static const doctorSecondary = secondaryLight;
  static const patientSecondary = primaryLight;
}
