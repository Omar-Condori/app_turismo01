import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/viewmodels/main_page_viewmodel.dart';
import 'presentation/screens/emprendedor_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainPageViewModel(),
      child: MaterialApp(
        title: 'App Emprendedores',
        theme: ThemeData(
          primaryColor: const Color(0xFFF4F455), // Amarillo verdoso claro
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF4F455),
            background: const Color(0xFFF5F5DC), // Beige claro
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F5DC),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF4F455),
            foregroundColor: Colors.black,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4F455),
              foregroundColor: Colors.black,
            ),
          ),
          useMaterial3: true,
        ),
        home: const EmprendedorScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
} 