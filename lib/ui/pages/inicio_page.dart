import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../data/providers/user_provider.dart';
import '../../data/models/emprendedor_model.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  // Variables para almacenar los datos de los endpoints
  Map<String, dynamic>? _municipalidadData;
  List<dynamic>? _emprendedoresData;
  List<dynamic>? _eventosData;
  List<dynamic>? _asociacionesData;
  List<dynamic>? _categoriasData;
  
  bool _isLoading = true;
  Map<String, String> _errorMessages = {};
  
  @override
  void initState() {
    super.initState();
    _loadAllData();
  }
  
  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
    });
    
    // Lista de futuros para ejecutar todas las peticiones en paralelo
    await Future.wait([
      _fetchMunicipalidad(),
      _fetchEmprendedores(),
      _fetchEventos(),
      _fetchAsociaciones(),
      _fetchCategorias(),
    ]);
    
    setState(() {
      _isLoading = false;
    });
  }
  
  Future<void> _fetchMunicipalidad() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/municipalidad'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _municipalidadData = jsonData;
        });
      } else {
        // Si hay error, usar datos simulados
        setState(() {
          _municipalidadData = {
            'nombre': 'Municipalidad de Capachica',
            'descripcion': 'Municipalidad distrital encargada del desarrollo local y turístico de la península de Capachica.',
            'direccion': 'Plaza Principal s/n, Capachica, Puno',
            'telefono': '+51 123456789',
            'email': 'municipalidad@capachica.gob.pe',
            'horario': 'Lunes a Viernes de 8:00 a 16:00',
            'web': 'www.capachica.gob.pe'
          };
        });
      }
    } catch (e) {
      // Si hay error de conexión, usar datos simulados
      setState(() {
        _municipalidadData = {
          'nombre': 'Municipalidad de Capachica',
          'descripcion': 'Municipalidad distrital encargada del desarrollo local y turístico de la península de Capachica.',
          'direccion': 'Plaza Principal s/n, Capachica, Puno',
          'telefono': '+51 123456789',
          'email': 'municipalidad@capachica.gob.pe',
          'horario': 'Lunes a Viernes de 8:00 a 16:00',
          'web': 'www.capachica.gob.pe'
        };
      });
    }
  }
  
  Future<void> _fetchEmprendedores() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/emprendedores'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _emprendedoresData = jsonData is List ? jsonData : (jsonData['data'] is List ? jsonData['data'] : []);
        });
      } else {
        // Datos simulados
        setState(() {
          _emprendedoresData = [
            {
              'id': 1,
              'nombre': 'Hotel Andino',
              'rubro': 'Hospedaje',
              'descripcion': 'Hotel con vista al lago Titicaca, ofrecemos habitaciones confortables y servicio de calidad.',
              'telefono': '+51 987654321',
              'email': 'contacto@hotelandino.com',
              'direccion': 'Av. Principal 123, Capachica'
            },
            {
              'id': 2,
              'nombre': 'Restaurante El Lago',
              'rubro': 'Gastronomía',
              'descripcion': 'Restaurante especializado en comida típica de la región con ingredientes locales y frescos.',
              'telefono': '+51 987654322',
              'email': 'reservas@ellago.com',
              'direccion': 'Jr. Puno 456, Capachica'
            },
            {
              'id': 3,
              'nombre': 'Tour Capachica',
              'rubro': 'Turismo',
              'descripcion': 'Ofrecemos tours guiados por la península de Capachica y las islas del Titicaca.',
              'telefono': '+51 987654323',
              'email': 'info@tourcapachica.com',
              'direccion': 'Plaza de Armas s/n, Capachica'
            }
          ];
        });
      }
    } catch (e) {
      // Datos simulados
      setState(() {
        _emprendedoresData = [
          {
            'id': 1,
            'nombre': 'Hotel Andino',
            'rubro': 'Hospedaje',
            'descripcion': 'Hotel con vista al lago Titicaca, ofrecemos habitaciones confortables y servicio de calidad.',
            'telefono': '+51 987654321',
            'email': 'contacto@hotelandino.com',
            'direccion': 'Av. Principal 123, Capachica'
          },
          {
            'id': 2,
            'nombre': 'Restaurante El Lago',
            'rubro': 'Gastronomía',
            'descripcion': 'Restaurante especializado en comida típica de la región con ingredientes locales y frescos.',
            'telefono': '+51 987654322',
            'email': 'reservas@ellago.com',
            'direccion': 'Jr. Puno 456, Capachica'
          },
          {
            'id': 3,
            'nombre': 'Tour Capachica',
            'rubro': 'Turismo',
            'descripcion': 'Ofrecemos tours guiados por la península de Capachica y las islas del Titicaca.',
            'telefono': '+51 987654323',
            'email': 'info@tourcapachica.com',
            'direccion': 'Plaza de Armas s/n, Capachica'
          }
        ];
      });
    }
  }
  
  Future<void> _fetchEventos() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/eventos'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _eventosData = jsonData is List ? jsonData : (jsonData['data'] is List ? jsonData['data'] : []);
        });
      } else {
        // Datos simulados
        setState(() {
          _eventosData = [
            {
              'id': 1,
              'titulo': 'Festival Gastronómico Titicaca',
              'fecha': '15 Jul, 2023',
              'ubicacion': 'Plaza Principal, Capachica',
              'descripcion': 'Disfruta de la mejor gastronomía local con platos tradicionales de la región.',
              'categoria': 'Gastronomía'
            },
            {
              'id': 2,
              'titulo': 'Feria Artesanal 2023',
              'fecha': '05 Ago, 2023',
              'ubicacion': 'Malecón Ecoturístico, Capachica',
              'descripcion': 'Exposición y venta de artesanías locales.',
              'categoria': 'Artesanía'
            },
            {
              'id': 3,
              'titulo': 'Encuentro de Emprendedores',
              'fecha': '25 Jul, 2023',
              'ubicacion': 'Centro Cultural, Capachica',
              'descripcion': 'Networking, charlas y talleres para emprendedores de la región.',
              'categoria': 'Negocios'
            },
            {
              'id': 4,
              'titulo': 'Festival de Música Andina',
              'fecha': '20 Ago, 2023',
              'ubicacion': 'Anfiteatro Municipal, Capachica',
              'descripcion': 'Concierto con las mejores bandas de música tradicional andina.',
              'categoria': 'Música'
            }
          ];
        });
      }
    } catch (e) {
      // Datos simulados
      setState(() {
        _eventosData = [
          {
            'id': 1,
            'titulo': 'Festival Gastronómico Titicaca',
            'fecha': '15 Jul, 2023',
            'ubicacion': 'Plaza Principal, Capachica',
            'descripcion': 'Disfruta de la mejor gastronomía local con platos tradicionales de la región.',
            'categoria': 'Gastronomía'
          },
          {
            'id': 2,
            'titulo': 'Feria Artesanal 2023',
            'fecha': '05 Ago, 2023',
            'ubicacion': 'Malecón Ecoturístico, Capachica',
            'descripcion': 'Exposición y venta de artesanías locales.',
            'categoria': 'Artesanía'
          },
          {
            'id': 3,
            'titulo': 'Encuentro de Emprendedores',
            'fecha': '25 Jul, 2023',
            'ubicacion': 'Centro Cultural, Capachica',
            'descripcion': 'Networking, charlas y talleres para emprendedores de la región.',
            'categoria': 'Negocios'
          },
          {
            'id': 4,
            'titulo': 'Festival de Música Andina',
            'fecha': '20 Ago, 2023',
            'ubicacion': 'Anfiteatro Municipal, Capachica',
            'descripcion': 'Concierto con las mejores bandas de música tradicional andina.',
            'categoria': 'Música'
          }
        ];
      });
    }
  }
  
  Future<void> _fetchAsociaciones() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/asociaciones'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _asociacionesData = jsonData is List ? jsonData : (jsonData['data'] is List ? jsonData['data'] : []);
        });
      } else {
        // Datos simulados
        setState(() {
          _asociacionesData = [
            {
              'id': 1,
              'nombre': 'Asociación de Artesanos de Capachica',
              'descripcion': 'Agrupación de artesanos locales dedicados a preservar técnicas tradicionales.',
              'contacto': 'artesanos@capachica.org',
              'miembros': 25
            },
            {
              'id': 2,
              'nombre': 'Red de Hospedajes Turísticos',
              'descripcion': 'Conectamos a turistas con las mejores opciones de hospedaje en la península.',
              'contacto': 'hospedajes@capachica.org',
              'miembros': 18
            },
            {
              'id': 3,
              'nombre': 'Asociación Gastronómica Titicaca',
              'descripcion': 'Promovemos la gastronomía local y las tradiciones culinarias de la región.',
              'contacto': 'gastronomia@capachica.org',
              'miembros': 30
            }
          ];
        });
      }
    } catch (e) {
      // Datos simulados
      setState(() {
        _asociacionesData = [
          {
            'id': 1,
            'nombre': 'Asociación de Artesanos de Capachica',
            'descripcion': 'Agrupación de artesanos locales dedicados a preservar técnicas tradicionales.',
            'contacto': 'artesanos@capachica.org',
            'miembros': 25
          },
          {
            'id': 2,
            'nombre': 'Red de Hospedajes Turísticos',
            'descripcion': 'Conectamos a turistas con las mejores opciones de hospedaje en la península.',
            'contacto': 'hospedajes@capachica.org',
            'miembros': 18
          },
          {
            'id': 3,
            'nombre': 'Asociación Gastronómica Titicaca',
            'descripcion': 'Promovemos la gastronomía local y las tradiciones culinarias de la región.',
            'contacto': 'gastronomia@capachica.org',
            'miembros': 30
          }
        ];
      });
    }
  }
  
  Future<void> _fetchCategorias() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/categorias'));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _categoriasData = jsonData is List ? jsonData : (jsonData['data'] is List ? jsonData['data'] : []);
        });
      } else {
        // Datos simulados
        setState(() {
          _categoriasData = [
            {'id': 1, 'nombre': 'Gastronomía', 'descripcion': 'Restaurantes y servicios de comida'},
            {'id': 2, 'nombre': 'Hospedaje', 'descripcion': 'Hoteles, hostales y alojamientos'},
            {'id': 3, 'nombre': 'Turismo', 'descripcion': 'Tours y actividades turísticas'},
            {'id': 4, 'nombre': 'Artesanías', 'descripcion': 'Artesanías y productos locales'},
            {'id': 5, 'nombre': 'Transporte', 'descripcion': 'Servicios de transporte terrestre y lacustre'}
          ];
        });
      }
    } catch (e) {
      // Datos simulados
      setState(() {
        _categoriasData = [
          {'id': 1, 'nombre': 'Gastronomía', 'descripcion': 'Restaurantes y servicios de comida'},
          {'id': 2, 'nombre': 'Hospedaje', 'descripcion': 'Hoteles, hostales y alojamientos'},
          {'id': 3, 'nombre': 'Turismo', 'descripcion': 'Tours y actividades turísticas'},
          {'id': 4, 'nombre': 'Artesanías', 'descripcion': 'Artesanías y productos locales'},
          {'id': 5, 'nombre': 'Transporte', 'descripcion': 'Servicios de transporte terrestre y lacustre'}
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFF4F455),
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Leagues'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'For you',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF4F455),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      children: [
                        Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        Icon(Icons.flash_on, color: Colors.black),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Días
              Row(
                children: [
                  _buildDayCircle('W', true),
                  _buildDayCircle('Th', false),
                  _buildDayCircle('F', false),
                  _buildDayCircle('S', false),
                  _buildDayCircle('Su', false),
                ],
              ),
              const SizedBox(height: 20),
              // Card práctica rápida
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF4F455),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Color(0xFFF4F455)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.play_circle_fill, color: Colors.black, size: 28),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sharpen your skills in 3 mins with a quick practice session',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF4F455),
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Start practice', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text('Jump back in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 16),
              // Card Jump back in
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Color(0xFFF4F455), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFE6EFFF),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                      ),
                      child: Center(
                        child: Icon(Icons.change_history, size: 60, color: Colors.blue[300]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Foundational Math', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text('LEVEL 1', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text('1.1 Solving Equations', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: 0.3,
                            backgroundColor: Color(0xFFE6EFFF),
                            color: Color(0xFFF4F455),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Aquí puedes continuar con cards de categorías, etc.
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCircle(String label, bool active) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: active ? Color(0xFFF4F455) : Colors.white,
          border: Border.all(color: Color(0xFFF4F455), width: 2),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Icon(Icons.flash_on, color: active ? Colors.black : Colors.black26, size: 28),
        ),
      ),
    );
  }
} 