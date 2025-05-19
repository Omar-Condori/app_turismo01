import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/user_provider.dart';

class PlanesPage extends StatelessWidget {
  const PlanesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Planes y Paquetes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Descubre las mejores experiencias en Capachica',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
          // Paquetes destacados
          _buildPaqueteCard(
            'Experiencia Completa Titicaca',
            'Disfruta de 3 días y 2 noches en Capachica con todo incluido',
            ['Hospedaje', 'Alimentación', 'Paseos en bote', 'Tour guiado'],
            '350.00',
            context,
            userProvider,
          ),
          
          _buildPaqueteCard(
            'Aventura de un día',
            'Conoce los principales atractivos de Capachica en un solo día',
            ['Transporte', 'Almuerzo', 'Tour guiado'],
            '120.00',
            context,
            userProvider,
          ),
          
          _buildPaqueteCard(
            'Fin de semana cultural',
            'Dos días para sumergirte en la cultura local con familias anfitrionas',
            ['Hospedaje', 'Alimentación', 'Actividades culturales', 'Artesanía'],
            '250.00',
            context,
            userProvider,
          ),
          
          _buildPaqueteCard(
            'Retiro de bienestar',
            'Una semana para reconectar con la naturaleza y contigo mismo',
            ['Hospedaje premium', 'Alimentación saludable', 'Yoga', 'Meditación', 'Terapias'],
            '600.00',
            context,
            userProvider,
          ),
          
          const SizedBox(height: 24),
          
          // Información adicional
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFA500).withOpacity(0.3))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFFFFA500)),
                    SizedBox(width: 8),
                    Text(
                      'Información sobre paquetes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFA500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Todos nuestros paquetes incluyen:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfoItem('Guías locales bilingües'),
                _buildInfoItem('Seguro de viaje'),
                _buildInfoItem('Transporte desde puntos designados'),
                _buildInfoItem('Soporte 24/7 durante tu estadía'),
                const SizedBox(height: 12),
                const Text(
                  'Para más información o paquetes personalizados, contáctanos:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text('+51 987 654 321'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text('info@capachicaturismo.com'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPaqueteCard(
    String titulo, 
    String descripcion, 
    List<String> incluye,
    String precio,
    BuildContext context,
    UserProvider userProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del paquete
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            width: double.infinity,
            child: const Icon(Icons.landscape, size: 80, color: Colors.grey),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFA500),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '\$$precio',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  descripcion,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Incluye:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: incluye.map((item) => Chip(
                    label: Text(item, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.grey[200],
                  )).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Mostrar más detalles
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Detalles del paquete no disponibles aún'),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFFA500),
                          side: const BorderSide(color: Color(0xFFFFA500)),
                        ),
                        child: const Text('Ver detalles'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _handleReserva(context, titulo, userProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4F455),
                          foregroundColor: Colors.black,
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
  }
  
  Widget _buildInfoItem(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(texto)),
        ],
      ),
    );
  }
  
  void _handleReserva(BuildContext context, String paquete, UserProvider userProvider) {
    if (!userProvider.isLoggedIn) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Inicio de sesión requerido'),
          content: const Text('Para reservar un paquete, necesitas iniciar sesión o suscribirte.'),
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
    
    // Si el usuario está logueado, mostrar confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reserva de paquete'),
        content: Text('¿Deseas reservar el paquete "$paquete"?'),
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
                  content: Text('Reserva del paquete "$paquete" realizada exitosamente'),
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