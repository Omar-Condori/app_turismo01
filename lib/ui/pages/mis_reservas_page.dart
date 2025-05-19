import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/reserva_model.dart';
import '../../data/providers/api_provider.dart';
import '../../data/providers/user_provider.dart';

class MisReservasPage extends StatefulWidget {
  const MisReservasPage({super.key});

  @override
  State<MisReservasPage> createState() => _MisReservasPageState();
}

class _MisReservasPageState extends State<MisReservasPage> {
  final ApiProvider _apiProvider = ApiProvider();
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>>? _reservas;

  @override
  void initState() {
    super.initState();
    _loadReservas();
  }

  Future<void> _loadReservas() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn) {
      setState(() {
        _isLoading = false;
        _error = 'Debes iniciar sesión para ver tus reservas';
      });
      return;
    }
    
    try {
      final response = await _apiProvider.getUserReservations(userProvider.token!);
      
      setState(() {
        _isLoading = false;
        if (response.success) {
          _reservas = response.data;
          _error = null;
        } else {
          _error = response.message;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error al cargar las reservas: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (!userProvider.isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Inicia sesión para ver tus reservas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              icon: const Icon(Icons.login),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA500),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              label: const Text('Iniciar sesión', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFA500)),
        ),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadReservas,
              icon: const Icon(Icons.refresh),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA500),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              label: const Text('Reintentar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
    if (_reservas == null || _reservas!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No tienes reservas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explora los emprendimientos y haz tu primera reserva',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/emprendimientos');
              },
              icon: const Icon(Icons.explore),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA500),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              label: const Text('Ver emprendimientos', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
          child: Text(
            'Tus reservas',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _reservas!.length,
            itemBuilder: (context, index) {
              final reserva = _reservas![index];
              final String estado = reserva['estado'] ?? 'Pendiente';
              final Color estadoColor = _getEstadoColor(estado);
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: estadoColor.withOpacity(0.15),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.hotel, color: estadoColor, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              reserva['emprendedor_nombre'] ?? 'Emprendedor #${reserva['emprendedor_id']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: estadoColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              estado,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(Icons.calendar_today, 'Fecha', reserva['fecha'] ?? ''),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.access_time, 'Hora', reserva['hora'] ?? ''),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.category, 'Tipo', reserva['tipo'] ?? 'No especificado'),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF4F455),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              _showReservaDetails(reserva);
                            },
                            icon: const Icon(Icons.info_outline, size: 18),
                            label: const Text('Detalles'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              textStyle: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              _showCancelDialog(reserva);
                            },
                            icon: const Icon(Icons.cancel_outlined, size: 18),
                            label: const Text('Cancelar'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black,
                              textStyle: const TextStyle(fontWeight: FontWeight.bold),
                            ),
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
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
  
  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'confirmada':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  void _showReservaDetails(Map<String, dynamic> reserva) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA500).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFFFFA500),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detalles de la reserva',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: ${reserva['id']}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Información del emprendimiento',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Emprendimiento',
                      reserva['emprendedor_nombre'] ?? 'Emprendedor #${reserva['emprendedor_id']}',
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      'Tipo',
                      reserva['tipo'] ?? 'No especificado',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Detalles de la reserva',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Fecha', reserva['fecha'] ?? ''),
                    const SizedBox(height: 8),
                    _buildDetailRow('Hora', reserva['hora'] ?? ''),
                    const SizedBox(height: 8),
                    _buildDetailRow('Estado', reserva['estado'] ?? 'Pendiente'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA500),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
  
  void _showCancelDialog(Map<String, dynamic> reserva) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: const Text('¿Estás seguro de que deseas cancelar esta reserva?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Simulamos la cancelación
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reserva cancelada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              // Recargamos las reservas para actualizar la UI
              _loadReservas();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }
} 