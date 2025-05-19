import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

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

class AppThemes {
  // Colores principales de la app
  static const Color primaryColor = Color(0xFFFFA500); // Naranja
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
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
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
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Theme Demo',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const ThemeDemoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ThemeDemoScreen extends StatelessWidget {
  const ThemeDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Demo'),
        actions: [
          // Theme toggle in app bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                const Icon(Icons.light_mode, size: 20),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: const Color(0xFFFFA500),
                  activeTrackColor: Colors.black45,
                ),
                const Icon(Icons.dark_mode, size: 20),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Theme Demo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // Theme toggle in drawer
            ListTile(
              leading: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              title: Row(
                children: [
                  const Text(
                    'Tema: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    themeProvider.isDarkMode ? 'Oscuro' : 'Claro',
                  ),
                  const Spacer(),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: const Color(0xFFFFA500),
                    activeTrackColor: Colors.black45,
                  ),
                ],
              ),
              onTap: () {
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              themeProvider.isDarkMode ? 'Modo Oscuro Activo' : 'Modo Claro Activo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Cambiar Tema',
                  style: TextStyle(
                    fontSize: 18,
                    color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Ejemplo de Tarjeta',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Este es un ejemplo para mostrar cómo se ve una tarjeta en el tema actual.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Botón presionado'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 