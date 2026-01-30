import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme configuration for BookBridge.
///
/// This class provides a centralized theme setup for the application,
/// following the "Knowledge & Trust" visual identity.
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // "Knowledge & Trust" Palette
  static const Color _scholarBlue = Color(0xFF1A4D8C); // Trust, stability
  static const Color _bridgeOrange = Color(0xFFF2994A); // Action, energy
  static const Color _growthGreen = Color(0xFF27AE60); // Impact, growth
  static const Color _paperWhite = Color(0xFFF9F9F9); // Clean, accessible
  static const Color _inkBlack = Color(0xFF2D3436); // Readability
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _divider = Color(0xFFE0E0E0);
  static const Color _lightGray = Color(0xFF95A5A6);

  /// Returns the light theme for BookBridge.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // Color scheme
      colorScheme: ColorScheme.light(
        surface: _surface,
        primary: _scholarBlue,
        secondary: _bridgeOrange,
        tertiary: _growthGreen,
        onSurface: _inkBlack,
        onPrimary: Colors.white,
        error: const Color(0xFFE74C3C),
        surfaceContainerHighest: _paperWhite,
        outline: _divider,
      ),
      // Scaffold background
      scaffoldBackgroundColor: _paperWhite,
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: _scholarBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      // Card theme
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _scholarBlue, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: _lightGray, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: _scholarBlue, fontSize: 14),
      ),
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _bridgeOrange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _scholarBlue,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _scholarBlue,
          side: const BorderSide(color: _scholarBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // Text themes
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
          color: _inkBlack,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.montserrat(
          color: _inkBlack,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.montserrat(
          color: _inkBlack,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.montserrat(
          color: _inkBlack,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: GoogleFonts.montserrat(
          color: _inkBlack,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.montserrat(
          color: _inkBlack,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.inter(color: _inkBlack, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: _inkBlack, fontSize: 14),
        bodySmall: GoogleFonts.inter(color: _lightGray, fontSize: 12),
        labelLarge: GoogleFonts.inter(
          color: _scholarBlue,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      // Icon theme
      iconTheme: const IconThemeData(color: _scholarBlue, size: 24),
    );
  }

  // Keep darkTheme for now but it's not the primary identity
  static ThemeData get darkTheme => lightTheme; // For transition
}
