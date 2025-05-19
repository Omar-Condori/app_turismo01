import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../data/models/emprendedor_model.dart';
import '../../data/providers/user_provider.dart';

class EmprendimientosPage extends StatefulWidget {
  const EmprendimientosPage({super.key});

  @override
  State<EmprendimientosPage> createState() => _EmprendimientosPageState();
}

class _EmprendimientosPageState extends State<EmprendimientosPage> {
  late Future<List<Emprendedor>> futureEmprendedores;
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  
  final List<String> _filterOptions = [
    'Todos',
    'Gastronomía',
    'Hospedaje',
    'Turismo',
    'Artesanías',
    'Servicios',
  ];

  @override
  void initState() {
    super.initState();
    futureEmprendedores = fetchEmprendedores();
  }

  Future<List<Emprendedor>> fetchEmprendedores() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/emprendedores'));
      print('API Response Status: ${response.statusCode}');

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

  List<Emprendedor> _filterEmprendedores(List<Emprendedor> emprendedores) {
    return emprendedores.where((emprendedor) {
      // Aplicar filtro de búsqueda
      final searchMatch = _searchQuery.isEmpty || 
          emprendedor.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (emprendedor.descripcion?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      
      // Aplicar filtro de categoría
      final categoryMatch = _selectedFilter == 'Todos' || 
          emprendedor.rubro == _selectedFilter;
      
      return searchMatch && categoryMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Emprendimientos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Descubre y reserva experiencias únicas con nuestros emprendedores',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar emprendimientos...',
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: _filterOptions.length,
                  itemBuilder: (context, index) {
                    final filter = _filterOptions[index];
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        selectedColor: const Color(0xFFFFA500),
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: isSelected ? 2 : 0,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder<List<Emprendedor>>(
            future: futureEmprendedores,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFFA500),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: {snapshot.error}'),
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
              final filteredEmprendedores = _filterEmprendedores(snapshot.data!);
              if (filteredEmprendedores.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off, size: 50, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No se encontraron resultados',
                        style: TextStyle(fontSize: 16),
                      ),
                      if (_searchQuery.isNotEmpty || _selectedFilter != 'Todos')
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _selectedFilter = 'Todos';
                            });
                          },
                          child: const Text('Limpiar filtros'),
                        ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 24),
                itemCount: filteredEmprendedores.length,
                itemBuilder: (context, index) {
                  final emprendedor = filteredEmprendedores[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (emprendedor.logo != null && emprendedor.logo!.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: const Icon(Icons.business, size: 80, color: Colors.grey),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (emprendedor.rubro != null && emprendedor.rubro!.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orangeAccent.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        emprendedor.rubro!,
                                        style: const TextStyle(
                                          color: Color(0xFFFFA500),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  const Spacer(),
                                  const Icon(Icons.star, size: 18, color: Color(0xFFFFA500)),
                                  const SizedBox(width: 2),
                                  const Text('4.8', style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                emprendedor.nombre,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (emprendedor.descripcion != null && emprendedor.descripcion!.isNotEmpty)
                                Text(
                                  emprendedor.descripcion!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        _showDetalleEmprendedor(context, emprendedor);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFFFFA500),
                                        side: const BorderSide(color: Color(0xFFFFA500)),
                                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      child: const Text('Ver más'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _handleReserva(context, emprendedor, userProvider);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFFA500),
                                        foregroundColor: Colors.white,
                                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      child: const Text('Reservar'),
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
        ),
      ],
    );
  }
  
  void _showDetalleEmprendedor(BuildContext context, Emprendedor emprendedor) {
    // Implementar navegación al detalle del emprendedor
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Línea de arrastre
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  
                  // Imagen
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (emprendedor.rubro != null && emprendedor.rubro!.isNotEmpty)
                          Chip(
                            label: Text(emprendedor.rubro!),
                            backgroundColor: Colors.grey[200],
                          ),
                        const SizedBox(height: 16),
                        
                        // Descripción
                        const Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          emprendedor.descripcion ?? 'No hay descripción disponible',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        
                        // Información de contacto
                        const Text(
                          'Información de contacto',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildContactInfo(Icons.phone, 'Teléfono', emprendedor.telefono ?? '-'),
                        _buildContactInfo(Icons.email, 'Email', emprendedor.email ?? '-'),
                        _buildContactInfo(Icons.location_on, 'Dirección', emprendedor.direccion ?? '-'),
                        
                        const SizedBox(height: 24),
                        
                        // Servicios
                        const Text(
                          'Servicios ofrecidos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Lista de servicios según el rubro
                        if (emprendedor.rubro == 'Hospedaje')
                          _buildServicesList([
                            'Habitaciones confortables', 
                            'Desayuno incluido', 
                            'Wifi gratuito',
                            'Servicio de limpieza diario'
                          ])
                        else if (emprendedor.rubro == 'Gastronomía')
                          _buildServicesList([
                            'Comida típica regional', 
                            'Platos a la carta', 
                            'Menú del día',
                            'Atención personalizada'
                          ])
                        else if (emprendedor.rubro == 'Turismo')
                          _buildServicesList([
                            'Tours guiados', 
                            'Transporte incluido', 
                            'Guías bilingües',
                            'Experiencias culturales auténticas'
                          ])
                        else if (emprendedor.rubro == 'Artesanías')
                          _buildServicesList([
                            'Artesanías hechas a mano', 
                            'Talleres artesanales', 
                            'Productos exclusivos',
                            'Envío nacional e internacional'
                          ])
                        else
                          const Text(
                            'Información sobre servicios no disponible para este emprendimiento.',
                            style: TextStyle(fontSize: 16),
                          ),
                          
                        const SizedBox(height: 24),
                        
                        // Botón de reserva
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _handleReserva(context, emprendedor, Provider.of<UserProvider>(context, listen: false));
                            },
                            icon: const Icon(Icons.calendar_today),
                            label: const Text(
                              'Realizar reserva',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFA500),
                              foregroundColor: Colors.white,
                            ),
                          ),
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
    );
  }
  
  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
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
      ),
    );
  }
  
  Widget _buildServicesList(List<String> services) {
    return Column(
      children: services.map((service) => 
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFFFFA500), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(service),
              ),
            ],
          ),
        ),
      ).toList(),
    );
  }
  
  void _handleReserva(BuildContext context, Emprendedor emprendedor, UserProvider userProvider) {
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
                backgroundColor: const Color(0xFFFFA500),
              ),
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      );
      return;
    }
    
    // Si el usuario está logueado, mostrar formulario de reserva
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reserva'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('¿Deseas realizar una reserva con ${emprendedor.nombre}?'),
            const SizedBox(height: 16),
            const Text('Próximamente habilitaremos un formulario completo para reservas.'),
          ],
        ),
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
              backgroundColor: const Color(0xFFFFA500),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
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
  {
    'id': '4',
    'nombre': 'Artesanías Titicaca',
    'rubro': 'Artesanías',
    'telefono': '+51 987654324',
    'email': 'ventas@artesaniastiticaca.com',
    'direccion': 'Calle Artesanal 789, Capachica',
    'descripcion': 'Elaboramos artesanías tradicionales hechas a mano con técnicas ancestrales.',
  },
  {
    'id': '5',
    'nombre': 'Transportes Puno',
    'rubro': 'Servicios',
    'telefono': '+51 987654325',
    'email': 'contacto@transportespuno.com',
    'direccion': 'Terminal Terrestre, Capachica',
    'descripcion': 'Servicio de transporte turístico a todos los destinos de la región.',
  },
]; 