import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/viewmodels/main_page_viewmodel.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'data/repositories/auth_repository.dart';
import 'ui/home/main_page.dart';
import 'ui/auth/login_screen.dart';
import 'ui/auth/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainPageViewModel()),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            authRepository: AuthRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Capachica',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainPage(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
