import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Timeless Legacy)
  static const Color primary = Color(0xFF234B6B);  // Deep Blue
  static const Color primaryLight = Color(0xFF345F88);  // Light Blue
  static const Color secondary = Color(0xFFC17F59);  // Warm Brown
  static const Color secondaryLight = Color(0xFFE6A87C);  // Light Brown
  static const Color background = Color(0xFFF5F0E6);  // Off White
  static const Color accent = Color(0xFFE6A87C);  // Using Light Brown as accent

  // Cultural Heritage Colors
  static const Color cultural = Color(0xFFD48166);  // Terra Cotta
  static const Color culturalLight = Color(0xFFE9A17C);  // Light Terra Cotta
  static const Color culturalDark = Color(0xFF1D3F5E);  // Deep Navy
  static const Color culturalNeutral = Color(0xFFC2B280);  // Sand
  static const Color culturalBackground = Color(0xFFE8E6E1);  // Light Gray

  // Modern Archive Colors
  static const Color archive = Color(0xFFB87756);  // Rust
  static const Color archiveLight = Color(0xFFE4956B);  // Light Rust
  static const Color archiveNeutral = Color(0xFFA69887);  // Taupe
  static const Color archiveMuted = Color(0xFFD5CDC3);  // Light Taupe
  static const Color archiveBackground = Color(0xFFF7F4F0);  // Cream

  // Status Colors
  static const Color success = Color(0xFF234B6B);  // Deep Blue
  static const Color info = Color(0xFF345F88);  // Light Blue
  static const Color warning = Color(0xFFC17F59);  // Warm Brown
  static const Color error = Color(0xFFD48166);  // Terra Cotta

  // Text Colors
  static const Color textPrimary = Color(0xFF1D3F5E);  // Deep Navy
  static const Color textSecondary = Color(0xFF345F88);  // Light Blue
  static const Color textMuted = Color(0xFFA69887);  // Taupe

  // Card Colors
  static const Color cardBackground = Color(0xFFF5F0E6);  // Off White
  static const Color cardBorder = Color(0xFFD5CDC3);  // Light Taupe

  // Navigation Colors
  static const Color navBarBackground = Color(0xFF234B6B);  // Deep Blue
  static const Color navBarSelected = Color(0xFFE6A87C);  // Light Brown
  static const Color navBarUnselected = Color(0xFFA69887);  // Taupe

  // Overlay Colors
  static const Color overlay30 = Color(0x4D234B6B);  // Deep Blue with 30% opacity
  static const Color overlay50 = Color(0x80234B6B);

  static const MaterialColor surface = MaterialColor(
    0xFFF5F0E6, // Using background color as primary
    <int, Color>{
      50: Color(0xFFFBF9F5),
      100: Color(0xFFF7F4F0),
      200: Color(0xFFF5F0E6),
      300: Color(0xFFE8E6E1),
      400: Color(0xFFD5CDC3),
      500: Color(0xFFC2B280),
      600: Color(0xFFA69887),
      700: Color(0xFF8A7E6D),
      800: Color(0xFF6E6454),
      900: Color(0xFF524A3A),
    },
  );

  static const List<List<Color>> cardGradients = [
    [Color(0xFF234B6B), Color(0xFF345F88)], // Primary gradient
    [Color(0xFFC17F59), Color(0xFFE6A87C)], // Secondary gradient
    [Color(0xFFD48166), Color(0xFFE9A17C)], // Cultural gradient
    [Color(0xFFB87756), Color(0xFFE4956B)], // Archive gradient
  ];
}