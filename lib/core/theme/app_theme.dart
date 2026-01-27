import 'package:flutter/material.dart';

/// App theme configuration for BookBridge.
///
/// This class provides a centralized theme setup for the application,
/// following the minimalist, dark-themed design specifications.
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Color palette
  static const Color _background = Color(0xFF102216); // Background dark
  static const Color _surface = Color(0xFF1C271F); // Surface dark
  static const Color _primary = Color(0xFF13EC5B); // Primary green
  static const Color _onBackground = Color(0xFFFFFFFF);
  static const Color _onSurface = Color(0xFFE0E0E0);
  static const Color _surfaceVariant = Color(
    0xFF1A2E20,
  ); // Surface dark variant
  static const Color _divider = Color(0xFF28392E); // Border dark
  static const Color _lightGray = Color(
    0xFF9DB9A6,
  ); // Light gray for secondary text

  /// Returns the dark theme for BookBridge.
  ///
  /// Features:
  /// - Background: #102216 (dark green)
  /// - Surface: #1C271F (darker green)
  /// - Primary Accent: #13EC5B (bright green)
  /// - Text colors optimized for dark backgrounds
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // Color scheme
      colorScheme: const ColorScheme.dark(
        surface: _surface,
        primary: _primary,
        onSurface: _onSurface,
        error: Color(0xFFE85D5D), // Soft red for errors
        // background: _background, // Deprecated, mapped to surface usually, or let it fallback
        surfaceContainerHighest: _surfaceVariant,
        outline: _divider,
      ),
      // Scaffold background
      scaffoldBackgroundColor: _background,
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _background,
        foregroundColor: _onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      // Card theme
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      // Input decoration theme (for text fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        hintStyle: TextStyle(color: _lightGray, fontSize: 14),
        labelStyle: TextStyle(color: _primary, fontSize: 14),
      ),
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primary,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primary,
          side: const BorderSide(color: _primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      // Text themes
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: _onBackground,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: _onBackground,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: _onBackground,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: _onBackground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: _onBackground,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: _onBackground,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: _onSurface, fontSize: 16),
        bodyMedium: TextStyle(color: _onSurface, fontSize: 14),
        bodySmall: TextStyle(color: _lightGray, fontSize: 12),
        labelLarge: TextStyle(
          color: _primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      // Icon theme
      iconTheme: const IconThemeData(color: _onSurface, size: 24),
    );
  }
}
