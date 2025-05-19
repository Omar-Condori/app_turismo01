import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/providers/theme_provider.dart';
import 'config/app_themes.dart';

// A simple app to demonstrate theme switching functionality
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
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