import 'package:flutter/material.dart';

class ServiciosPage extends StatelessWidget {
  const ServiciosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Servicios',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Descubre los servicios que ofrecen nuestros emprendedores',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
          // Servicios destacados
          _buildServiceCategory(
            'Hospedaje',
            [
              _buildServiceItem('Habitaciones', 'Habitaciones cómodas con vista al lago', Icons.hotel),
              _buildServiceItem('Albergues', 'Albergues comunitarios para una experiencia auténtica', Icons.home),
              _buildServiceItem('Cabañas', 'Cabañas privadas con vista panorámica', Icons.cabin),
            ],
          ),
          
          _buildServiceCategory(
            'Gastronomía',
            [
              _buildServiceItem('Restaurantes', 'Comida tradicional con ingredientes locales', Icons.restaurant),
              _buildServiceItem('Cafeterías', 'Desayunos y meriendas tradicionales', Icons.coffee),
              _buildServiceItem('Food trucks', 'Comida rápida con sabor local', Icons.food_bank),
            ],
          ),
          
          _buildServiceCategory(
            'Turismo',
            [
              _buildServiceItem('Tours guiados', 'Recorridos por los principales atractivos', Icons.tour),
              _buildServiceItem('Paseos en bote', 'Navegación por el lago Titicaca', Icons.sailing),
              _buildServiceItem('Caminatas', 'Rutas de senderismo con guías locales', Icons.hiking),
            ],
          ),
          
          _buildServiceCategory(
            'Artesanías',
            [
              _buildServiceItem('Textiles', 'Tejidos tradicionales hechos a mano', Icons.checkroom),
              _buildServiceItem('Cerámica', 'Piezas únicas elaboradas por artesanos locales', Icons.brush),
              _buildServiceItem('Joyería', 'Accesorios elaborados con técnicas ancestrales', Icons.diamond),
            ],
          ),
          
          _buildServiceCategory(
            'Transporte',
            [
              _buildServiceItem('Terrestre', 'Traslados desde y hacia la ciudad', Icons.directions_car),
              _buildServiceItem('Acuático', 'Transporte entre islas y comunidades', Icons.directions_boat),
              _buildServiceItem('Alquiler de bicicletas', 'Explora la región a tu ritmo', Icons.pedal_bike),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Botón de contacto
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función no disponible aún'),
                  ),
                );
              },
              icon: const Icon(Icons.message),
              label: const Text('Consultar servicios adicionales'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF4F455),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildServiceCategory(String title, List<Widget> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...services,
        const Divider(height: 32),
      ],
    );
  }
  
  Widget _buildServiceItem(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFFF4F455),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF4F455),
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(title, style: const TextStyle(color: Colors.black)),
        subtitle: Text(description, style: const TextStyle(color: Colors.black)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
} 