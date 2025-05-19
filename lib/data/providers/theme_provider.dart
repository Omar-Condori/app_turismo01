import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // Clave para almacenar preferencia de tema en SharedPreferences
  static const themeKey = 'theme_preference';
  
  // Estado inicial para el tema (light por defecto)
  ThemeMode _themeMode = ThemeMode.light;
  
  // Getter para el tema actual
  ThemeMode get themeMode => _themeMode;
  
  // Getter para saber si está en modo oscuro
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  // Constructor que carga la preferencia de tema almacenada
  ThemeProvider() {
    _loadThemePreference();
  }
  
  // Cargar preferencia de tema desde SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isDark = prefs.getBool(themeKey) ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      print('Error al cargar preferencia de tema: $e');
    }
  }
  
  // Guardar preferencia de tema en SharedPreferences
  Future<void> _saveThemePreference(bool isDark) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(themeKey, isDark);
    } catch (e) {
      print('Error al guardar preferencia de tema: $e');
    }
  }
  
  // Cambiar tema a modo claro
  void setLightMode() {
    _themeMode = ThemeMode.light;
    _saveThemePreference(false);
    notifyListeners();
  }
  
  // Cambiar tema a modo oscuro
  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    _saveThemePreference(true);
    notifyListeners();
  }
  
  // Alternar entre temas claro y oscuro
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemePreference(_themeMode == ThemeMode.dark);
    notifyListeners();
  }
} 