import 'package:flutter/material.dart';

class AppThemes {
  // Colores principales de la app
  static const Color primaryColor = Color(0xFFF4F455); // Amarillo verdoso claro
  static const Color lightBackground = Color(0xFFF5F5DC); // Beige claro
  static const Color darkBackground = Color(0xFF121212); // Gris oscuro
  
  // Tema claro
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      background: lightBackground,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    iconTheme: const IconThemeData(
      color: primaryColor,
    ),
    textTheme: TextTheme(
      titleLarge: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: Colors.grey[800],
      ),
      bodyMedium: TextStyle(
        color: Colors.grey[800],
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
    useMaterial3: true,
  );
  
  // Tema oscuro
  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      background: darkBackground,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.grey[850],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    iconTheme: const IconThemeData(
      color: primaryColor,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(
        color: Colors.white70,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[900],
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[400],
    ),
    useMaterial3: true,
  );
} 