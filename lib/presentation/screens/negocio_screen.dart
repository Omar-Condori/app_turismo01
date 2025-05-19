import 'package:flutter/material.dart';
import '../../data/models/negocio_model.dart';
import '../../services/negocio_service.dart';

class NegocioScreen extends StatefulWidget {
  const NegocioScreen({super.key});

  @override
  State<NegocioScreen> createState() => _NegocioScreenState();
}

class _NegocioScreenState extends State<NegocioScreen> {
  final NegocioService _service = NegocioService();
  List<Negocio>? _negocios;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNegocios();
  }

  Future<void> _loadNegocios() async {
    try {
      final negocios = await _service.getNegocios();
      setState(() {
        _negocios = negocios;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleReserva(Negocio negocio) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reserva iniciada para: ${negocio.nombre}'),
        duration: const Duration(seconds: 2),
      ),
    );
    print('Reserva para negocio ID: ${negocio.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Negocios Disponibles'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error', 
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNegocios,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_negocios == null || _negocios!.isEmpty) {
      return const Center(
        child: Text('No hay negocios disponibles'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNegocios,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _negocios!.length,
        itemBuilder: (context, index) {
          final negocio = _negocios![index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (negocio.imagen != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      negocio.imagen!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 50),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        negocio.nombre,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        negocio.descripcion,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.category, size: 16),
                          const SizedBox(width: 4),
                          Text('Rubro: ${negocio.rubro}'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Expanded(child: Text('Dirección: ${negocio.direccion}')),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16),
                          const SizedBox(width: 4),
                          Text('Teléfono: ${negocio.telefono}'),
                        ],
                      ),
                      if (negocio.email != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 16),
                            const SizedBox(width: 4),
                            Text('Email: ${negocio.email}'),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _handleReserva(negocio),
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Reservar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
      ),
    );
  }
} 