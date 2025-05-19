import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class EventosPage extends StatefulWidget {
  const EventosPage({super.key});

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  final List<Map<String, dynamic>> _eventos = [
    {
      'id': 1,
      'titulo': 'Festival Gastronómico Titicaca',
      'fecha': DateTime(2023, 7, 15),
      'ubicacion': 'Plaza Principal, Capachica',
      'descripcion': 'Disfruta de la mejor gastronomía local con platos tradicionales de la región. Habrá concursos, música en vivo y actividades para toda la familia.',
      'imagen': 'gastronomia.jpg',
      'organizador': 'Municipalidad de Capachica',
      'categoria': 'Gastronomía',
    },
    {
      'id': 2,
      'titulo': 'Feria Artesanal 2023',
      'fecha': DateTime(2023, 8, 5),
      'ubicacion': 'Malecón Ecoturístico, Capachica',
      'descripcion': 'Exposición y venta de artesanías locales. Los mejores artesanos de la región mostrarán sus creaciones y habrá talleres gratuitos.',
      'imagen': 'artesania.jpg',
      'organizador': 'Asociación de Artesanos',
      'categoria': 'Artesanía',
    },
    {
      'id': 3,
      'titulo': 'Encuentro de Emprendedores',
      'fecha': DateTime(2023, 7, 25),
      'ubicacion': 'Centro Cultural, Capachica',
      'descripcion': 'Networking, charlas y talleres para emprendedores de la región. Aprende y conecta con otros emprendedores.',
      'imagen': 'emprendedores.jpg',
      'organizador': 'Red de Emprendedores Titicaca',
      'categoria': 'Negocios',
    },
    {
      'id': 4,
      'titulo': 'Festival de Música Andina',
      'fecha': DateTime(2023, 8, 20),
      'ubicacion': 'Anfiteatro Municipal, Capachica',
      'descripcion': 'Concierto con las mejores bandas de música tradicional andina. Celebremos nuestra cultura a través de la música.',
      'imagen': 'musica.jpg',
      'organizador': 'Dirección de Cultura',
      'categoria': 'Música',
    },
    {
      'id': 5,
      'titulo': 'Taller de Fotografía',
      'fecha': DateTime(2023, 7, 10),
      'ubicacion': 'Hotel Andino, Capachica',
      'descripcion': 'Aprende a capturar los mejores paisajes del lago Titicaca con fotógrafos profesionales. Incluye salida de campo.',
      'imagen': 'fotografia.jpg',
      'organizador': 'Club de Fotografía Puno',
      'categoria': 'Educación',
    },
  ];
  
  String _selectedFilter = 'Todos';
  
  List<Map<String, dynamic>> get _filteredEventos {
    if (_selectedFilter == 'Todos') {
      return _eventos;
    } else {
      return _eventos.where((evento) => evento['categoria'] == _selectedFilter).toList();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es');
  }

  @override
  Widget build(BuildContext context) {
    // Obtener categorías únicas
    final categorias = ['Todos', ..._eventos.map((e) => e['categoria'] as String).toSet().toList()];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Eventos',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Descubre los próximos eventos organizados por nuestros emprendedores',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = categorias[index];
                    final isSelected = _selectedFilter == categoria;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ChoiceChip(
                        label: Text(categoria),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = categoria;
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
          child: _filteredEventos.isEmpty
              ? const Center(
                  child: Text('No hay eventos en esta categoría'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _filteredEventos.length,
                  itemBuilder: (context, index) {
                    final evento = _filteredEventos[index];
                    final fecha = DateFormat('d MMM, yyyy').format(evento['fecha']);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen del evento
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: const Icon(Icons.event, size: 80, color: Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orangeAccent.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        evento['categoria'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFFFFA500),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      fecha,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  evento['titulo'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        evento['ubicacion'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  evento['descripcion'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _showEventoDetails(context, evento);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(0xFFFFA500),
                                          side: const BorderSide(color: Color(0xFFFFA500)),
                                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        child: const Text('Ver detalles'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Inscripción no disponible aún'),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF4F455),
                                          foregroundColor: Colors.black,
                                          textStyle: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        child: const Text('Inscribirme'),
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
                ),
        ),
      ],
    );
  }
  
  void _showEventoDetails(BuildContext context, Map<String, dynamic> evento) {
    // Usar un formato simple para evitar problemas de inicialización
    final fecha = evento['fecha'] ?? 'Fecha no disponible';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Línea de arrastre
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Contenido del evento
                    Text(
                      evento['titulo'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Imagen
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.event, size: 80, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    
                    // Detalles del evento
                    _buildDetailRow(Icons.calendar_today, 'Fecha', fecha),
                    const SizedBox(height: 10),
                    _buildDetailRow(Icons.location_on, 'Ubicación', evento['ubicacion']),
                    const SizedBox(height: 10),
                    _buildDetailRow(Icons.business, 'Organizador', evento['organizador']),
                    const SizedBox(height: 20),
                    
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
                      evento['descripcion'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    
                    // Botón de registro
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Inscripción no disponible aún'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4F455),
                          foregroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Inscribirme al evento',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
    );
  }
} 