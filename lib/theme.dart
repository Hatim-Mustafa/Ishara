import 'package:flutter/material.dart';

/// Palette chosen for color-blind safety *and* luminance contrast.
///
/// The blue/orange pairing sits on the red-green axis that trips up the most
/// common color blindness. Hue only carries part of the meaning though —
/// position, brightness and motion each carry meaning independently so the
/// signal survives color-insensitive eyes, glare, and peripheral vision.
class IsharaPalette {
  IsharaPalette._();

  /// Bright, high-luminance "go / clear" field.
  static const Color clear = Color(0xFFFFC400);
  static const Color clearBright = Color(0xFFFFE082);

  /// Deep, low-luminance "stop / obstacle" field.
  static const Color obstacle = Color(0xFF0A3D91);

  /// Desaturated slate used when the system is not sure of the path.
  static const Color neutral = Color(0xFF37474F);

  /// Warm arrival field.
  static const Color arrival = Color(0xFFFFF8E1);

  static const Color ink = Color(0xFF0B0F14);
  static const Color paper = Color(0xFFF7F5F0);
  static const Color accent = Color(0xFF1A73E8);
}

ThemeData buildIsharaTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: IsharaPalette.clear,
    brightness: Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: IsharaPalette.paper,
    visualDensity: VisualDensity.standard,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: IsharaPalette.ink,
      elevation: 0,
      centerTitle: true,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(64),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(64, 52),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
