// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/providers/user_provider.dart';
import 'data/providers/theme_provider.dart';
import 'ui/auth/login_screen.dart';
import 'ui/auth/register_screen.dart';
import 'ui/home/home_screen.dart';
import 'config/app_themes.dart';
import 'data/services/emprendedor_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDummyKey123456789',
        appId: '1:123456789:ios:abcdef1234567890',
        messagingSenderId: '123456789',
        projectId: 'flutter-emprendedores',
        storageBucket: 'flutter-emprendedores.appspot.com',
      ),
    );
    
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Error al inicializar Firebase: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error al inicializar la aplicación: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'App Emprendedores',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class EmprendedoresScreen extends StatefulWidget {
  const EmprendedoresScreen({super.key});

  @override
  State<EmprendedoresScreen> createState() => _EmprendedoresScreenState();
}

class _EmprendedoresScreenState extends State<EmprendedoresScreen> {
  List<Map<String, dynamic>> _emprendedores = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEmprendedores();
  }

  Future<void> _loadEmprendedores() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final emprendedores = await EmprendedorService.getEmprendedores();
      
      setState(() {
        _emprendedores = emprendedores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emprendedores'),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de login disponible pronto'),
                ),
              );
            },
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $_error',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadEmprendedores,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _emprendedores.length,
                  itemBuilder: (context, index) {
                    final emprendedor = _emprendedores[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          emprendedor['nombre'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rubro: ${emprendedor['rubro'] ?? ''}'),
                            Text('Teléfono: ${emprendedor['telefono'] ?? ''}'),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFFFA500)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmprendedorDetalleScreen(emprendedor: emprendedor),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class EmprendedorDetalleScreen extends StatelessWidget {
  final Map<String, dynamic> emprendedor;

  const EmprendedorDetalleScreen({super.key, required this.emprendedor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(emprendedor['nombre'] ?? ''),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de login disponible pronto'),
                ),
              );
            },
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.business, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              emprendedor['nombre'] ?? '',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.category, 'Rubro', emprendedor['rubro'] ?? ''),
            const SizedBox(height: 12),
            const Text(
              'Descripción:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              emprendedor['descripcion'] ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Información de contacto:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.phone, 'Teléfono', emprendedor['telefono'] ?? ''),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.email, 'Email', emprendedor['email'] ?? ''),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.location_on, 'Dirección', emprendedor['direccion'] ?? ''),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('¡Reserva realizada!'),
                      content: Text('Se ha realizado tu reserva con ${emprendedor['nombre']} exitosamente.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Aceptar', style: TextStyle(color: Color(0xFFFFA500))),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text(
                  'Reservar ahora',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA500),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Datos de prueba
final List<Map<String, String>> _mockEmprendedores = [
  {
    'id': '1',
    'nombre': 'Hotel Andino',
    'rubro': 'Hospedaje',
    'telefono': '+51 987654321',
    'email': 'contacto@hotelandino.com',
    'direccion': 'Av. Principal 123, Capachica',
    'descripcion': 'Hotel con vista al lago Titicaca, ofrecemos habitaciones confortables y servicio de calidad.',
  },
  {
    'id': '2',
    'nombre': 'Restaurante El Lago',
    'rubro': 'Gastronomía',
    'telefono': '+51 987654322',
    'email': 'reservas@ellago.com',
    'direccion': 'Jr. Puno 456, Capachica',
    'descripcion': 'Restaurante especializado en comida típica de la región con ingredientes locales y frescos.',
  },
  {
    'id': '3',
    'nombre': 'Tour Capachica',
    'rubro': 'Turismo',
    'telefono': '+51 987654323',
    'email': 'info@tourcapachica.com',
    'direccion': 'Plaza de Armas s/n, Capachica',
    'descripcion': 'Ofrecemos tours guiados por la península de Capachica y las islas del Titicaca.',
  },
];