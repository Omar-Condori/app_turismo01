import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'ui/auth/login_screen.dart';
import 'ui/auth/register_screen.dart';
import 'data/providers/user_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const SimpleApp(),
    ),
  );
}

class SimpleApp extends StatelessWidget {
  const SimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Emprendedores',
      theme: ThemeData(
        primaryColor: const Color(0xFFF4F455),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF4F455),
          background: const Color(0xFFF5F5DC),
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
      initialRoute: '/',
      routes: {
        '/': (context) => const EmprendedoresScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class Emprendedor {
  final int id;
  final String nombre;
  final String? rubro;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? descripcion;
  final String? logo;

  Emprendedor({
    required this.id,
    required this.nombre,
    this.rubro,
    this.telefono,
    this.email,
    this.direccion,
    this.descripcion,
    this.logo,
  });

  factory Emprendedor.fromJson(Map<String, dynamic> json) {
    return Emprendedor(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? 'Sin nombre',
      rubro: json['rubro'] as String?,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      direccion: json['direccion'] as String?,
      descripcion: json['descripcion'] as String?,
      logo: json['logo'] as String?,
    );
  }
}

class EmprendedoresScreen extends StatefulWidget {
  const EmprendedoresScreen({super.key});

  @override
  State<EmprendedoresScreen> createState() => _EmprendedoresScreenState();
}

class _EmprendedoresScreenState extends State<EmprendedoresScreen> {
  late Future<List<Emprendedor>> futureEmprendedores;

  @override
  void initState() {
    super.initState();
    futureEmprendedores = fetchEmprendedores();
  }

  Future<List<Emprendedor>> fetchEmprendedores() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/emprendedores'));
      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> emprendedoresJson = jsonData is List 
            ? jsonData 
            : (jsonData['data'] is List ? jsonData['data'] : []);
            
        return emprendedoresJson.map((json) => Emprendedor.fromJson(json)).toList();
      } else {
        throw Exception('No se pudieron cargar los emprendedores: ${response.statusCode}');
      }
    } catch (e) {
      // Si hay un error de conexión, cargamos los datos de prueba
      print('Error al cargar datos: $e');
      return _mockEmprendedores.map((data) => Emprendedor(
        id: int.parse(data['id']!),
        nombre: data['nombre']!,
        rubro: data['rubro']!,
        telefono: data['telefono']!,
        email: data['email']!,
        direccion: data['direccion']!,
        descripcion: data['descripcion']!,
      )).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emprendedores'),
        actions: [
          if (userProvider.isLoggedIn)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    userProvider.user?.name ?? 'Usuario',
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, size: 18),
                    onPressed: () {
                      // Cerrar sesión
                      userProvider.clearUser();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Has cerrado sesión'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          else
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: FutureBuilder<List<Emprendedor>>(
        future: futureEmprendedores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF4F455),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureEmprendedores = fetchEmprendedores();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay emprendedores disponibles'),
            );
          }

          final emprendedores = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: emprendedores.length,
            itemBuilder: (context, index) {
              final emprendedor = emprendedores[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen del emprendimiento (opcional)
                    if (emprendedor.logo != null && emprendedor.logo!.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          emprendedor.logo!,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: double.infinity,
                            height: 180,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: const Icon(Icons.business, size: 80, color: Colors.grey),
                      ),
                    
                    // Información del emprendimiento
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emprendedor.nombre,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (emprendedor.rubro != null && emprendedor.rubro!.isNotEmpty)
                            Chip(
                              label: Text(emprendedor.rubro!),
                              backgroundColor: Colors.grey[200],
                            ),
                          const SizedBox(height: 10),
                          if (emprendedor.descripcion != null && emprendedor.descripcion!.isNotEmpty)
                            Text(
                              emprendedor.descripcion!,
                              style: const TextStyle(fontSize: 16),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EmprendedorDetalleScreen(emprendedor: emprendedor),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.visibility),
                                label: const Text('Ver más'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF4F455),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _showReservaDialog(context, emprendedor);
                                },
                                icon: const Icon(Icons.calendar_today),
                                label: const Text('Reservar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF4F455),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showReservaDialog(BuildContext context, Emprendedor emprendedor) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Inicio de sesión requerido'),
          content: const Text('Para realizar una reserva, necesitas iniciar sesión o suscribirte.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4F455),
              ),
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reserva'),
        content: Text('¿Deseas realizar una reserva con ${emprendedor.nombre}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reserva con ${emprendedor.nombre} realizada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4F455),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

class EmprendedorDetalleScreen extends StatelessWidget {
  final Emprendedor emprendedor;

  const EmprendedorDetalleScreen({super.key, required this.emprendedor});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(emprendedor.nombre),
        actions: [
          if (userProvider.isLoggedIn)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    userProvider.user?.name ?? 'Usuario',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          else
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
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
            // Imagen del emprendimiento
            if (emprendedor.logo != null && emprendedor.logo!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  emprendedor.logo!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 50),
                    );
                  },
                ),
              )
            else
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
            
            // Nombre del emprendimiento
            Text(
              emprendedor.nombre,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Sección de rubro
            if (emprendedor.rubro != null && emprendedor.rubro!.isNotEmpty) ...[
              _buildDetailRow(Icons.category, 'Rubro', emprendedor.rubro!),
              const SizedBox(height: 12),
            ],
            
            // Descripción
            if (emprendedor.descripcion != null && emprendedor.descripcion!.isNotEmpty) ...[
              const Text(
                'Descripción:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                emprendedor.descripcion!,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
            
            // Información de contacto
            const Text(
              'Información de contacto:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (emprendedor.telefono != null && emprendedor.telefono!.isNotEmpty)
              _buildDetailRow(Icons.phone, 'Teléfono', emprendedor.telefono!),
            if (emprendedor.email != null && emprendedor.email!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildDetailRow(Icons.email, 'Email', emprendedor.email!),
            ],
            if (emprendedor.direccion != null && emprendedor.direccion!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildDetailRow(Icons.location_on, 'Dirección', emprendedor.direccion!),
            ],
            
            const SizedBox(height: 32),
            
            // Botón de reserva
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  _handleReserva(context, emprendedor);
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text(
                  'Reservar ahora',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4F455),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Sección de negocios - Puede implementarse más adelante
            const SizedBox(height: 32),
            const Text(
              'Servicios ofrecidos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (emprendedor.rubro == 'Hospedaje') ...[
              _buildServiceItem('Habitaciones cómodas'),
              _buildServiceItem('Desayuno incluido'),
              _buildServiceItem('Wi-Fi gratuito'),
              _buildServiceItem('Tours locales'),
            ] else if (emprendedor.rubro == 'Gastronomía') ...[
              _buildServiceItem('Platos típicos de la región'),
              _buildServiceItem('Menú variado'),
              _buildServiceItem('Ingredientes locales frescos'),
              _buildServiceItem('Atención personalizada'),
            ] else if (emprendedor.rubro == 'Turismo') ...[
              _buildServiceItem('Tours guiados'),
              _buildServiceItem('Transporte incluido'),
              _buildServiceItem('Guías bilingües'),
              _buildServiceItem('Experiencias culturales auténticas'),
            ] else
              const Text(
                'Próximamente podrás ver todos los servicios ofrecidos por este emprendimiento.',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  void _handleReserva(BuildContext context, Emprendedor emprendedor) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Inicio de sesión requerido'),
          content: const Text('Para realizar una reserva, necesitas iniciar sesión o suscribirte.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4F455),
              ),
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Reserva realizada!'),
        content: Text('Se ha realizado tu reserva con ${emprendedor.nombre} exitosamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar', style: TextStyle(color: Color(0xFFF4F455))),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String service) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFFF4F455), size: 20),
          const SizedBox(width: 8),
          Text(
            service,
            style: const TextStyle(fontSize: 16),
          ),
        ],
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

// Datos de prueba (solo se usan si falla la conexión a la API)
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