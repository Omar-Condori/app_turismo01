import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/emprendedor_model.dart';
import '../../data/providers/api_provider.dart';

class ReservaScreen extends StatefulWidget {
  final Emprendedor emprendedor;

  const ReservaScreen({Key? key, required this.emprendedor}) : super(key: key);

  @override
  State<ReservaScreen> createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _fechaController = TextEditingController();
  final _horaController = TextEditingController();
  final _mensajeController = TextEditingController();
  
  final ApiProvider _apiProvider = ApiProvider();
  
  bool _isLoading = false;
  
  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _fechaController.dispose();
    _horaController.dispose();
    _mensajeController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF4F455), // Color naranja
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _fechaController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF4F455), // Color naranja
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _horaController.text = '${picked.hour.toString().padLeft(2, '0')}:'
                                '${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }
  
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final response = await _apiProvider.realizarReserva(
          emprendedorId: widget.emprendedor.id,
          nombre: _nombreController.text,
          email: _emailController.text,
          fecha: _fechaController.text,
          hora: _horaController.text,
          mensaje: _mensajeController.text,
        );
        
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          if (response.success) {
            _showSuccessDialog();
          } else {
            _showErrorSnackBar(response.message);
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar('Error al procesar la reserva');
        }
      }
    }
  }
  
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Reserva realizada!'),
        content: Text('Se ha realizado tu reserva con ${widget.emprendedor.nombre} exitosamente.'),
        actions: [
          TextButton(
            onPressed: () {
              // Cerrar diálogo y volver a la pantalla anterior
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar', style: TextStyle(color: Color(0xFFF4F455))),
          ),
        ],
      ),
    );
  }
  
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar Reserva'),
        backgroundColor: const Color(0xFFF4F455), // Color naranja
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5DC), // Color beige claro
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reserva para ${widget.emprendedor.nombre}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // Campo de nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo de email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Por favor ingresa un email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo de fecha
              TextFormField(
                controller: _fechaController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una fecha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo de hora
              TextFormField(
                controller: _horaController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                onTap: () => _selectTime(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una hora';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Campo de mensaje (opcional)
              TextFormField(
                controller: _mensajeController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Mensaje (opcional)',
                  prefixIcon: Icon(Icons.message),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              
              // Botón de enviar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4F455), // Color naranja
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'Confirmar Reserva',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 