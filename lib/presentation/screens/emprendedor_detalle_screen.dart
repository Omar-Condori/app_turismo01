import 'package:flutter/material.dart';
import '../../data/models/emprendedor_model.dart';
import '../../data/providers/api_provider.dart';
import 'reserva_screen.dart';

class EmprendedorDetalleScreen extends StatelessWidget {
  final Emprendedor emprendedor;
  final ApiProvider apiProvider = ApiProvider();

  EmprendedorDetalleScreen({Key? key, required this.emprendedor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(emprendedor.nombre),
        backgroundColor: const Color(0xFFFFA500), // Color naranja
        actions: [
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
      backgroundColor: const Color(0xFFF5F5DC), // Color beige claro
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del emprendimiento
            if (emprendedor.imagen != null && emprendedor.imagen!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  emprendedor.imagen!,
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
            if (emprendedor.rubro.isNotEmpty) ...[
              _buildDetailRow(Icons.category, 'Rubro', emprendedor.rubro),
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
            _buildDetailRow(Icons.phone, 'Teléfono', emprendedor.telefono),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservaScreen(emprendedor: emprendedor),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text(
                  'Reservar ahora',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFA500), // Color naranja
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