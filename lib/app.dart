import 'package:flutter/material.dart';
import 'presentation/screens/negocio_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  final List<Map<String, String>> negocios = const [
    {
      'nombre': 'Hotel Andino',
      'imagen': 'https://via.placeholder.com/150',
    },
    {
      'nombre': 'Restaurante El Lago',
      'imagen': 'https://via.placeholder.com/150',
    },
    {
      'nombre': 'Tour Capachica',
      'imagen': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: const Text('Registrarse', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: const NegocioScreen(),
    );
  }
}
