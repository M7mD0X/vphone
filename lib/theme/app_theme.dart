import 'package:flutter/material.dart';

class VPhoneTheme {
  // Colors
  static const Color bgDeep = Color(0xFF080B14);
  static const Color bgCard = Color(0xFF0D1220);
  static const Color bgSurface = Color(0xFF111827);
  static const Color accent = Color(0xFF00D4FF);
  static const Color accentGlow = Color(0x4000D4FF);
  static const Color accentSecondary = Color(0xFF7C3AFF);
  static const Color accentTertiary = Color(0xFF00FF94);
  static const Color textPrimary = Color(0xFFE8F4FF);
  static const Color textSecondary = Color(0xFF6B8CAE);
  static const Color textMuted = Color(0xFF2D4A6B);
  static const Color danger = Color(0xFFFF3B6B);
  static const Color warning = Color(0xFFFFB800);
  static const Color success = Color(0xFF00FF94);
  static const Color border = Color(0xFF1A2D45);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgDeep,
        fontFamily: 'Rajdhani',
        colorScheme: const ColorScheme.dark(
          primary: accent,
          secondary: accentSecondary,
          surface: bgSurface,
          error: danger,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: 2,
          ),
          iconTheme: IconThemeData(color: accent),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -1,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: 1,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0.5,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 14,
            color: textSecondary,
          ),
        ),
      );
}

// Glow effect helper
BoxDecoration glowDecoration({
  Color? color,
  double blur = 20,
  double opacity = 0.3,
  double borderRadius = 16,
  bool showBorder = true,
}) {
  final c = color ?? VPhoneTheme.accent;
  return BoxDecoration(
    color: VPhoneTheme.bgCard,
    borderRadius: BorderRadius.circular(borderRadius),
    border: showBorder
        ? Border.all(color: c.withOpacity(0.2), width: 1)
        : null,
    boxShadow: [
      BoxShadow(
        color: c.withOpacity(opacity),
        blurRadius: blur,
        spreadRadius: -4,
      ),
    ],
  );
}
